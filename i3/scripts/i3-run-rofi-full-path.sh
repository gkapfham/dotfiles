#!/usr/bin/env bash

# set the PATH to include a "local" bin if it exists;
# note that otherwise rofi does not detect these scripts
# because i3 is started directly by NixOS it seems
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# run the rofi command to pickup everything, including
# those scripts that are defined in the ~/.local/bin/ directory
rofi -show combi -modes combi -combi-modes 'run,window,drun'
