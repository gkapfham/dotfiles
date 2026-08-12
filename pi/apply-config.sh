#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Apply the repo's pi config to THIS machine's live install (~/.pi/agent).
#
# The inverse of sync-config.sh. Use it when you want the repo to OVERRIDE
# the laptop: after cloning on a new machine, or restoring from a commit.
#
#   bash pi/apply-config.sh        # copies repo -> ~/.pi/agent
#
# What it copies:
#   pi/settings.json     -> ~/.pi/agent/settings.json   (the plugin manifest)
#   pi/extensions/*.ts   -> ~/.pi/agent/extensions/
#   pi/skills/*          -> ~/.pi/agent/skills/
#
# It NEVER touches plugin/ephemeral content (~/.pi/agent/npm/, sessions/,
# auth.json, caches). Any plugin packages listed in settings.json that are
# not yet installed are auto-installed by pi on its next startup.
#
# NOTE: this OVERWRITES the live settings.json / extensions / skills with
# the repo versions. If the live files are newer than the repo (you changed
# something without syncing), this reverts them.
# ---------------------------------------------------------------------------
set -euo pipefail

PI_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_DIR="$HOME/.pi/agent"

[ -d "$AGENT_DIR" ] || mkdir -p "$AGENT_DIR"

if [ "${1:-}" != "--yes" ]; then
  echo "This OVERWRITES ~/.pi/agent/{settings.json,extensions,skills} with the repo versions."
  read -rp "Continue? (y/N) " ok
  [ "$ok" = "y" ] || [ "$ok" = "Y" ] || { echo "Aborted."; exit 1; }
fi

echo "==> Applying pi config from $PI_DIR to $AGENT_DIR"

install -m 600 "$PI_DIR/settings.json" "$AGENT_DIR/settings.json"
echo "  settings.json"

mkdir -p "$AGENT_DIR/extensions"
cp "$PI_DIR"/extensions/*.ts "$AGENT_DIR/extensions/" 2>/dev/null || true
cp "$PI_DIR"/extensions/*.disabled "$AGENT_DIR/extensions/" 2>/dev/null || true
echo "  extensions/"

mkdir -p "$AGENT_DIR/skills"
for s in "$PI_DIR"/skills/*/; do
  name="$(basename "$s")"
  rm -rf "$AGENT_DIR/skills/$name"
  cp -r "$s" "$AGENT_DIR/skills/$name"
done
echo "  skills/"

echo
echo "Done. pi picks these up on its next session start (extensions load at startup)."
echo "If google-workspace is new here: cd ~/.pi/agent/skills/google-workspace && npm install"
