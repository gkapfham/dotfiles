#!/usr/bin/env bash

# kill any running instances
killall -q polybar

# kill confirmed
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch polybar for laptop
# polybar mybar &

# launch polybar for all available monitors reported by xrandr
# reference: https://github.com/polybar/polybar/issues/763
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload mybar &
  done
else
  polybar --reload mybar &
fi
