#!/usr/bin/env bash

# i3-rofi-rename-workspace.sh — rename the focused workspace from a rofi prompt
# (Control+Alt+A). The prompt uses the same icon-only style as the omni tabs,
# and the new name is passed as one argument, so names with spaces survive
# (the old inline `i3-msg rename workspace to $(rofi ...)` split on spaces).

set -euo pipefail

name=$(rofi -dmenu -lines 0 -p '󰑕') || exit 0
[ -n "$name" ] || exit 0
i3-msg rename workspace to "$name" >/dev/null
