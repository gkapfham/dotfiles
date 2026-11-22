#!/usr/bin/env bash

# i3-rofi-system.sh — system menu as a rofi mode: the system tab of the omni
# launcher and, through i3-system.sh, the standalone Control+Alt+plus menu. It
# holds the power actions and a screenshot submenu.
#
# Suspend and Hibernate do NOT lock the screen: they start no locker and wait
# for nothing. Only "Lock System" locks.
#
# Level 0 is the system options; "Screenshot" switches the same menu to a second
# level with the three capture choices (and "System options" switches back), so
# no nested rofi is ever needed. ROFI_DATA carries the level between calls;
# ROFI_SCREENSHOT=1 opens the menu straight on the screenshot level (that is how
# the four-finger swipe gesture reaches it).

set -euo pipefail

CAPTURE="$HOME/.config/i3/scripts/i3-screenshot-capture.sh"
LOCKER="$HOME/.config/i3/scripts/i3-lock-screen-betterlock.sh"
level=${ROFI_DATA:-system}
[ "${ROFI_SCREENSHOT:-}" = 1 ] && [ "${ROFI_RETV:-0}" = 0 ] && level=screenshot

screenshot_level() {
  printf '\0prompt\x1f󰆟\n'
  printf '\0message\x1fEnter: capture to the clipboard\n'
  printf '%s\n' \
    "󰘖  Full screen" \
    "󰖯  Active window" \
    "󰆟  Region (drag)" \
    "󰭜  System options"
}

system_level() {
  printf '\0prompt\x1f󰒔\n'
  printf '%s\n' \
    "󰍃  Log Out" \
    "󰌾  Lock System" \
    "󰜉  Restart System" \
    "󰤂  Shutdown System" \
    "󰒲  Suspend System" \
    "󰋊  Hibernate System" \
    "󰆟  Screenshot"
}

# Run a sleep action detached, after a short delay. Two reasons: a rofi
# script-mode action runs *while rofi is still open*, and the suspend/hibernate
# would otherwise snapshot or freeze the menu mid-draw — it would then still be
# on screen after resuming. 0.3 s is enough for rofi to close first.
power_action() {
  setsid sh -c "sleep 0.3; systemctl $1" >/dev/null 2>&1 &
}

if [ "${ROFI_RETV:-0}" = 0 ]; then
  [ "$level" = screenshot ] && screenshot_level || system_level
  exit 0
fi

[ -n "${1:-}" ] || exit 0
label=$(printf '%s' "$1" | awk '{$1=""; sub(/^ +/, ""); print}')

if [ "$level" = screenshot ]; then
  case "$label" in
    "Full screen")       "$CAPTURE" full ;;
    "Active window")     "$CAPTURE" active ;;
    "Region (drag)")     "$CAPTURE" region ;;
    "System options")     printf '\0data\x1fsystem\n'; system_level ;;
    *)                   ;;
  esac
  exit 0
fi

case "$label" in
  "Screenshot")        printf '\0data\x1fscreenshot\n'; screenshot_level ;;
  "Log Out")           i3-msg exit >/dev/null ;;
  # Handed off detached: a rofi script-mode action runs *while rofi is still
  # open*, and rofi holds the keyboard grab i3lock needs. The locker waits
  # for that grab to be freed, so the menu closes at once instead of
  # blocking until the screen is unlocked again.
  "Lock System")       setsid nohup "$LOCKER" >/dev/null 2>&1 & ;;
  "Restart System")    systemctl reboot ;;
  "Shutdown System")   systemctl poweroff ;;
  # Suspend/hibernate without any lock: no $LOCKER, no waiting for i3lock to
  # appear. See power_action() for why they are handed off detached.
  "Suspend System")    power_action suspend ;;
  "Hibernate System")  power_action hibernate ;;
  *)                   ;;
esac
