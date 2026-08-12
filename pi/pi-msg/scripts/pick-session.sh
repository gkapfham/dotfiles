#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Pick which pi session the XMPP bot (pi-msg) should work in.
#
# The bot resumes the session whose path is stored in
# ~/.config/pi-msg/default.session. This script lists your recent sessions,
# lets you choose one, updates that file, and restarts the bridge.
#
# IMPORTANT: do NOT pick a session that is currently open in a terminal.
# One session = one writer at a time.
#
# Usage:  bash scripts/pick-session.sh
# ---------------------------------------------------------------------------
set -euo pipefail

SESSIONS_DIR="$HOME/.pi/agent/sessions"
STATE_FILE="$HOME/.config/pi-msg/default.session"

mapfile -t sessions < <(ls -t "$SESSIONS_DIR"/*/*.jsonl 2>/dev/null | head -12)

if [ "${#sessions[@]}" -eq 0 ]; then
  echo "No sessions found under $SESSIONS_DIR"
  exit 1
fi

echo "Recent pi sessions (newest first):"
echo "-----------------------------------"
for i in "${!sessions[@]}"; do
  f="${sessions[$i]}"
  proj="$(basename "$(dirname "$f")" | sed 's/^--home-gkapfham-//; s/--$//; s/--/-/g')"
  printf '%2d) %s  (%s)\n' "$((i+1))" "$(basename "$f")" "$proj"
done
echo "-----------------------------------"
read -rp "Pick a number (0 = cancel): " n

if [ -z "${sessions[$((n-1))]:-}" ]; then
  echo "Cancelled."
  exit 1
fi

chosen="${sessions[$((n-1))]}"
echo "$chosen" > "$STATE_FILE"
chmod 600 "$STATE_FILE"

echo "Restarting the bridge so the bot resumes this session..."
systemctl --user restart pi-msg
sleep 4
if systemctl --user is-active pi-msg >/dev/null; then
  echo "Done. The bot is online and now continues:"
  echo "  $chosen"
else
  echo "WARNING: the bridge did not stay active. Check: journalctl --user -u pi-msg"
fi
