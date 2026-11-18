#!/usr/bin/env bash

# i3-system.sh — standalone system menu (Control+Alt+plus).
#
# The menu itself is i3-rofi-system.sh, a rofi script mode that is also the power
# tab of the omni launcher, so both entry points offer exactly the same options
# (including the screenshot submenu). Any argument is ignored.

set -euo pipefail

exec rofi -modes "power:$HOME/.config/i3/scripts/i3-rofi-system.sh" -show power
