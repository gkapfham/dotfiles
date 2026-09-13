#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Apply the repo's pi config to this machine's live install (~/.pi/agent).
#
# The inverse of sync-config.sh. Use it when the repo should OVERRIDE the
# laptop: after cloning on a new machine, or restoring from a commit.
#
#   bash pi/apply-config.sh              # copies repo -> ~/.pi/agent
#   bash pi/apply-config.sh --yes        # skip the confirmation prompt
#   bash pi/apply-config.sh --list       # list backups + revert command
#
# Safety: BEFORE overwriting anything, the current ~/.pi is backed up to
# ~/.pi-backups/agent-<timestamp>/ (regenerable agent/npm and agent/git are
# excluded). The newest PI_BACKUP_KEEP backups are kept (default 5). The
# backup location and a revert command are printed after every run.
#
# Copies: settings.json, AGENTS.md, extensions/, skills/, bin/, prompts/, themes/
# Never touches: npm/, sessions/, tau-instances/, analytics/, auth.json, caches
# ---------------------------------------------------------------------------
set -euo pipefail

PI_DIR="$(cd "$(dirname "$0")" && pwd)"
PI_HOME="$HOME/.pi"
AGENT_DIR="$PI_HOME/agent"
BACKUP_ROOT="${PI_BACKUP_DIR:-$HOME/.pi-backups}"
KEEP="${PI_BACKUP_KEEP:-5}"

list_backups() {
  echo "Pi backups in $BACKUP_ROOT:"
  local found=0
  local b
  for b in $(ls -1dt "$BACKUP_ROOT"/agent-* 2>/dev/null | head -10 || true); do
    found=1
    echo "  $b"
  done
  [ "$found" = 1 ] || echo "  (none yet)"
  local newest
  newest="$(ls -1dt "$BACKUP_ROOT"/agent-* 2>/dev/null | head -1 || true)"
  echo
  echo "To revert ~/.pi to the state of the newest backup:"
  if [ -n "$newest" ]; then
    echo "  rsync -a '$newest/' '$PI_HOME/'"
  else
    echo "  (no backup to revert to)"
  fi
}

if [ "${1:-}" = "--list" ]; then
  list_backups
  exit 0
fi

[ -d "$AGENT_DIR" ] || mkdir -p "$AGENT_DIR"

if [ "${1:-}" != "--yes" ]; then
  echo "This OVERWRITES live files under $AGENT_DIR with the repo versions."
  echo "A backup of $PI_HOME is taken first and can be reverted."
  read -rp "Continue? (y/N) " ok
  [ "$ok" = "y" ] || [ "$ok" = "Y" ] || { echo "Aborted."; exit 1; }
fi

# 1. Back up the current state (regenerable agent/npm and agent/git excluded).
BACKUP_DIR="$BACKUP_ROOT/agent-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_ROOT"
echo "==> Backing up $PI_HOME to:"
echo "    $BACKUP_DIR"
rsync -a --exclude='agent/npm' --exclude='agent/git' "$PI_HOME/" "$BACKUP_DIR/"

# Prune old backups (keep the newest KEEP).
for old in $(ls -1dt "$BACKUP_ROOT"/agent-* 2>/dev/null | tail -n +$((KEEP + 1)) || true); do
  rm -rf "$old"
  echo "    pruned old backup: $old"
done

# 2. Apply the repo config.
echo "==> Applying pi config from $PI_DIR to $AGENT_DIR"
install -m 600 "$PI_DIR/settings.json" "$AGENT_DIR/settings.json"
[ -f "$PI_DIR/AGENTS.md" ] && install -m 600 "$PI_DIR/AGENTS.md" "$AGENT_DIR/AGENTS.md"
for d in extensions skills bin prompts themes; do
  [ -e "$PI_DIR/$d" ] || continue
  mkdir -p "$AGENT_DIR/$d"
  rsync -a --exclude='node_modules' "$PI_DIR/$d/" "$AGENT_DIR/$d/"
done

# 3. Summary.
echo
echo "Done. pi picks these up on its next session start."
echo "Backup placed at:"
echo "  $BACKUP_DIR"
echo
list_backups
