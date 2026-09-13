#!/usr/bin/env bash

# set the PATH to include a "local" bin if it exists;
# note that otherwise rofi does not detect these scripts
# because i3 is started directly by NixOS it seems
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Path to the custom run-icons modi script
ROFI_RUN_SCRIPT="$HOME/.config/i3/scripts/i3-rofi-run-icons.sh"
ROFI_RUN_ICON=""
ROFI_DRUN_ICON=""
ROFI_COMBI_MODES="${1:-run-icons,window,drun}"
export ROFI_RUN_ICON

# Use the custom nerd-font icon modi if available;
# otherwise fall back to the native run mode unchanged
if [ -x "$ROFI_RUN_SCRIPT" ]; then
    rofi \
        -show combi \
        -modes "combi,run-icons:$ROFI_RUN_SCRIPT" \
        -combi-modes "$ROFI_COMBI_MODES" \
        -display-run "$ROFI_RUN_ICON" \
        -display-drun "$ROFI_DRUN_ICON" \
        -drun-display-format "$ROFI_DRUN_ICON  {name}"
else
    rofi \
        -show combi \
        -modes combi \
        -combi-modes "${ROFI_COMBI_MODES/run-icons/run}" \
        -display-run "$ROFI_RUN_ICON" \
        -display-drun "$ROFI_DRUN_ICON" \
        -drun-display-format "$ROFI_DRUN_ICON  {name}"
fi
