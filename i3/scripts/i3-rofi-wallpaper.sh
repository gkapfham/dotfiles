#!/usr/bin/env bash

# i3-rofi-wallpaper.sh — the wallpaper picker as a rofi mode (the wallpaper tab
# of the omni launcher).
#
# Each row carries its own image through dmenu's per-row icon protocol, so the
# list doubles as a contact sheet, and picking a row applies it through the same
# `wallpaper use` path the standalone picker uses. The thumbnail size comes from
# the `theme` script option, so the tab looks like `wallpaper pick` does.
#
# Used as the wallpaper tab of the omni launcher (i3-run-rofi-full-path.sh).

set -euo pipefail

wallpaper=${WALLPAPER_CMD:-$HOME/.local/bin/wallpaper}
repo=${WALLPAPER_REPO:-$HOME/configure/wallpaper}

case "${ROFI_RETV:-0}" in
  0)
    printf '\0prompt\x1f󰋩\n'
    printf '\0theme\x1felement-icon { size: 4em; }\n'
    for d in wallpapers previews; do
      [ -d "$repo/$d" ] || continue
      for f in "$repo/$d"/*.png "$repo/$d"/*.jpg "$repo/$d"/*.jpeg "$repo/$d"/*.webp; do
        [ -f "$f" ] || continue
        # ${f##*/} rather than $(basename -- "$f"): rofi runs this mode at every
        # launch even when the tab is never opened, and one basename fork per
        # file cost ~90 ms of this tab's ~100 ms.
        printf '%s\0icon\x1f%s\n' "$d/${f##*/}" "$f"
      done
    done
    ;;
  1)
    [ -n "${1:-}" ] || exit 0
    exec "$wallpaper" use "$1"
    ;;
  *) ;;
esac
