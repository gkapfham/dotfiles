#!/bin/bash

# use rofi to select from the clipboard using the clipmenu program

# always use rofi as the selection mechanism
export CM_LAUNCHER=rofi

# display twelve lines of text in the menu
export CM_HISTLENGTH=12

# run clipmenu that runs rofi and
# then paste into selected area with xdotool
clipmenu && xdotool key shift+Insert
