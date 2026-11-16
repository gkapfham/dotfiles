#!/usr/bin/env bash
#
# File: i3/scripts/quickshell-launch.sh
#
# Start the quickshell bar once, and restart it only when the running copy has
# actually gone stale.
#
#   quickshell-launch.sh          ensure exactly one healthy bar   (i3 runs this)
#   quickshell-launch.sh restart  stop whatever is running, then start one
#   quickshell-launch.sh stop     stop the bar
#   quickshell-launch.sh status   print the pid, its health, and the bar count
#
# i3 runs this from `exec_always`, so it runs at startup and again on every
# reload and restart, which means it has to be idempotent. `quickshell -n` alone
# is not enough, and that is what this script exists to fix.
#
# Two failures are repaired here, both seen on this machine on 2026-10-21:
#
#   1. A stale output. The 4K panel moved from the DP-7 connector to DP-8, but
#      xrandr kept both in its monitor list at +0+0. Quickshell draws one bar per
#      screen, so it drew three: two stacked at the top of the 4K panel and one
#      on the laptop. Any output that xrandr still presents as a monitor while
#      the driver reports it disconnected is switched off first.
#
#   2. A bar whose i3 IPC died. i3 restarts in place -- same pid, same socket
#      path, a new socket inode -- and quickshell 0.3.0 does not reconnect
#      afterwards, so every workspace row goes blank and clicks do nothing. The
#      socket's ctime says when i3 last bound it; if that is later than the
#      bar's own start time, the bar cannot be talking to the i3 that is running
#      now. `-n` does not save us there: the stale instance is still alive, so a
#      second copy is refused and the broken bar survives the restart.
#
# When the bar is already running and healthy this script changes nothing, so an
# ordinary `i3-msg reload` never blinks the bar.
#
# Stopping the bar by hand: `quickshell kill` (never `pkill -x quickshell`; the
# Nix wrapper renames the process, so an exact-name match finds nothing), then
# comment out the exec_always line in i3/config, or run this script with
# `restart` to bring it straight back.
set -u

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell"
log_file="$state_dir/launch.log"

log() {
    mkdir -p "$state_dir" 2>/dev/null
    printf '%s %s\n' "$(date '+%F %T')" "$*" >> "$log_file" 2>/dev/null
}

# The bar runs as `quickshell -n`. Match the binary in argv[0] rather than the
# process name (the Nix wrapper renames that to .quickshell-wra) and rather than
# a substring of the whole command line, which would also match this script and
# any shell whose command happens to mention "quickshell".
bar_pids() {
    local pid first
    for pid in $(pgrep -f 'quickshell' 2>/dev/null); do
        [ "$pid" = "$$" ] && continue
        # 2>/dev/null before the redirect: a process can exit between pgrep and
        # this read, and the shell reports a failed input redirect on its own
        # stderr, where the command's 2>/- would never see it.
        first=$(tr '\0' '\n' 2>/dev/null < "/proc/$pid/cmdline" | head -n 1)
        [ "${first##*/}" = "quickshell" ] && printf '%s\n' "$pid"
    done
}

start_bar() {
    log "starting quickshell"
    setsid --fork quickshell -n >/dev/null 2>&1 < /dev/null
}

stop_bars() {
    local pid waited

    for pid in $(bar_pids); do
        log "stopping pid $pid"
        # The supported way out: it asks the instance to exit over its own IPC.
        quickshell kill >/dev/null 2>&1

        waited=0
        while [ -d "/proc/$pid" ] && [ "$waited" -lt 50 ]; do
            sleep 0.1
            waited=$((waited + 1))
        done

        [ -d "/proc/$pid" ] && kill "$pid" 2>/dev/null
    done
}

# ---- repair 1: outputs the driver dropped but xrandr still presents ---------
#
# `xrandr --listmonitors` is the list clients see (and the one Qt turns into
# QScreens); `xrandr --query` is the driver's per-connector view. A name in the
# first that the second calls disconnected is the phantom that produced three
# bars for two panels.
turn_off_stale_outputs() {
    local query name

    query=$(xrandr --query 2>/dev/null) || return 0

    for name in $(xrandr --listmonitors 2>/dev/null | awk 'NR > 1 { print $NF }'); do
        case "$query" in
            *"$name disconnected"*)
                xrandr --output "$name" --off 2>/dev/null \
                    && log "turned off stale output $name"
                ;;
        esac
    done
}

# ---- repair 2: a bar whose i3 IPC predates i3's current socket --------------
i3_socket_time() {
    local sock

    sock=$(i3 --get-socketpath 2>/dev/null) || return 1
    [ -S "$sock" ] || return 1
    stat -c %Z "$sock" 2>/dev/null
}

bar_is_stale() {
    local pid="$1" sock_time bar_time

    sock_time=$(i3_socket_time) || return 1
    # The ctime of /proc/<pid> is the moment the process started.
    bar_time=$(stat -c %Z "/proc/$pid" 2>/dev/null) || return 1

    [ "$sock_time" -gt "$bar_time" ]
}

# ---- verification: one bar per screen position ------------------------------
#
# Quickshell draws exactly one 60px-tall window per screen it is given, so a
# count tells us whether the bar and the display agree. Screens sharing an x/y
# are one place on the desk and legitimately share one bar.
bar_count() {
    xwininfo -root -tree 2>/dev/null | grep '"quickshell"' | grep -c 'x60+'
}

screen_count() {
    xrandr --listmonitors 2>/dev/null \
        | awk 'NR > 1 { g = $3; sub(/^[0-9]+\/[0-9]+x[0-9]+\/[0-9]+/, "", g); print g }' \
        | sort -u | wc -l
}

verify() {
    local want got

    want=$(screen_count)
    got=$(bar_count)

    if [ "$want" != "$got" ]; then
        log "mismatch: $want screen position(s) but $got bar(s)"
        notify-send "Quickshell bar" \
            "$got bar(s) for $want screen position(s) -- see $log_file" 2>/dev/null
        return 1
    fi

    log "ok: $got bar(s) for $want screen position(s)"
    return 0
}

# ---- main ------------------------------------------------------------------
mode="${1:-ensure}"

case "$mode" in
    stop)
        stop_bars
        ;;

    restart)
        stop_bars
        turn_off_stale_outputs
        start_bar
        sleep 2
        verify
        ;;

    status)
        for pid in $(bar_pids); do
            if bar_is_stale "$pid"; then
                echo "pid $pid: STALE (i3 has rebound its IPC socket since)"
            else
                echo "pid $pid: healthy"
            fi
        done
        [ -z "$(bar_pids)" ] && echo "no bar running"
        echo "screens: $(screen_count) position(s), bars: $(bar_count)"
        ;;

    *)
        turn_off_stale_outputs

        started=0
        for pid in $(bar_pids); do
            if bar_is_stale "$pid"; then
                log "pid $pid predates i3's current IPC socket; restarting"
                stop_bars
                start_bar
                started=1
                break
            fi
        done

        if [ -z "$(bar_pids)" ] && [ "$started" = 0 ]; then
            start_bar
            started=1
        fi

        if [ "$started" = 1 ]; then
            sleep 2
            verify
        fi
        ;;
esac
