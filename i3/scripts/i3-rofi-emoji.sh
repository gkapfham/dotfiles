#!/usr/bin/env bash

# i3-rofi-emoji.sh — the emoji picker as a rofi mode (the emoji tab of the omni
# launcher).
#
# rofimoji cannot be a rofi mode: it drives its own rofi instance, and rofi only
# runs one instance at a time (pidfile lock in $XDG_RUNTIME_DIR/rofi.pid), so
# launching it from a running omni menu would be refused. Instead this reads
# rofimoji's own character data, so the set of emoji matches rofimoji, and
# types the chosen character into the focused window the same way the standalone
# nerd-font picker inserts a glyph (clipboard fallback).
#
# Used as the emoji tab of the omni launcher (i3-run-rofi-full-path.sh).

set -euo pipefail

# locate rofimoji's data next to the installed executable (store path safe)
rofimoji_bin=$(command -v rofimoji || true)
data=""
if [ -n "$rofimoji_bin" ]; then
  data=$(ls -d "$(dirname "$(readlink -f "$rofimoji_bin")")"/../lib/python*/site-packages/picker/data 2>/dev/null | head -1 || true)
fi

case "${ROFI_RETV:-0}" in
  0)
    printf '\0prompt\x1f󰏘\n'
    [ -n "$data" ] || exit 0
    # rows are "<emoji> <name> <small>(keywords)</small>"; drop the markup
    cat "$data"/emojis_*.csv 2>/dev/null | sed -E 's/<[^>]*>//g'
    ;;
  1)
    [ -n "${1:-}" ] || exit 0
    emoji=$(printf '%s' "$1" | awk '{print $1}')
    [ -n "$emoji" ] || exit 0
    # put it on the clipboard as well, so the same emoji can be pasted again
    printf '%s' "$emoji" | xsel -i -b 2>/dev/null || true
    xdotool type --clearmodifiers -- "$emoji" 2>/dev/null || true
    ;;
  *) ;;
esac
