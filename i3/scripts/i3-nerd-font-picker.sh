#!/usr/bin/env bash

# i3-nerd-font-picker.sh — standalone Nerd Font glyph picker (Control+Alt+E).
#
# The picker itself lives in i3-rofi-nerdfont.sh, a rofi script mode that is
# also the nerd-fonts tab of the omni launcher, so the standalone menu and the
# omni tab can never drift apart.

set -euo pipefail

exec rofi -modes "nerd-fonts:$HOME/.config/i3/scripts/i3-rofi-nerdfont.sh" -show nerd-fonts
