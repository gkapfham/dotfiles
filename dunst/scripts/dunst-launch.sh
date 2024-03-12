#!/usr/bin/env bash

# kill any running instances
killall -q dunst

# kill confirmed
while pgrep -u $UID -x dunst >/dev/null; do sleep 1; done

# launch dunst
dunst -config ~/.config/dunst/dunstrc
