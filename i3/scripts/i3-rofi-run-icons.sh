#!/usr/bin/env bash

# Fast custom rofi modi for run mode with nerd-font icons.
# Optimized for minimal startup latency.
# NixOS-compatible: detects new programs via PATH changes.

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
RUN_ICON="${ROFI_RUN_ICON:-}"
RUN_PREFIX="${RUN_ICON}  "
LEGACY_RUN_ICONS='^(||󰘳|󰍉|󰊠|󰎔)[[:space:]]+'
PATH_HASH=$(printf '%s' "$PATH" | cksum | awk '{print $1}')

# Find the most recent runcache file
RUNCACHE=""
for candidate in "$CACHE_DIR"/rofi-*.runcache; do
    [[ -e "$candidate" ]] || continue
    if [[ -z "$RUNCACHE" || "$candidate" -nt "$RUNCACHE" ]]; then
        RUNCACHE="$candidate"
    fi
done

COMPILED="$CACHE_DIR/rofi-run-icons-compiled.$PATH_HASH"
COMPILED_HEADER="# rofi-run-icons cache v5 PATH:$PATH_HASH"

strip_legacy_prefix() {
    printf '%s\n' "$1" | sed -E "s/$LEGACY_RUN_ICONS//"
}

# Check if compiled cache is valid
# On NixOS: PATH changes when new store paths are added, so PATH_HASH changes
# Traditional: Directory modification times are also checked
compiled_cache_is_current() {
    [[ -f "$COMPILED" ]] || return 1
    [[ -n "$RUNCACHE" && "$COMPILED" -nt "$RUNCACHE" ]] || return 1
    
    # Read header and verify PATH_HASH matches (catches NixOS store path changes)
    IFS= read -r first_line < "$COMPILED" || return 1
    [[ "$first_line" == "$COMPILED_HEADER" ]] || return 1
    
    # On non-NixOS: also check if PATH directories were modified
    # Skip this on NixOS since store paths never change (new ones are added instead)
    # Detect NixOS by checking for nix command or nix-specific paths
    if [[ -z "$IS_NIXOS" ]]; then
        if command -v nix >/dev/null 2>&1 || [[ "$PATH" == *"/nix"* ]] || [[ -d /nix ]]; then
            IS_NIXOS=1
        else
            IS_NIXOS=0
        fi
    fi
    
    if [[ "$IS_NIXOS" == "0" ]]; then
        local dir
        local IFS=':'
        for dir in $PATH; do
            [[ -d "$dir" ]] || continue
            if [[ "$dir" -nt "$COMPILED" ]]; then
                return 1
            fi
        done
    fi
    
    return 0
}

# Handle selection
if [[ ${ROFI_RETV:-0} -eq 1 && "$1" == "$RUN_PREFIX"* ]]; then
    cmd="${1#"$RUN_PREFIX"}"
elif [[ ${ROFI_RETV:-0} -eq 2 && -n "$1" ]]; then
    cmd="$1"
fi

if [[ -n "${cmd:-}" ]]; then
    cmd=$(strip_legacy_prefix "$cmd")
    
    if [[ -n "$RUNCACHE" && -f "$RUNCACHE" ]]; then
        # Update runcache efficiently
        if grep -qF " $cmd" "$RUNCACHE" 2>/dev/null; then
            # Command exists, increment its score
            tmpfile="${RUNCACHE}.tmp.$$"
            awk -F'\x1f' -v c="$cmd" '
            match($1, /^([0-9]+) (.+)$/, m) {
                score = m[1] + 0
                name = m[2]
                gsub(/^(||󰘳|󰍉|󰊠|󰎔)[[:space:]]+/, "", name)
                if (name == c) score++
                print score " " name "\x1f\x27" name "\x27"
            }
            ' "$RUNCACHE" > "$tmpfile" && mv "$tmpfile" "$RUNCACHE"
        else
            # New command, append to runcache
            printf '1 %s\x1f\x27%s\x27\n' "$cmd" "$cmd" >> "$RUNCACHE"
        fi
    fi
    
    # Launch via i3-msg
    printf -v launch_cmd 'exec --no-startup-id env PATH=%q sh -lc %q' "$PATH" "$cmd"
    i3-msg -q "$launch_cmd" >/dev/null
    exit 0
fi

# Fast path: use cached list
if compiled_cache_is_current; then
    # Use a single awk to add prefixes
    awk -v prefix="$RUN_PREFIX" 'NR>1 {print prefix $0}' "$COMPILED"
else
    # Rebuild cache
    tmpfile="${COMPILED}.tmp.$$"
    
    {
        printf '%s\n' "$COMPILED_HEADER"
        
        # Get commands from runcache (if exists) - priority commands first
        if [[ -n "$RUNCACHE" && -f "$RUNCACHE" ]]; then
            awk -F'\x1f' 'match($1, /^([0-9]+) (.+)$/, m) && m[1] > 0 {
                name = m[2]
                gsub(/^(||󰘳|󰍉|󰊠|󰎔)[[:space:]]+/, "", name)
                if (!seen[name]++) print name
            }' "$RUNCACHE"
        fi
        
        # Get all executables from PATH
        compgen -c | sort -u
        
    } > "$tmpfile" && mv "$tmpfile" "$COMPILED"
    
    # Output with prefixes
    awk -v prefix="$RUN_PREFIX" 'NR>1 {print prefix $0}' "$COMPILED"
fi
