#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Keep every tool config aligned with theme/palette.toml.

The palette is the source of truth; this script does not regenerate whole
files (that would fight the human formatting in each config). Instead it
replaces known palette hex values in place — including the retired values in
``[aliases]`` — while preserving each file's own prefix style (``#rrggbb`` or
``0xrrggbb``) and whitespace.

Modes (mutually exclusive):

    --report   audit every distinct hex per target file (default)
    --check    exit non-zero if any [aliases] value still appears
    --write    migrate [aliases]; add --review to also apply [review]

``--check`` is meant to be a hard gate in ``make check``.
"""

from __future__ import annotations

import argparse
import re
import sys
import tomllib
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent

# Files whose colors are owned by the palette. Paths are repo-relative.
TARGETS = (
    "kitty/kitty.conf",
    "ghostty/config",
    "termite/config",
    "alacritty/alacritty.toml",
    "alacritty/alacritty.yml",
    "wezterm/wezterm.lua",
    "zellij/config.kdl",
    "starship/starship.toml",
    "dunst/dunstrc",
    "polybar/config.ini",
    "quickshell/Colors.qml",
    "rofi/themes/Minimal.rasi",
    "nvim/lua/plugins/colorscheme.lua",
    "opencode/themes/vitaminonec.json",
    "pi/themes/ghostty-terminal.json",
    "treemd/config.toml",
    "treemd/code-themes/vitaminonec.tmTheme",
    "shell/.zshrc",
)

JSON_TARGETS = {
    "opencode/themes/vitaminonec.json",
    "pi/themes/ghostty-terminal.json",
}

HEX_RE = re.compile(r"(?P<prefix>#|0x)(?P<hex>[0-9a-fA-F]{6})(?![0-9a-fA-F])")


def norm(value: str) -> str:
    """Normalise any '#RRGGBB' / '0xRRGGBB' / 'RRGGBB' to lowercase '#rrggbb'."""
    return "#" + value.strip().lstrip("#").removeprefix("0x").lower()


def load_data() -> dict:
    with (HERE / "palette.toml").open("rb") as handle:
        return tomllib.load(handle)


def load_palette(data: dict) -> tuple[set[str], dict[str, str], dict[str, str]]:
    known = {
        norm(v) for section in ("app", "ansi") for v in data.get(section, {}).values()
    }
    aliases = {norm(k): norm(v) for k, v in data.get("aliases", {}).items()}
    review = {norm(k): norm(v) for k, v in data.get("review", {}).items()}
    return known, aliases, review


def rewrite(text: str, mapping: dict[str, str]) -> tuple[str, list[tuple[str, str]]]:
    """Replace every value in ``mapping``, keeping the original prefix style."""
    changes: list[tuple[str, str]] = []

    def repl(match: re.Match[str]) -> str:
        old = norm(match.group("hex"))
        new = mapping.get(old)
        if new is None or new == old:
            return match.group(0)
        changes.append((old, new))
        return ("0x" + new[1:]) if match.group("prefix") == "0x" else new

    return HEX_RE.sub(repl, text), changes


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def do_check(aliases: dict[str, str], review: dict[str, str]) -> int:
    alias_drift = False
    review_hits: list[tuple[str, list[tuple[str, str]]]] = []

    for rel in TARGETS:
        _, found = rewrite(read(rel), aliases)
        if found:
            alias_drift = True
            for old, new in found:
                print(f"DRIFT  {rel}: {old} -> {new}")
        _, suggested = rewrite(read(rel), review)
        if suggested:
            review_hits.append((rel, suggested))

    if review_hits:
        total = sum(len(s) for _, s in review_hits)
        print(
            f"{total} off-palette suggestion(s) in {len(review_hits)} file(s) — run --report to review"
        )

    if alias_drift:
        print("\npalette drift found — run: uv run theme/sync_palette.py --write")
        return 1
    print("palette: all target files match theme/palette.toml")
    return 0


def do_write(
    aliases: dict[str, str], review: dict[str, str], apply_review: bool
) -> int:
    mapping = {**aliases, **review} if apply_review else dict(aliases)
    touched = 0

    for rel in TARGETS:
        path = ROOT / rel
        text = path.read_text(encoding="utf-8")
        updated, changes = rewrite(text, mapping)
        if updated == text:
            continue
        path.write_text(updated, encoding="utf-8")
        touched += 1
        for old, new in changes:
            print(f"  {rel}: {old} -> {new}")

    if touched == 0:
        print("palette: nothing to write (already in sync)")
    else:
        print(f"palette: updated {touched} file(s)")

    # Guard the JSON themes so a bad palette can never leave broken config.
    import json

    for rel in JSON_TARGETS:
        with (ROOT / rel).open(encoding="utf-8") as handle:
            json.load(handle)
        print(f"  valid JSON: {rel}")
    return 0


def do_report(known: set[str], aliases: dict[str, str], review: dict[str, str]) -> int:
    for rel in TARGETS:
        counts = Counter(norm(m.group("hex")) for m in HEX_RE.finditer(read(rel)))
        if not counts:
            continue
        print(f"\n{rel}")
        for color, count in sorted(counts.items()):
            if color in known:
                status = "palette"
            elif color in aliases:
                status = f"alias -> {aliases[color]}"
            elif color in review:
                status = f"review -> {review[color]}"
            else:
                status = "unknown"
            print(f"  {color}  x{count:<2} {status}")
    return 0


def hex_to_rgb(value: str) -> tuple[int, int, int]:
    digits = norm(value).lstrip("#")
    return tuple(int(digits[i : i + 2], 16) for i in (0, 2, 4))  # type: ignore[return-value]


def bg_swatch(value: str, width: int = 7) -> str:
    r, g, b = hex_to_rgb(value)
    return f"\x1b[48;2;{r};{g};{b}m{' ' * width}\x1b[0m"


def fg_swatch(value: str, text: str) -> str:
    r, g, b = hex_to_rgb(value)
    return f"\x1b[38;2;{r};{g};{b}m{text}\x1b[0m"


def luminance(value: str) -> float:
    r, g, b = hex_to_rgb(value)
    return 0.299 * r + 0.587 * g + 0.114 * b


def do_swatches(data: dict) -> int:
    print("\x1b[1mapp roles\x1b[0m")
    for role, value in data.get("app", {}).items():
        print(f"  {bg_swatch(value)}  {fg_swatch(value, role):<22} {value}")

    print("\n\x1b[1mansi 0-15\x1b[0m")
    ansi = data.get("ansi", {})
    for i in range(16):
        value = ansi.get(str(i))
        if value:
            print(
                f"  {i:>2}  {bg_swatch(value)}  {fg_swatch(value, value):<22} {value}"
            )

    print("\n\x1b[1mby brightness (dim -> bright)\x1b[0m")
    roles: dict[str, list[str]] = {}
    for role, value in data.get("app", {}).items():
        roles.setdefault(norm(value), []).append(role)
    for key, value in ansi.items():
        roles.setdefault(norm(value), []).append(f"ansi{key}")
    for value in sorted(roles, key=luminance, reverse=True):
        names = ", ".join(sorted(set(roles[value])))
        print(
            f"  {bg_swatch(value)}  {fg_swatch(value, f'{luminance(value):6.1f}'):<8}  {value}  {names}"
        )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument(
        "--check", action="store_true", help="fail if [aliases] values remain"
    )
    mode.add_argument(
        "--write", action="store_true", help="migrate [aliases] values in place"
    )
    mode.add_argument(
        "--report", action="store_true", help="audit every hex per file (default)"
    )
    mode.add_argument(
        "--swatches",
        action="store_true",
        help="render the palette as truecolor swatches",
    )
    parser.add_argument(
        "--review", action="store_true", help="with --write, also apply [review]"
    )
    args = parser.parse_args()

    data = load_data()
    known, aliases, review = load_palette(data)

    if args.swatches:
        return do_swatches(data)
    if args.check:
        return do_check(aliases, review)
    if args.write:
        return do_write(aliases, review, args.review)
    return do_report(known, aliases, review)


if __name__ == "__main__":
    sys.exit(main())
