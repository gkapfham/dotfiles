# theme — one palette for every tool

`palette.toml` is the single source of truth for the color palette used by the
terminal (kitty, ghostty, termite, alacritty, wezterm), the shell prompt
(starship, fzf), the multiplexer (zellij), the launcher (rofi), the editor
(nvim), the agents (pi, opencode), the file manager (yazi) and the
notifications (dunst) and bar (polybar).

`sync_palette.py` keeps those configs in step. It never regenerates whole
files (that would fight the hand-formatting in each config); it replaces known
palette values in place, preserving each file's own prefix (`#rrggbb` or
`0xrrggbb`) and whitespace.

## Commands

```bash
uv run theme/sync_palette.py --report          # audit every hex per file (default)
uv run theme/sync_palette.py --swatches        # render the palette as truecolor swatches
uv run theme/sync_palette.py --check           # hard gate: fail on drifted values
uv run theme/sync_palette.py --write           # migrate retired [aliases]
uv run theme/sync_palette.py --write --review  # also apply [review] suggestions
```

`make check` runs `--check`, so drift cannot land unnoticed.

## Layout of `palette.toml`

| Section | Meaning | Consumers |
|---|---|---|
| `[app]` | semantic roles (`bg`, `fg`, `orange`, `blue`, …) | nvim, opencode, rofi, starship, yazi |
| `[ansi]` | terminal palette 0–15 | kitty, ghostty, termite, alacritty, wezterm, pi theme vars |
| `[aliases]` | retired values, auto-migrated by `--write` | any target that still carries them |
| `[review]` | off-palette values that need a human call | reported, applied only with `--review` |

## Changing a color

1. Edit the role in `[app]` or `[ansi]`.
2. Add the **old** value to `[aliases]`, pointing at the new one, so every
   stale copy elsewhere is rewritten:

   ```toml
   [aliases]
   "#6f9500" = "#708000"   # green, 2026-09
   ```

3. Run `uv run theme/sync_palette.py --write` and commit.

`--check` then passes, and any file that still used the old value has been
migrated in place.

## Files the palette does **not** own yet

These still carry their own colors and show up in `--report` as `unknown`:

- `shell/.tmux.conf` — uses 256-color indices (`colour234`, `colour246`), not hex.
- `gitstatus/gitstatus.prompt.zsh` — uses `%F{110}` indices (and is inert while
  Starship draws the prompt).
- `polybar/config.ini` module-level colors beyond `[colors]`.
- `yazi/theme.toml` — hundreds of per-filetype hexes; could be generated next.
- `hunk/config.toml` — the hunk theme spells the palette out by role, and its
  diff-row tints are blends of the background with a role (12% for a row, 18%
  for a changed span), so those blends are intentionally not palette values.
  Changing a role means editing that file by hand; see its header.
