#!/usr/bin/env bash

# Fast custom rofi modi for run mode with nerd-font icons.
# Uses the native rofi runcache for history ordering and updates
# it directly on selection. List generation is amortised via a
# compiled cache that is invalidated automatically when the
# runcache changes or $PATH changes.

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
RUN_ICON="${ROFI_RUN_ICON:-}"
RUN_PREFIX="${RUN_ICON}  "
LEGACY_RUN_ICONS='^(||󰘳|󰍉|󰊠|󰎔)[[:space:]]+'
PATH_HASH=$(printf '%s' "$PATH" | cksum | awk '{print $1}')
RUNCACHE=""
for candidate in "$CACHE_DIR"/rofi-*.runcache; do
    [[ -e "$candidate" ]] || continue
    if [[ -z "$RUNCACHE" || "$candidate" -nt "$RUNCACHE" ]]; then
        RUNCACHE="$candidate"
    fi
done
COMPILED="$CACHE_DIR/rofi-run-icons-compiled.$PATH_HASH"
COMPILED_HEADER="# rofi-run-icons cache v2"

strip_legacy_prefix() {
    printf '%s\n' "$1" | perl -CSDA -pe 's/'"$LEGACY_RUN_ICONS"'//'
}

sanitize_runcache_file() {
    [[ -f "$1" ]] || return
    tmpfile="$1.tmp.$$"
    awk -F'\x1f' '
    {
        if (match($1, /^([0-9]+) (.+)$/, m)) {
            score = m[1] + 0
            name = m[2]
            sub(/^(||󰘳|󰍉|󰊠|󰎔)[[:space:]]+/, "", name)
            if (!(name in best_score) || score > best_score[name]) {
                best_score[name] = score
            }
        } else {
            passthrough[++passthrough_count] = $0
        }
    }
    END {
        for (name in best_score) {
            print best_score[name] " " name "\x1f\x27" name "\x27"
        }
        for (i = 1; i <= passthrough_count; i++) {
            print passthrough[i]
        }
    }
    ' "$1" > "$tmpfile" && mv "$tmpfile" "$1"
}

compiled_cache_is_current() {
    [[ -f "$COMPILED" ]] || return 1
    IFS= read -r first_line < "$COMPILED" || return 1
    [[ "$first_line" == "$COMPILED_HEADER" ]]
}

for cache_file in "$CACHE_DIR"/rofi-*.runcache; do
    [[ -e "$cache_file" ]] || continue
    sanitize_runcache_file "$cache_file"
done

# Selection confirmed: strip icon and run, then update native cache.
# Handle both a selected listed entry and a custom typed command.
if [[ ${ROFI_RETV:-0} -eq 1 && "$1" == "$RUN_PREFIX"* ]]; then
    cmd="${1#"$RUN_PREFIX"}"
elif [[ ${ROFI_RETV:-0} -eq 2 && -n "$1" ]]; then
    cmd="$1"
fi

if [[ -n "$cmd" ]]; then
    cmd=$(strip_legacy_prefix "$cmd")

    if [[ -n "$RUNCACHE" && -f "$RUNCACHE" ]]; then
        tmpfile="${RUNCACHE}.tmp.$$"
        awk -F'\x1f' -v c="$cmd" '
        BEGIN { found = 0 }
        {
            if (match($1, /^([0-9]+) (.+)$/, m)) {
                score = m[1] + 0
                name = m[2]
                sub(/^(||󰘳|󰍉|󰊠|󰎔)[[:space:]]+/, "", name)
                if (name == c) {
                    score++
                    found = 1
                }
                print score " " name "\x1f\x27" name "\x27"
            } else {
                print
            }
        }
        END {
            if (!found) {
                print "1 " c "\x1f\x27" c "\x27"
            }
        }
        ' "$RUNCACHE" > "$tmpfile" && mv "$tmpfile" "$RUNCACHE"
    fi

    # exec "$cmd"

    # # THE FIX: Launch as a detached systemd user service
    # # This prevents the parent script from hanging or crashing the session
    # systemd-run --user --scope --unit="rofi-run-$cmd" \
    #     --description="Rofi Run: $cmd" \
    #     bash -c "exec $cmd" >/dev/null 2>&1 &

    # THE FIX FOR i3 + NixOS:
    # Use i3-msg to spawn the process. This preserves DPI, fonts, and scaling.
    # The '--no-startup-id' flag prevents the "busy" cursor in i3.
    printf -v launch_cmd 'exec --no-startup-id env PATH=%q sh -lc %q' "$PATH" "$cmd"
    i3-msg -q "$launch_cmd" >/dev/null
    exit 0

fi

# List generation: reuse compiled cache when the runcache has
# not changed since the cache was built.  Otherwise rebuild
# atomically and then emit the result.
if compiled_cache_is_current && [[ -n "$RUNCACHE" && "$RUNCACHE" -ot "$COMPILED" ]]; then
    awk -v prefix="$RUN_PREFIX" 'NR > 1 && NF { print prefix $0 }' "$COMPILED"
else
    tmpfile="${COMPILED}.tmp.$$"
    {
        printf '%s\n' "$COMPILED_HEADER"
        if [[ -n "$RUNCACHE" && -f "$RUNCACHE" ]]; then
            awk -F'\x1f' '
            match($1, /^([0-9]+) (.+)$/, m) {
                name = m[2]
                sub(/^(||󰘳|󰍉|󰊠|󰎔)[[:space:]]+/, "", name)
                printf "%s\t%s\n", m[1], name
            }
            ' "$RUNCACHE" | sort -t $'\t' -k1,1 -nr | cut -f2-
        fi
        compgen -c | sort -u
    } | awk 'NF && !seen[$0]++' > "$tmpfile" && mv "$tmpfile" "$COMPILED"
    awk -v prefix="$RUN_PREFIX" 'NR > 1 && NF { print prefix $0 }' "$COMPILED"
fi
