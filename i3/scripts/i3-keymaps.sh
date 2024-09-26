#!/usr/bin/env bash

# show keybindings set in the i3 config file
I3_CONFIG=$HOME/.config/i3/config
mod_key=$(sed -nre 's/^set \$mod (.*)/\1/p' ${I3_CONFIG})
grep "^bindsym" ${I3_CONFIG} \
    | sed "s/-\(-\w\+\)\+//g;s/\$mod/${mod_key}/g;s/Mod1/Alt/g;s/exec //;s/bindsym //;s/^\s\+//;s/^\([^ ]\+\) \(.\+\)$/\2: \1/;s/^\s\+//" \
    | tr -s ' ' \
    | rofi -width 75 -dmenu -i -p Reminder:
