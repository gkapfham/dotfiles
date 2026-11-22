#!/usr/bin/env bash

# i3-screenshot-capture.sh <full|active|region> — capture to the clipboard.
#
# Shared by the power menu's screenshot submenu and the swipe-gesture menu.
# The capture happens in a detached process ~0.4 s later: these menus run while
# rofi is still on screen, so capturing immediately would include the menu (and
# a region drag needs the pointer back). The confirmation goes to notify-send,
# because a nested rofi cannot start while one is already running.

set -euo pipefail

case "${1:-}" in
  full)   what="Full screen";   cmd="maim" ;;
  active) what="Active window"; cmd="maim -i \$(xdotool getactivewindow)" ;;
  region) what="Region";        cmd="maim -s" ;;
  *) echo "usage: $0 <full|active|region>" >&2; exit 2 ;;
esac

setsid sh -c "sleep 0.4; $cmd | xclip -selection clipboard -t image/png && \
  notify-send 'Screenshot' '$what copied to the clipboard'" >/dev/null 2>&1 &
