#!/usr/bin/env bash

maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png
echo "󰹑 Screenshot Taken and Copied to Clipboard" | rofi -width 75 -dmenu -i
