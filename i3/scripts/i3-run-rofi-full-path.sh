#!/usr/bin/env bash

# set the PATH to include a "local" bin if it exists;
# note that otherwise rofi does not detect these scripts
# because i3 is started directly by NixOS it seems
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Path to the custom run-icons modi script
ROFI_RUN_SCRIPT="$HOME/.config/i3/scripts/i3-rofi-run-icons.sh"
ROFI_RUN_ICON="󰷐"
ROFI_DRUN_ICON="󰵆"
# The custom mode's name doubles as its tab label, so it is an icon: rofi only
# honours display-* for its built-in modes, and a bare mode name would print
# the word "run-icons" on the tab.
ROFI_RUN_MODE="󰷐"
ROFI_COMBI_MODES="${1:-$ROFI_RUN_MODE,window,drun}"
# Row icons for the run-icons modi and drun rows. The *tab* icons are set
# by display-* in rofi/config.rasi (one Material Design set), so every
# tab in the omni bar has the same drawn size.
export ROFI_RUN_ICON

# Minimal.rasi styles the mode buttons (mode-switcher/button) but rofi 2.0's
# default layout only packs inputbar/message/listview, so the tab bar has to be
# asked for explicitly. That is what ROFI_TABS=1 does (the Control+Alt+O
# binding): one tab per mode, active tab blue. Without it this stays the plain
# combi launcher (Control+Alt+P).
ROFI_MODE_TABS='mainbox { children: [inputbar, mode-switcher, message, listview]; }'

# Use the custom nerd-font icon modi if available; otherwise fall back to the
# native run mode. Every mode gets its own tab next to the omni "combi" tab,
# so Control+Tab switches between the merged list and a single source. Tab
# icons come from the mode names / display-* in rofi/config.rasi.
if [ -x "$ROFI_RUN_SCRIPT" ]; then
    ROFI_CUSTOM="${ROFI_RUN_MODE}:$ROFI_RUN_SCRIPT"
    ROFI_COMBI_LIST="$ROFI_COMBI_MODES"
else
    # no icon modi: the built-in run mode stands in for it, so the command
    # tab still exists (just without the per-row icons)
    ROFI_CUSTOM="run"
    ROFI_COMBI_LIST="${ROFI_COMBI_MODES/"$ROFI_RUN_MODE"/run}"
fi

# Extra omni tabs. Each one is a rofi script mode whose *name* is its tab icon
# (rofi has no display-name setting for script modes), and every icon comes from
# one Nerd Font ink group so the whole tab bar shares one icon size (see the
# `button` rule in rofi/themes/Minimal.rasi).
ROFI_CLIP_MODE="󰅎"; ROFI_KEYS_MODE="󰂚"; ROFI_WORK_MODE="󰕰"
ROFI_WALL_MODE="󰋩"; ROFI_EMOJI_MODE="󰏘"; ROFI_NF_MODE="󰛖"; ROFI_SYSTEM_MODE="󰒔"
ROFI_EXTRA_MODES="\
$ROFI_CLIP_MODE:$HOME/.config/i3/scripts/i3-rofi-clipboard.sh,\
$ROFI_KEYS_MODE:$HOME/.config/i3/scripts/i3-rofi-keymaps.sh,\
$ROFI_WORK_MODE:$HOME/.config/i3/scripts/i3-rofi-workspaces.sh,\
$ROFI_WALL_MODE:$HOME/.config/i3/scripts/i3-rofi-wallpaper.sh,\
$ROFI_EMOJI_MODE:$HOME/.config/i3/scripts/i3-rofi-emoji.sh,\
$ROFI_NF_MODE:$HOME/.config/i3/scripts/i3-rofi-nerdfont.sh,\
$ROFI_SYSTEM_MODE:$HOME/.config/i3/scripts/i3-rofi-system.sh"



if [ -n "${ROFI_TABS:-}" ]; then
    ROFI_MODES="combi${ROFI_CUSTOM:+,$ROFI_CUSTOM},window,drun,filebrowser,$ROFI_EXTRA_MODES"
else
    ROFI_MODES="combi${ROFI_CUSTOM:+,$ROFI_CUSTOM}"
fi

ROFI_ARGS=(
    -show combi
    -modes "$ROFI_MODES"
    -combi-modes "$ROFI_COMBI_LIST"
    -drun-display-format "$ROFI_DRUN_ICON  {name}"
)
[ -n "${ROFI_TABS:-}" ] && ROFI_ARGS+=( -theme-str "$ROFI_MODE_TABS" )

rofi "${ROFI_ARGS[@]}"
