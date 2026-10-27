# Yazi File Manager Configuration

## Quick Reference

### Navigation

| Key | Action |
|-----|--------|
| `j` / `k` | Move cursor down / up |
| `h` | Go to parent directory |
| `l` | Enter directory / preview file |
| `H` / `L` | Back / forward in history |
| `gg` | Go to top |
| `G` | Go to bottom |
| `Ctrl+u` / `Ctrl+d` | Half page up / down |
| `Ctrl+b` / `Ctrl+f` | Full page up / down |

### Opening Files

| Key | Action |
|-----|--------|
| `Enter` or `o` | Open file with `$EDITOR` (text) or default app (images, etc.) |
| `O` or `Shift+Enter` | Open interactively (choose which program) |

Text files open in **nvim** (blocking — yazi hides, nvim shows, yazi returns on quit).
Images open with `xdg-open` in a separate window.

### The Three Panels

The layout is `[1, 4, 3]` — three panels:

1. **Left (1/8):** Parent directory
2. **Middle (4/8):** Current directory (where you navigate)
3. **Right (3/8):** Preview pane

The **preview pane** automatically shows:
- Syntax-highlighted code for text files
- Image previews (in Ghostty, uses kitty graphics protocol)
- Directory contents for folders
- Archive listings for compressed files

Just hover over a file with `j`/`k` — no key press needed for preview.

### Selection & Operations

| Key | Action |
|-----|--------|
| `Space` | Toggle select current file, move to next |
| `v` | Enter visual (selection) mode |
| `V` | Enter visual mode (unset) |
| `Ctrl+a` | Select all |
| `Ctrl+r` | Invert selection |
| `y` | Yank (copy) selected files |
| `x` | Yank (cut) selected files |
| `p` | Paste yanked files |
| `P` | Paste (overwrite) |
| `d` | Trash selected files |
| `D` | Permanently delete |
| `a` | Create file (end with `/` for directory) |
| `r` | Rename |
| `Y` / `X` | Cancel yank |

### The Which Popup

Press the **first key** of any multi-key sequence and **wait** — the which popup
appears showing all available completions:

| Press | Shows options for... |
|-------|---------------------|
| `g` | **Goto:** `g` then `h`=home, `c`=~/.config, `d`=~/Downloads, `g`=top, `f`=follow symlink |
| `c` | **Copy info:** `c` then `c`=path, `d`=dirname, `f`=filename, `n`=name without ext |
| `m` | **Linemode:** `m` then `s`=size, `p`=permissions, `m`=mtime, `b`=btime, `o`=owner, `n`=none |
| `,` | **Sort:** `,` then `a`/`A`=alpha, `s`/`S`=size, `m`/`M`=mtime, `e`/`E`=ext, `n`/`N`=natural (uppercase=reverse) |

### Search & Filter

| Key | Action |
|-----|--------|
| `/` | Find next file by name |
| `?` | Find previous |
| `n` / `N` | Next / previous match |
| `f` | Filter files in current directory |
| `s` | Search by filename (via `fd`) |
| `S` | Search by content (via `rg`) |
| `Ctrl+s` | Cancel search |
| `z` | Jump via `fzf` |
| `Z` | Jump via `zoxide` |

### Tabs

| Key | Action |
|-----|--------|
| `t` | New tab with current directory |
| `1`-`9` | Switch to tab N |
| `[` / `]` | Previous / next tab |
| `{` / `}` | Swap tab left / right |

### Other

| Key | Action |
|-----|--------|
| `.` | Toggle hidden files |
| `w` | Show task manager |
| `~` or `F1` | Full help screen |
| `Tab` | Spot (inspect) hovered file |
| `K` / `J` | Seek up/down in preview |
| `;` | Run shell command |
| `:` | Run shell command (blocking) |
| `q` | Quit |
| `Q` | Quit without outputting cwd |

### Using Yazi to Change Directories

Add this to `~/.zshrc` to make `y` launch yazi and cd to wherever you quit:

```zsh
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
```

Then run `y` instead of `yazi`. Navigate where you want, press `q`, and your
shell will be in that directory.

## Troubleshooting

### Preview pane is blank

Run `yazi --debug` inside your actual terminal (Ghostty) and check:
- `Adapter.matches` should say `Kgp` (kitty graphics protocol) for image preview
- If it says `X11` or `Unknown`, your `$TERM` variable may be wrong

**Do not** override `$TERM` in your shell config — Ghostty sets it correctly.

### Image preview in Zellij

Zellij only supports Sixel (buggy). For best results, run yazi directly in
Ghostty without Zellij. Text/code preview works fine in Zellij.

## Files

- `yazi.toml` — Main config (layout, openers, preview)
- `keymap.toml` — All keybindings
- `theme.toml` — Colors and icons
