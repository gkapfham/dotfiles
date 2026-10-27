#!/usr/bin/env bash

# i3-rofi-zoxide.sh
# Use rofi to select a directory from zoxide and open it in ghostty

# Get list of directories from zoxide
SELECTED_DIR=$(zoxide query -l | rofi -dmenu -i -p "󰉋 " -display-dmenu "󰉋 ")

# If a directory was selected, open ghostty there
if [ -n "$SELECTED_DIR" ]; then
    ghostty --working-directory="$SELECTED_DIR"
fi
