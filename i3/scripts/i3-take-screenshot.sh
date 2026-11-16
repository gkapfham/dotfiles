#!/usr/bin/env bash

# i3-take-screenshot.sh — screenshot menu, opened directly on that level of the
# power menu (four-finger swipe up, see libinput-gestures.conf).

set -euo pipefail

exec env ROFI_SCREENSHOT=1 rofi -modes "power:$HOME/.config/i3/scripts/i3-rofi-system.sh" -show power
