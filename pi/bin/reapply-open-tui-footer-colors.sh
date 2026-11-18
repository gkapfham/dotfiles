#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# reapply-open-tui-footer-colors.sh
#
# Re-applies the local patch that reserves the theme's orange `accent` color
# for the cwd segment and the `/` command menu, instead of also painting the
# footer's context bar, input-token stat, working timer, and TPS telemetry.
#
# Background: the active theme (ghostty-terminal) sets `accent` to the orange
# #d78700. pi-open-tui 0.3.9 has no per-segment color config and renders both
# the cwd and those right-side items from the same `accent` token. This patch
# repoints the right-side / telemetry items to the blue `mdLink` token while
# leaving the cwd segment on `accent` (orange).
#
# A future `pi install` / npm update of pi-open-tui reverts the patch — re-run
# this script afterwards.
#
#   bash ~/.pi/agent/bin/reapply-open-tui-footer-colors.sh
#
# Idempotent, backs up every file it edits, and fails loudly if an expected
# source fragment is missing (e.g. pi-open-tui changed its source) instead of
# corrupting it.
# ---------------------------------------------------------------------------
set -euo pipefail

OPEN_TUI_DIR="$HOME/.pi/agent/npm/node_modules/pi-open-tui/extensions/open-tui"

if [ ! -d "$OPEN_TUI_DIR" ]; then
  echo "ERROR: $OPEN_TUI_DIR not found. Is pi-open-tui still installed?" >&2
  exit 1
fi

python3 - "$OPEN_TUI_DIR" <<'PY'
import os
import shutil
import sys
from datetime import datetime

base = sys.argv[1]

# (relative path, original fragment, patched fragment) — each fragment is
# indentation-free and must occur exactly once. Order is not significant.
EDITS = [
    # Context bar / compact percentage: keep the warning/error escalation but
    # fall back to blue (mdLink) instead of orange (accent).
    (
        "utils.ts",
        'return "accent";\n}',
        'return "mdLink";\n}',
    ),
    # Working timer (right side while the agent runs).
    (
        "footer.ts",
        '${theme.fg("accent", glyphs.working)} ${theme.fg("dim", "working")} '
        '${theme.fg("accent", formatDuration(Date.now() - state.workingSince))}',
        '${theme.fg("mdLink", glyphs.working)} ${theme.fg("dim", "working")} '
        '${theme.fg("mdLink", formatDuration(Date.now() - state.workingSince))}',
    ),
    # Input-token stat in the footer.
    (
        "footer.ts",
        'theme.fg("accent", `${glyphs.input} '
        '${formatInputBreakdown(totals.input, totals.cacheRead)}`)',
        'theme.fg("mdLink", `${glyphs.input} '
        '${formatInputBreakdown(totals.input, totals.cacheRead)}`)',
    ),
    # TPS in the per-turn telemetry line.
    (
        "telemetry.ts",
        'telemetry.tps === null ? "muted" : "accent"',
        'telemetry.tps === null ? "muted" : "mdLink"',
    ),
    # Input tokens in the per-turn telemetry line.
    (
        "telemetry.ts",
        'theme.fg("accent", `${glyphs.input} '
        '${formatInputBreakdown(telemetry.inputTokens, telemetry.cacheReadTokens)}`)',
        'theme.fg("mdLink", `${glyphs.input} '
        '${formatInputBreakdown(telemetry.inputTokens, telemetry.cacheReadTokens)}`)',
    ),
]

pending = []
for rel, orig, patched in EDITS:
    path = os.path.join(base, rel)
    if not os.path.isfile(path):
        print(f"ERROR: {path} not found. Did pi-open-tui change its layout?", file=sys.stderr)
        sys.exit(1)
    with open(path, encoding="utf-8") as f:
        content = f.read()
    if patched in content:
        continue
    if content.count(orig) != 1:
        print(f"ERROR: expected fragment not found exactly once in {path}:", file=sys.stderr)
        print(f"  {orig!r}", file=sys.stderr)
        print("pi-open-tui may have changed — review the footer/accent lines before re-patching.", file=sys.stderr)
        sys.exit(1)
    pending.append((path, rel, orig, patched))

if not pending:
    print("open-tui-footer-colors: already applied — nothing to do.")
    sys.exit(0)

stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
backed_up = set()
for path, rel, orig, patched in pending:
    if path not in backed_up:
        shutil.copy2(path, f"{path}.bak-{stamp}")
        backed_up.add(path)
    with open(path, encoding="utf-8") as f:
        content = f.read()
    with open(path, "w", encoding="utf-8") as f:
        f.write(content.replace(orig, patched, 1))
    print(f"open-tui-footer-colors: patched {rel}")

print("open-tui-footer-colors: done. Restart pi (or /reload) for the footer to update.")
PY
