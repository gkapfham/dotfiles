#!/bin/bash

function gen_workspaces()
{
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}

WORKSPACE=$( (gen_workspaces) | rofi -width 30 -dmenu -p "workspace:")
i3-msg workspace "${WORKSPACE}"
