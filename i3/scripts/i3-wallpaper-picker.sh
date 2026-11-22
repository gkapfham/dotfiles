#!/usr/bin/env bash
# i3-wallpaper-picker.sh — choose a wallpaper from a rofi menu.
#
# The wallpaper logic lives with the generator, in ~/configure/wallpaper, so
# this is only the i3-side entry point, matching the other i3-*.sh scripts.
# It opens a rofi list of every wallpaper you can choose from, each row showing
# the image itself as a thumbnail, and applies whatever you pick to the desktop,
# the lock screen and (at the next login) the LightDM greeter.
#
# Needs: rofi, and the `wallpaper` command on PATH (stowed from the dotfiles
# repository as programs/wallpaper -> ~/.local/bin/wallpaper).
#
# WALLPAPER_PROMPT (optional): override the menu prompt.
# WALLPAPER_CMD    (optional): use a different wallpaper command.

set -euo pipefail

wallpaper=${WALLPAPER_CMD:-$HOME/.local/bin/wallpaper}

if [ ! -x "$wallpaper" ]; then
  printf 'i3-wallpaper-picker.sh: %s is missing or not executable\n' \
    "$wallpaper" >&2
  printf '  the generator repository is not checked out at ~/configure/wallpaper\n' >&2
  exit 1
fi

exec "$wallpaper" pick
