#!/usr/bin/env bash

# Note: the commented out source code is the old
# version of the script used for prior laptops before
# I started using the Framework 13 laptop and NixOS.
# This is the new version that works correctly for the
# Framework laptop and the NixOS operating system.

# # kill any running instances
# killall -q polybar
#
# # kill confirmed
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
#
# # launch polybar for laptop
# # polybar mybar &
#
# # launch polybar for all available monitors reported by xrandr
# # reference: https://github.com/polybar/polybar/issues/763
# if type "xrandr"; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar --reload mybar &
#   done
# else
#   # polybar --reload mybar &
#   polybar mybar &
# fi

# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bars, note that this will disable the same
# polybar on all monitors, regardless of their resolution
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar mybar &
done
