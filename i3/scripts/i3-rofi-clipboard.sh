#!/usr/bin/env bash

# i3-rofi-clipboard.sh — clipboard history as a rofi mode.
#
# clipmenu already speaks the rofi script protocol (no arguments = print the
# list; the chosen entry as an argument = put it back on both clipboards), so
# this only adds the omni's "which tab was used last" note before handing over.
#
# Used as the clipboard tab of the omni launcher (i3-run-rofi-full-path.sh).

set -euo pipefail

export CM_LAUNCHER=rofi-script

case "${ROFI_RETV:-0}" in
  0) exec clipmenu ;;
  1)
    exec clipmenu "$1"
    ;;
  *) exec clipmenu "$@" ;;
esac
