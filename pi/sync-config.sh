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
#
# The five user-authored directories are synced as a strict mirror
# (rsync --delete): a file removed from the live install is removed here too,
# so deleted config cannot silently resurrect on a restore. Destructive
# actions only ever touch this repo's working tree (never ~/.pi/agent), and
# each one is reported.
# ---------------------------------------------------------------------------
set -euo pipefail

# Resolve this script's own directory, even when invoked through a symlink.
SELF="${BASH_SOURCE[0]:-$0}"
if readlink -f / >/dev/null 2>&1; then          # GNU readlink (Linux); skipped on BSD/macOS
  SELF="$(readlink -f "$SELF")"
fi
PI_DIR="$(cd "$(dirname "$SELF")" && pwd)"
AGENT_DIR="$HOME/.pi/agent"

[ -d "$AGENT_DIR" ] || { echo "ERROR: $AGENT_DIR not found" >&2; exit 1; }

# Fail fast, before copying anything, if the live install looks incomplete.
# settings.json is the package manifest and must always be present; aborting
# here avoids leaving the repo half-synced.
[ -f "$AGENT_DIR/settings.json" ] || {
  echo "ERROR: $AGENT_DIR/settings.json not found - is pi installed for this user?" >&2
  exit 1
}

echo "==> Syncing pi config from $AGENT_DIR into $PI_DIR"

# Top-level user-authored files. AGENTS.md is optional: pi does not create it,
# so a machine without global agent rules simply has none.
cp -f "$AGENT_DIR/settings.json" "$PI_DIR/settings.json"
chmod 600 "$PI_DIR/settings.json"
synced_files="settings.json"
if [ -f "$AGENT_DIR/AGENTS.md" ]; then
  cp -f "$AGENT_DIR/AGENTS.md" "$PI_DIR/AGENTS.md"
  chmod 600 "$PI_DIR/AGENTS.md"
  synced_files="$synced_files, AGENTS.md"
fi
echo "  $synced_files"

# User-authored directories are mirrored. node_modules is excluded from both
# the copy AND the delete, so installed packages are never touched here.
for d in extensions skills bin prompts themes; do
  if [ -e "$AGENT_DIR/$d" ]; then
    mkdir -p "$PI_DIR/$d"
    rsync -a --delete --exclude='node_modules' "$AGENT_DIR/$d/" "$PI_DIR/$d/"
    echo "  $d/"
  elif [ -e "$PI_DIR/$d" ]; then
    # Live has no such directory: mirror that, so stale content in the repo
    # copy cannot resurrect on a restore. This deletes only inside the repo.
    rm -rf "${PI_DIR:?}/$d"
    echo "  $d/ (absent in live - removed from repo copy)"
  fi
done

# Prune what must never be committed. Scoped to the synced directories only:
# a blanket `find "$PI_DIR"` would also delete unrelated tracked files >1MB
# (e.g. under pi-msg/).
for d in extensions skills bin prompts themes; do
  [ -e "$PI_DIR/$d" ] || continue
  find "$PI_DIR/$d" -type l -delete 2>/dev/null || true            # package symlinks
  find "$PI_DIR/$d" -type f -size +1M -delete 2>/dev/null || true  # oversized artifacts
done

# Show what changed under pi/ so the human can review before committing.
if git -C "$PI_DIR/.." rev-parse --git-dir >/dev/null 2>&1; then
  echo
  echo "── changes under pi/ ──"
  git -C "$PI_DIR/.." status --short -- "$PI_DIR" || true
fi

echo
echo "Done. Review and commit:"
echo "  cd $PI_DIR/.. && git add pi/ && git commit -m 'Update pi config'"
