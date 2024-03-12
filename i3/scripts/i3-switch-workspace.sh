#!/usr/bin/env bash

# extract workspace names from i3 using the i3-msg tool
function gen_workspaces()
{
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}

# use rofi to filter workspaces in a case-insensitive fashion
WORKSPACE=$( (gen_workspaces) | rofi -dmenu -i -p "workspace")
i3-msg workspace "${WORKSPACE}"
