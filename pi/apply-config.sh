#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Apply the repo's pi config to this machine's live install (~/.pi/agent).
#
# The inverse of sync-config.sh. Use it when the repo should OVERRIDE the
# laptop: after cloning on a new machine, or restoring from a commit.
#
#   bash pi/apply-config.sh        # copies repo -> ~/.pi/agent
#
# Copies: settings.json, AGENTS.md, extensions/, skills/, bin/, prompts/, themes/
# Never touches: npm/, sessions/, tau-instances/, analytics/, auth.json, caches
#
# NOTE: overwrites the live copies of those files/dirs with the repo versions.
# ---------------------------------------------------------------------------
set -euo pipefail

PI_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_DIR="$HOME/.pi/agent"

[ -d "$AGENT_DIR" ] || mkdir -p "$AGENT_DIR"

if [ "${1:-}" != "--yes" ]; then
  echo "This OVERWRITES live files under ~/.pi/agent with the repo versions."
  read -rp "Continue? (y/N) " ok
  [ "$ok" = "y" ] || [ "$ok" = "Y" ] || { echo "Aborted."; exit 1; }
fi

echo "==> Applying pi config from $PI_DIR to $AGENT_DIR"

install -m 600 "$PI_DIR/settings.json" "$AGENT_DIR/settings.json"
[ -f "$PI_DIR/AGENTS.md" ] && install -m 600 "$PI_DIR/AGENTS.md" "$AGENT_DIR/AGENTS.md"

for d in extensions skills bin prompts themes; do
  [ -e "$PI_DIR/$d" ] || continue
  mkdir -p "$AGENT_DIR/$d"
  rsync -a --exclude='node_modules' "$PI_DIR/$d/" "$AGENT_DIR/$d/"
done

echo "Done. pi picks these up on its next session start."
