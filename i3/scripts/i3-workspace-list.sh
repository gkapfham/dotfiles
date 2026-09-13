#!/usr/bin/env bash

# ── i3 workspace list & switcher via rofi ───────────────────────────────────
# Shows every workspace grouped by monitor output, with a summary of the
# application windows on each workspace. Selecting a workspace switches to it.
#
# Dependencies: i3 (i3-msg), jq, rofi

set -euo pipefail

entry=$(i3-msg -t get_tree | jq -r '
    [ .. | select(.type? == "workspace" and .name != "__i3_scratch") ]
    | map(
        .name as $wsname
        | .output as $wsout
        | .focused as $wsfocused
        | {
            name: $wsname,
            output: $wsout,
            focused: $wsfocused,
            apps: (
                [ .. | select(.window_properties?.class? != null) ]
                | map(.window_properties.class | sub("com\\.mitchellh\\.ghostty"; "ghostty"; "g"))
                | unique
                | sort
                | join(", ")
            )
        }
    )
    | sort_by(.output, (.name | tonumber? // 9999999))
    | group_by(.output)
    | .[]
    | "󰍹  \(.[0].output)",
      ( .[]
        | "\(.name)\(if .apps != "" then "   \(.apps)" else "" end)\(if .focused then "  ◂" else "" end)"
      )
')

selected=$(echo "$entry" | rofi -dmenu -p " " -i -no-custom -width 120)

# Switch to the selected workspace (skip separators and empty selections)
if [ -n "$selected" ]; then
    ws=$(echo "$selected" | awk '{print $1}')
    # Only act if the first word looks like a workspace identifier
    if [[ "$ws" =~ ^[0-9a-zA-Z]+$ ]]; then
        i3-msg workspace number "$ws" >/dev/null
    fi
fi
