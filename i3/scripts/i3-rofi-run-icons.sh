#!/usr/bin/env bash

# Fast custom rofi modi for run mode with nerd-font icons.
# Uses the native rofi runcache for history ordering and updates
# it directly on selection.  List generation is amortised via a
# compiled cache that is invalidated automatically when the
# runcache changes or $PATH changes.

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
PATH_HASH=$(printf '%s' "$PATH" | cksum | awk '{print $1}')
RUNCACHE=$(ls -t "$CACHE_DIR"/rofi-*.runcache 2>/dev/null | head -n 1)
COMPILED="$CACHE_DIR/rofi-run-icons-compiled.$PATH_HASH"

# Selection confirmed: strip icon and run, then update native cache
if [[ "$1" == * ]]; then
    cmd="${1# }"

    if [[ -n "$RUNCACHE" && -f "$RUNCACHE" ]]; then
        tmpfile="${RUNCACHE}.tmp.$$"
        awk -F'\x1f' -v c="$cmd" '
        BEGIN { found = 0 }
        {
            if (match($1, /^([0-9]+) (.+)$/, m)) {
                score = m[1] + 0
                name = m[2]
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

    exec "$cmd"
fi

# List generation: reuse compiled cache when the runcache has
# not changed since the cache was built.  Otherwise rebuild
# atomically and then emit the result.
if [[ -f "$COMPILED" && -n "$RUNCACHE" && "$RUNCACHE" -ot "$COMPILED" ]]; then
    cat "$COMPILED"
else
    tmpfile="${COMPILED}.tmp.$$"
    {
        if [[ -n "$RUNCACHE" && -f "$RUNCACHE" ]]; then
            awk -F'\x1f' 'match($1, /^([0-9]+) (.+)$/, m) { print m[1], m[2] }' "$RUNCACHE" | sort -k1,1 -nr | awk '{print $2}'
        fi
        compgen -c | sort -u
    } | awk '!seen[$0]++' | sed 's/^/ /' > "$tmpfile" && mv "$tmpfile" "$COMPILED"
    cat "$COMPILED"
fi
