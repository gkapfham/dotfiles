#!/usr/bin/env bash

# i3-rofi-workspaces.sh — the workspace list as a rofi mode.
#
# The list itself comes from i3-workspace-list.sh --print, so the standalone
# menu (Control+Alt+W) and this omni tab can never drift apart. Rofi calls this
# with no arguments on startup (ROFI_RETV=0) to get the list, and again with
# the chosen entry (ROFI_RETV=1) to switch to that workspace. The prompt is set
# here so the tab can stay icon-only.
#
# Used as the workspaces tab of the omni launcher (i3-run-rofi-full-path.sh).

set -euo pipefail

case "${ROFI_RETV:-0}" in
  0)
    printf '\0prompt\x1f󰕰\n'
    exec "$HOME/.config/i3/scripts/i3-workspace-list.sh" --print
    ;;
  1)
    # entries are "name  <apps>  ◂"; monitor headings start with the monitor
    # glyph and are ignored, exactly as the standalone menu does
    ws=$(printf '%s' "$1" | awk '{print $1}')
    if [[ "$ws" =~ ^[0-9a-zA-Z]+$ ]]; then
      i3-msg workspace number "$ws" >/dev/null
    fi
    ;;
  *) ;;
esac
