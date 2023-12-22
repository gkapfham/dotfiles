#!/usr/bin/env bash

# use rofi to select from the clipboard using the clipmenu program

# always use rofi as the selection mechanism
export CM_LAUNCHER=rofi

# display twelve lines of text in the menu
export CM_HISTLENGTH=12

# run clipmenu that runs rofi and will
# select the value into the clipboard;
# note that you need to paste with a
# <CTRL-v> in order to insert the
# content into the selected area
clipmenu
