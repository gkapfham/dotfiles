#!/usr/bin/env bash

# i3-keymaps.sh — standalone reminders menu (Control+Alt+R).
#
# The menu is i3-rofi-keymaps.sh, a rofi script mode that is also the keymaps tab
# of the omni launcher, so both entry points show the same list and both run the
# keybinding you pick.

set -euo pipefail

exec rofi -modes "keymaps:$HOME/.config/i3/scripts/i3-rofi-keymaps.sh" -show keymaps
