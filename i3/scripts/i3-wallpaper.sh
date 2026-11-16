#!/usr/bin/env bash
# i3-wallpaper.sh — apply the current wallpaper when i3 starts.
#
# The image is published by ~/configure/wallpaper/bin/wallpaper (see that
# repository's README).  /var/lib/wallpaper is a mutable pointer *outside* the
# Nix store, which is what lets a new wallpaper appear at login without a
# rebuild.  Before the first wallpaper has been chosen the pointer does not
# exist, so fall back to a solid colour -- which is also what a fresh machine
# should look like.
#
# desktop.png is a screen-sized derivative, so feh does not have to decode the
# full 6016x3900 image on every i3 start; current.png is the fallback.
#
# Run from i3/config as an exec_always, so it also runs on every reload.

set -euo pipefail

desktop=/var/lib/wallpaper/desktop.png
current=/var/lib/wallpaper/current.png
solid='#6E466E'

if [ -r "$desktop" ] && feh --bg-fill "$desktop"; then
  exit 0
fi

if [ -r "$current" ] && feh --bg-fill "$current"; then
  exit 0
fi

exec hsetroot -solid "$solid"
