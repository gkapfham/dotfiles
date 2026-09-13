#!/usr/bin/env bash

# Nerd Font Icon Picker for Rofi
# Fetches Nerd Font glyphnames and presents them for selection
# Inserts the selected icon into the focused window

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq."
    exit 1
fi

# Check if xdotool is available
if ! command -v xdotool &> /dev/null; then
    echo "xdotool is required but not installed. Please install xdotool."
    exit 1
fi

# Cache the glyphnames JSON locally
CACHE_DIR="${HOME}/.cache/nerd-font-icons"
CACHE_FILE="${CACHE_DIR}/glyphnames.json"

mkdir -p "$CACHE_DIR"

if [ ! -f "$CACHE_FILE" ]; then
    echo "Downloading Nerd Font glyphnames..."
    curl -s https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json -o "$CACHE_FILE"
fi

# Process the cached JSON
jq -r '. | to_entries[] | select(.key != "METADATA") | "\(.value.char) \(.key)"' "$CACHE_FILE" | \
rofi -dmenu -i -p 'Nerd Font Icon' | \
awk '{printf "%s", $1}' | \
xdotool type --clearmodifiers --file -
