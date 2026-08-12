#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Sync the pi configuration from the live install (~/.pi/agent) into this
# repo, ready to commit.
#
#   bash pi/sync-config.sh      # then: git add pi/ && git commit
#
# Copies everything user-authored under ~/.pi/agent:
#   settings.json, AGENTS.md, extensions/, skills/, bin/, prompts/, themes/
#
# Deliberately excluded (generated or secret, never committed):
#   npm/ (installed packages - auto-installed from the settings.json manifest)
#   sessions/, tau-instances/, analytics/, git/, session-status/
#   auth.json, gateway.*, models*.json, zentui.json, *.log, *.sqlite*
#   node_modules, files larger than 1MB, symlinks (package links like pi-tracker)
# ---------------------------------------------------------------------------
set -euo pipefail

PI_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_DIR="$HOME/.pi/agent"

[ -d "$AGENT_DIR" ] || { echo "ERROR: $AGENT_DIR not found"; exit 1; }

echo "==> Syncing pi config from $AGENT_DIR into $PI_DIR"

# Top-level user-authored files.
cp -f "$AGENT_DIR/settings.json" "$PI_DIR/settings.json"
cp -f "$AGENT_DIR/AGENTS.md" "$PI_DIR/AGENTS.md"
chmod 600 "$PI_DIR/settings.json" "$PI_DIR/AGENTS.md"
echo "  settings.json, AGENTS.md"

# User-authored directories (symlinks preserved during copy, pruned after).
for d in extensions skills bin prompts themes; do
  [ -e "$AGENT_DIR/$d" ] || continue
  mkdir -p "$PI_DIR/$d"
  rsync -a --exclude='node_modules' "$AGENT_DIR/$d/" "$PI_DIR/$d/"
  echo "  $d/"
done

# Prune anything that must not be committed.
find "$PI_DIR/extensions" "$PI_DIR/skills" "$PI_DIR/bin" "$PI_DIR/prompts" "$PI_DIR/themes" \
  -type l -delete 2>/dev/null || true                     # package symlinks (e.g. pi-tracker)
find "$PI_DIR" -type f -size +1M -delete 2>/dev/null || true   # binaries / artifacts

echo
echo "Done. Review and commit:"
echo "  cd $PI_DIR/.. && git add pi/ && git commit -m 'Update pi config'"
