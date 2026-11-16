#!/usr/bin/env bash

# i3-lock-screen-betterlock.sh — lock the screen, and never leave it unlocked.
#
# More than one call to betterlockscreen, because:
#
#  * betterlockscreen pre-renders one canvas per *monitor layout*. Change the
#    layout (dock, undock, move the laptop panel) and the cached canvas no longer
#    matches the screen, so the wallpaper shows at the wrong size. Nothing used to
#    notice: the cache was only rebuilt when the wallpaper image changed. Here the
#    cached canvas is compared with the live screen and refreshed in the
#    background (~30 s) when they differ.
#  * betterlockscreen can exit without locking anything: its own "i3lock already
#    running" bail-out, an i3lock-color option it does not understand, or an X
#    grab still held by something on screen. So every attempt is checked — a
#    locker process has to appear — and if none does, the next candidate is tried,
#    ending with a plain, image-less, option-less lock.
#  * whatever the attempts printed is kept in $log, so a failure can be explained
#    instead of leaving the screen silently unlocked (the old version threw that
#    output away).
#
# The 0.25 s delay lets rofi (or whatever asked for the lock) close first.

set -uo pipefail

cache=${XDG_CACHE_HOME:-$HOME/.cache}/betterlockscreen
canvas="$cache/current/lock_blur.png"
image=${WALLPAPER_CURRENT:-/var/lib/wallpaper/current.png}
log=${LOCK_LOG:-/tmp/i3lock-failure.log}

screen_size() { xrandr --current 2>/dev/null | sed -n 's/.*current \([0-9]*\) x \([0-9]*\).*/\1x\2/p'; }
canvas_size() { [ -f "$canvas" ] && identify -format '%wx%h' "$canvas" 2>/dev/null || true; }
locker_running() { pgrep -x i3lock-color >/dev/null 2>&1 || pgrep -x i3lock >/dev/null 2>&1; }

# the lockers on this machine: i3lock-color from PATH, then from the store (that
# is where betterlockscreen keeps its own), then plain i3lock
locker_candidates() {
  local c
  for c in "$(command -v i3lock-color 2>/dev/null)" /nix/store/*i3lock-color*/bin/i3lock-color; do
    [ -n "$c" ] && [ -x "$c" ] && printf '%s\n' "$c"
  done
  c=$(command -v i3lock 2>/dev/null)
  [ -n "$c" ] && [ -x "$c" ] && printf '%s\n' "$c"
}

# i3lock refuses to run while another client holds the keyboard/pointer grab,
# and that is exactly the case when the lock is requested from a rofi menu: a
# script-mode action runs *before* rofi closes, so rofi still owns the grab and
# i3lock dies with "Cannot grab pointer/keyboard" (visible in the session
# journal). Wait for the usual holders to go, then retry on that specific error.

wait_for_grab_holders() {
  local _ 
  for _ in $(seq 1 40); do          # up to ~10 s
    pgrep -x rofi >/dev/null 2>&1 || return 0
    sleep 0.25
  done
}

# start an attempt and wait for it: 0 = it locked (and was later unlocked),
# 1 = it went away without locking. "Cannot grab" is retried, since the holder
# is usually rofi on its way out.
attempt() {
  local pid tries=0
  while :; do
    : >"$log"
    "$@" >>"$log" 2>&1 &
    pid=$!
    for _ in $(seq 1 25); do
      if locker_running; then wait "$pid" 2>/dev/null; return 0; fi
      kill -0 "$pid" 2>/dev/null || break
      sleep 0.1
    done
    kill "$pid" 2>/dev/null
    grep -qi "cannot grab" "$log" || return 1
    tries=$((tries + 1))
    [ "$tries" -lt 8 ] || return 1
    sleep 0.4
  done
}

wait_for_grab_holders

# stale canvas for this monitor layout? refresh it in the background (~30 s)
if [ "$(screen_size)" != "$(canvas_size)" ] && [ -f "$image" ]; then
  nohup setsid betterlockscreen -u "$image" >/dev/null 2>&1 &
fi

# 1. betterlockscreen, with the pre-rendered lock screen
if attempt betterlockscreen --lock; then
  rm -f "$log"; exit 0
fi

# 2. the lockers themselves, plainly: no image, no options that could be refused
while read -r candidate; do
  if attempt "$candidate" -n; then
    rm -f "$log"; exit 0
  fi
done < <(locker_candidates)

# 3. nothing worked: leave the evidence where it can be found (the journal is
#    where the "Cannot grab pointer/keyboard" that started this came from)
reason=$(tr '\n' ' ' <"$log" 2>/dev/null | head -c 300)
logger -t i3-lock "screen did NOT lock: ${reason:-no output from the lockers}" 2>/dev/null || true
notify-send -u critical "Screen did not lock" "${reason:-see $log}" 2>/dev/null || true
exit 1
