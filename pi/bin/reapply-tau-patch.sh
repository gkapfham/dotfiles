#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# reapply-tau-patch.sh
#
# Re-applies the local patch that hides the Tailscale IP from the
# tau-mirror status bar (` • TS: <ip>:<port>` fragment).
#
# Upstream tau-mirror has no config toggle for this (checked v1.0.9), so we
# patch the installed source directly. A future `pi install` / npm update of
# tau-mirror reverts the patch — re-run this script afterwards.
#
#   bash ~/.pi/agent/bin/reapply-tau-patch.sh
#
# Safe, idempotent, and fails loudly if the expected line is missing
# (e.g. tau-mirror changed its source) instead of corrupting the file.
# ---------------------------------------------------------------------------
set -euo pipefail

TARGET="$HOME/.pi/agent/npm/node_modules/tau-mirror/extensions/mirror-server.ts"

ORIGINAL='      ctx.ui.setStatus("mirror", `Mirror: ${localIp}:${port}${tailscaleIp ? ` • TS: ${tailscaleIp}:${port}` : ""}`);'
PATCHED='      ctx.ui.setStatus("mirror", `Mirror: ${localIp}:${port}`);'

if [ ! -f "$TARGET" ]; then
  echo "ERROR: $TARGET not found. Is tau-mirror still installed?" >&2
  exit 1
fi

if grep -Fq "$PATCHED" "$TARGET"; then
  echo "tau-patch: already applied — nothing to do."
  exit 0
fi

if ! grep -Fq "$ORIGINAL" "$TARGET"; then
  echo "ERROR: expected line not found in $TARGET." >&2
  echo "tau-mirror may have changed its source — review the current" >&2
  echo "setStatus(\"mirror\", ...) line before re-patching." >&2
  exit 1
fi

cp "$TARGET" "$TARGET.bak-$(date +%Y%m%d-%H%M%S)"

# Use python3 for the replacement so backticks and ${} in the strings are
# never interpreted by the shell.
python3 - "$TARGET" "$ORIGINAL" "$PATCHED" <<'PY'
import sys

path, orig, patched = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path, encoding="utf-8") as f:
    content = f.read()

if patched in content:
    print("tau-patch: already applied — nothing to do.")
    sys.exit(0)
if orig not in content:
    print(f"ERROR: expected line not found in {path}", file=sys.stderr)
    sys.exit(1)

content = content.replace(orig, patched, 1)
with open(path, "w", encoding="utf-8") as f:
    f.write(content)
print(f"tau-patch: patched {path}")
PY

echo "tau-patch: done. Restart pi (or /reload) for the status bar to update."