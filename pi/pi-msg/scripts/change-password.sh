#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# change-password.sh — Update the pi-msg XMPP passwords in one consistent step.
#
# Updates BOTH sides so the bot keeps working after the change:
#   1. ejabberd server:  change_password for the bot and owner accounts
#   2. bridge config:    ~/.config/pi-msg/config.json (bot password)
#   3. saved copy:       ~/.config/pi-msg/passwords.txt
#   4. restarts the pi-msg service so it reconnects with the new password
#
# Assumes the XMPP server runs on this machine (ENABLE_SERVER=yes).
# Simple alphanumeric passwords are recommended (you type them on a phone).
#
# Usage:
#   bash scripts/change-password.sh                 # prompts for both
#   bash scripts/change-password.sh BOT_PASS OWNER_PASS
# ---------------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

# Pull DOMAIN / PI_USER / OWNER_USER from config.env when present.
if [ -f config.env ]; then
  # shellcheck disable=SC1090
  source config.env
fi
: "${DOMAIN:?config.env must set DOMAIN}"
PI_USER="${PI_USER:-pi}"
OWNER_USER="${OWNER_USER:-gkapfham}"
CONFIG_DIR="$HOME/.config/pi-msg"

PI_PASSWORD="${1:-}"
OWNER_PASSWORD="${2:-}"

if [ -z "$PI_PASSWORD" ]; then
  read -rsp "New password for $PI_USER@$DOMAIN (bot): " PI_PASSWORD; echo
fi
if [ -z "$OWNER_PASSWORD" ]; then
  read -rsp "New password for $OWNER_USER@$DOMAIN (you): " OWNER_PASSWORD; echo
fi

echo "==> Updating ejabberd accounts"
sudo -u ejabberd ejabberdctl change_password "$PI_USER" "$DOMAIN" "$PI_PASSWORD"
sudo -u ejabberd ejabberdctl change_password "$OWNER_USER" "$DOMAIN" "$OWNER_PASSWORD"

echo "==> Updating bridge config ($CONFIG_DIR/config.json)"
tmp="$CONFIG_DIR/config.json.tmp"
jq ".accounts.default.password = \"$PI_PASSWORD\"" "$CONFIG_DIR/config.json" > "$tmp"
mv "$tmp" "$CONFIG_DIR/config.json"
chmod 600 "$CONFIG_DIR/config.json"

if [ -f "$CONFIG_DIR/passwords.txt" ]; then
  printf 'PI_PASSWORD=%s\nOWNER_PASSWORD=%s\n' "$PI_PASSWORD" "$OWNER_PASSWORD" \
    > "$CONFIG_DIR/passwords.txt"
  chmod 600 "$CONFIG_DIR/passwords.txt"
fi

echo "==> Restarting the pi-msg service"
systemctl --user restart pi-msg
sleep 4
if systemctl --user is-active pi-msg >/dev/null; then
  echo "Done. On the phone, re-enter the owner password:"
  echo "  $OWNER_USER@$DOMAIN / $OWNER_PASSWORD"
else
  echo "WARNING: pi-msg did not stay active — check: journalctl --user -u pi-msg" >&2
  exit 1
fi
