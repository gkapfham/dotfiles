#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Sync YOUR pi configuration from the live install into this repo, ready to
# commit.
#
#   bash pi/sync-config.sh      # then: git add pi && git commit
#
# What it copies (your owned config):
#   ~/.pi/agent/settings.json     -> pi/settings.json   (the plugin manifest)
#   ~/.pi/agent/extensions/*.ts   -> pi/extensions/     (hand-written extensions)
#   ~/.pi/agent/skills/*          -> pi/skills/         (your skills, no node_modules)
#
# What it deliberately does NOT touch (plugin/ephemeral content):
#   ~/.pi/agent/npm/          installed plugin packages (auto-installed from
#                             the settings.json manifest by pi itself)
#   ~/.pi/agent/sessions/     session transcripts
#   ~/.pi/agent/tau-instances/ tau mirror state
#   ~/.pi/agent/auth.json     credentials (never commit)
#   ~/.config/pi/...          live state (web-search-cache, etc.)
# ---------------------------------------------------------------------------
set -euo pipefail

PI_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_DIR="$HOME/.pi/agent"

[ -d "$AGENT_DIR" ] || { echo "ERROR: $AGENT_DIR not found"; exit 1; }

echo "==> Syncing pi config from $AGENT_DIR into $PI_DIR"

# 1. settings.json — the manifest (contains the packages pi auto-installs).
#    It holds no secrets; pi rewrites it on install/config changes, so we
#    copy it in deliberately rather than symlinking it.
cp "$AGENT_DIR/settings.json" "$PI_DIR/settings.json"
chmod 600 "$PI_DIR/settings.json"
echo "  settings.json"

# 2. Hand-written extensions (.ts and .disabled variants) + pi-tracker.
rm -rf "$PI_DIR/extensions"
mkdir -p "$PI_DIR/extensions"
cp "$AGENT_DIR"/extensions/*.ts "$PI_DIR/extensions/" 2>/dev/null || true
cp "$AGENT_DIR"/extensions/*.disabled "$PI_DIR/extensions/" 2>/dev/null || true
[ -d "$AGENT_DIR/extensions/pi-tracker" ] && cp -r "$AGENT_DIR/extensions/pi-tracker" "$PI_DIR/extensions/"
echo "  extensions/"

# 3. Skills — copy everything except node_modules (never bloat the repo).
rm -rf "$PI_DIR/skills"
mkdir -p "$PI_DIR/skills"
for s in "$AGENT_DIR"/skills/*/; do
  name="$(basename "$s")"
  cp -r "$s" "$PI_DIR/skills/"
  rm -rf "$PI_DIR/skills/$name/node_modules"
  echo "  skills/$name"
done

echo
echo "Done. Review and commit:"
echo "  cd $PI_DIR/.. && git add pi/ && git commit -m 'Update pi config'"
