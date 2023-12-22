#!/usr/bin/env bash

# Simple and fast lockscreen that blurs current window;
# note that there is a short delay before the screen is
# locked, so you can see the current window blurred and
# not actually see the rofi menu that ran this script
sleep 0.1
i3lock-fancy-rapid 5 3 -u
