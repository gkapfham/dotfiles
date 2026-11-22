#!/usr/bin/env bash

# i3-rofi-nerdfont.sh — Nerd Font glyph picker as a rofi mode.
#
# Rofi calls this with no prompt arguments to get the list (ROFI_RETV=0) and
# again with the chosen row (ROFI_RETV=1); the chosen glyph is typed into the
# focused window, the same way the standalone picker has always inserted it
# (clipboard fallback). Used both as a standalone menu — i3-nerd-font-picker.sh
# is now a thin wrapper around this — and as the nerd-fonts tab of the omni
# launcher (i3-run-rofi-full-path.sh).
#
# The glyph list is the Nerd Fonts glyphnames database, cached locally, as is
# the row list built from it by jq (see the ROFI_RETV=0 branch).

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nerd-font-icons"
CACHE_FILE="$CACHE_DIR/glyphnames.json"
LIST_CACHE="$CACHE_DIR/glyphnames.v1.list"
GLYPHNAMES_URL="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json"

case "${ROFI_RETV:-0}" in
  0)
    printf '\0prompt\x1f󰛖\n'
    command -v jq >/dev/null 2>&1 || exit 0
    mkdir -p "$CACHE_DIR"
    if [ ! -f "$CACHE_FILE" ]; then
      command -v curl >/dev/null 2>&1 || exit 0
      curl -fsS "$GLYPHNAMES_URL" -o "$CACHE_FILE" || exit 0
    fi
    # Rofi runs every mode at startup, including a tab that is never opened,
    # so the jq pass over the 523 KB database (~40 ms) is cached and rebuilt
    # only when the database is newer. The list goes through a temp file so an
    # interrupted build cannot be read back as a valid cache.
    if [ ! -s "$LIST_CACHE" ] || [ "$CACHE_FILE" -nt "$LIST_CACHE" ]; then
      tmp="$LIST_CACHE.$$"
      if jq -r '. | to_entries[] | select(.key != "METADATA") | "\(.value.char) \(.key)"' "$CACHE_FILE" > "$tmp"; then
        mv "$tmp" "$LIST_CACHE"
      else
        rm -f "$tmp"
        exit 1
      fi
    fi
    cat "$LIST_CACHE"
    ;;
  1)
    [ -n "${1:-}" ] || exit 0
    glyph=$(printf '%s' "$1" | awk '{printf "%s", $1}')
    [ -n "$glyph" ] || exit 0
    # put it on the clipboard as well, so the same glyph can be pasted again
    printf '%s' "$glyph" | xsel -i -b 2>/dev/null || true
    xdotool type --clearmodifiers -- "$glyph" 2>/dev/null || true
    ;;
  *) ;;
esac
