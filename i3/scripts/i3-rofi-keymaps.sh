#!/usr/bin/env bash

# i3-rofi-keymaps.sh — the i3 keybindings as a rofi mode (the "reminders" menu).
#
# The list is the same transformation i3-keymaps.sh has always used. Selecting a
# line *runs* that keybinding: i3's bindings are passive X grabs and XTEST events
# trigger them, so the keys are pressed by xdotool ~0.4 s later from a detached
# process — rofi still owns the keyboard while this script runs, so the press has
# to wait until the menu has closed.
#
# Used as the keymaps tab of the omni launcher and, through i3-keymaps.sh, by the
# standalone Control+Alt+R menu.
#
# I3_CONFIG (optional): a different i3 config file.

set -euo pipefail

I3_CONFIG=${I3_CONFIG:-$HOME/.config/i3/config}
mod_key=$(sed -nre 's/^set \$mod (.*)/\1/p' "$I3_CONFIG")

case "${ROFI_RETV:-0}" in
  0)
    printf '\0prompt\x1f󰂚\n'
    # no \0message hint here: the other omni tabs show none, and the extra row
    # made this tab the odd one out.
    # same transformation the standalone i3-keymaps.sh has always used
    grep "^bindsym" "$I3_CONFIG" \
      | sed "s/-\(-\w\+\)\+/ /g;s/\$mod/${mod_key}/g;s/Mod1/Alt/g;s/exec //;s/bindsym //;s/^\s\+//;s/^\([^ ]\+\) \(.\+\)$/\2: \1/;s/^\s\+//" \
      | tr -s ' '
    ;;
  1)
    # the binding is the text after the last ": "
    keys=${1##*: }
    [ -n "$keys" ] || exit 0
    case "$keys" in
      *button[0-9]*)   # mouse bindings (e.g. Mod4+button4) need a click, with
                       # whatever modifiers the binding requires held down
        btn=${keys##*button}; btn=${btn%%[^0-9]*}
        mods=${keys%button*}; mods=${mods%+}
        down=""; up=""
        case "$mods" in *Mod4*|*Super*) down="$down keydown super"; up="keyup super $up" ;; esac
        case "$mods" in *Mod1*|*Alt*)   down="$down keydown alt";   up="keyup alt $up" ;; esac
        case "$mods" in *Control*)      down="$down keydown ctrl";  up="keyup ctrl $up" ;; esac
        case "$mods" in *Shift*)        down="$down keydown shift"; up="keyup shift $up" ;; esac
        setsid sh -c "sleep 0.4; xdotool$down click $btn$up" >/dev/null 2>&1 & ;;
      *)
        setsid sh -c "sleep 0.4; xdotool key --clearmodifiers -- '$keys'" >/dev/null 2>&1 & ;;
    esac
    ;;
  *) ;;
esac
