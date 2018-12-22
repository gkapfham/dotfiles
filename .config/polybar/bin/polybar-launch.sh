#!/bin/bash

# kill any running instances
killall -q polybar

# kill confirmed
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch polybar
polybar mybar &
