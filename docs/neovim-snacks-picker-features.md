# Neovim Snacks Picker Features and Proposed Mappings

## Purpose

This note records four `snacks.nvim` picker features worth investigating and
the keymaps proposed for `nvim/lua/plugins/snacking.lua`.

`lsp_config` is new in 2026; `git_diff` gained hunk staging in late 2025;
`grep_buffers` and `pickers` are older sources that are easy to miss. None of
these changes touch the completion engines. The Supermaven, Minuet, and
Copilot NES findings are listed as follow-ups at the end.

## Background

The investigation started with a completion problem: the Supermaven backend
started returning `Unauthorized (fatal)` in
`~/.cache/nvim/supermaven-nvim.log`, and the plugin could no longer
authenticate. Minuet is configured against `CODESTRAL_API_KEY`, which is not
set in the current environment. Copilot is therefore the only live completion
engine at the moment.

That is separate from these picker changes. This document focuses on picker
features that are already available in the installed `snacks.nvim`.

## 1. `Snacks.picker.lsp_config()` (new in v2.31)

An inspection picker for every LSP configuration Neovim can see.

```vim
:lua Snacks.picker.lsp_config()
:lua Snacks.picker.lsp_config({ attached = 0 })
:lua Snacks.picker.lsp_config({ configured = true })
:lua Snacks.picker.lsp_config({ installed = true })
```

Each row shows a status icon (attached to the current buffer, attached
elsewhere, enabled, disabled, or unavailable), the server name, and its
filetypes.

The preview shows:

- `cmd`, binary path, installed/enabled state, filetypes, and root markers
- for each running client: server info, workspace folders, and attached
  buffers
- server capabilities, including advertised `workspace/executeCommand`
  commands and `textDocument/codeAction` kinds
- dynamic capabilities, settings, and init options
- the docs header from the `lsp/<name>.lua` file

Useful filters:

| Option | Effect |
| --- | --- |
| `attached = 0` | only servers attached to the current buffer |
| `attached = true` | only servers attached to any buffer |
| `attached = <bufnr>` | only servers attached to a specific buffer |
| `configured = true` | only configurations enabled with `vim.lsp.enable` |
| `installed = true` | only servers whose binary is installed |

Important: the picker is read-only. `confirm = "close"` simply closes it; it
does not run code actions or enable/disable servers. It answers questions such
as "why is this server not attaching?" and "what can this server do?" Use the
existing `:LanguageServer` command for enabling and disabling servers.

Proposed mapping: `<leader>sL` for
`Snacks.picker.lsp_config({ attached = 0 })`.

## 2. `Snacks.picker.git_diff()` (hunk staging since v2.28)

The existing `<leader>gd` mapping already uses this picker, so the new staging
and restore keys are available without any change.

```vim
:lua Snacks.picker.git_diff()
:lua Snacks.picker.git_diff({ group = true })
:lua Snacks.picker.git_diff({ staged = true })
:lua Snacks.picker.git_diff({ base = "framework" })
```

Options:

| Option | Effect |
| --- | --- |
| `group = false` | one item per hunk (the default) |
| `group = true` | one item per file |
| `staged = true` | show staged changes |
| `base = "framework"` | compare against a branch, tag, or commit |

While the input line is focused:

- `<Tab>` stages or unstages the current hunk or file. For hunks it pipes the
  diff to `git apply --cached` (or `--reverse` to unstage); for files it uses
  `git add` or `git restore --staged`.
- `<C-r>` restores or discards the change. For an unstaged hunk it
  reverse-applies it; for a staged hunk it removes it from the index; for a
  file it runs `git restore`. It asks for confirmation first, but the action
  is destructive.
- `<S-Tab>` or `<C-a>` selects multiple items; then `<Tab>` stages the
  selection.

The preview uses the newer fancy diff renderer with syntax highlighting. This
is useful for reviewing a feature branch before opening a pull request:
`git_diff({ base = "framework" })` shows the whole branch diff, and individual
hunks can be staged or discarded without leaving the picker.

Proposed mappings:

- `<leader>gd` (existing) for `Snacks.picker.git_diff()`
- `<leader>gv` for `Snacks.picker.git_diff({ base = "framework" })`
- `<leader>gV` for `Snacks.picker.git_diff({ staged = true })`

The `framework` base assumes that `framework` remains the mainline branch.
Change it if the branch is renamed.

## 3. `Snacks.picker.grep_buffers()` (older source)

Searches the contents of open, file-backed buffers.

```vim
:lua Snacks.picker.grep_buffers()
:lua Snacks.picker.grep_buffers({ ft = "lua" })
```

It collects every listed buffer with a name that exists on disk and passes
those paths to ripgrep. It is not limited to visible windows: hidden listed
buffers count. Unnamed, scratch, and unlisted buffers are excluded.

The distinction between the three grep-style pickers:

| Picker | Scope | Sees unsaved edits? |
| --- | --- | --- |
| `Snacks.picker.lines()` | current buffer | yes, in-memory |
| `Snacks.picker.grep_buffers()` | all listed open files | no, reads disk |
| `Snacks.picker.grep()` | whole project | no, reads disk |

`grep_buffers` sets `need_search = false`, so it opens by listing every line
from those buffers and filters live as the query is typed. That is convenient
with a handful of files, but can be heavy if many large buffers are open. For
literal searches, pass `regex = false`; for filetypes and globs, pass `ft` and
`glob`.

Proposed mapping: `<leader>sB` for `Snacks.picker.grep_buffers()`.

## 4. `Snacks.picker.pickers()` and the meta family

A discovery menu for every picker source.

```vim
:lua Snacks.picker.pickers()
```

It lists every source defined in `snacks/picker/config/sources.lua`. Selecting
an entry runs that picker with its defaults; the preview shows its source
definition. It is the fastest way to discover sources that are not mapped yet.

The rest of the meta family is useful when customizing the picker:

- `Snacks.picker.picker_actions()` lists every picker action and jumps to its
  definition. This is the best way to find action names for custom keymaps.
- `Snacks.picker.picker_layouts()` moves through layouts and previews them
  live.
- `Snacks.picker.picker_format()` and `Snacks.picker.picker_preview()` list
  formatters and previewers and jump to their definitions.

Proposed mapping: `<leader>sP` for `Snacks.picker.pickers()`.

## Proposed keymaps

These are the mappings added to the `keys` table in
`nvim/lua/plugins/snacking.lua`:

```lua
{
  "<leader>sL",
  function()
    Snacks.picker.lsp_config({ attached = 0 })
  end,
  desc = "LSP: Config for Current Buffer",
},
{
  "<leader>sB",
  function()
    Snacks.picker.grep_buffers()
  end,
  desc = "Grep: Open Buffers",
},
{
  "<leader>sP",
  function()
    Snacks.picker.pickers()
  end,
  desc = "Snacks: All Pickers",
},
{
  -- Compare the current branch against the framework mainline;
  -- change the base if the mainline branch is renamed.
  "<leader>gv",
  function()
    Snacks.picker.git_diff({ base = "framework" })
  end,
  desc = "Git Diff vs framework",
},
{
  "<leader>gV",
  function()
    Snacks.picker.git_diff({ staged = true })
  end,
  desc = "Git Diff: Staged",
},
```

The existing `<leader>gd` mapping needs no change; it already opens
`Snacks.picker.git_diff()`.

## Verification

Parse the edited Lua file without loading the full configuration:

```bash
nvim --headless --clean \
  +'lua assert(loadfile("nvim/lua/plugins/snacking.lua"))' +qa
```

Then try the pickers manually:

```vim
:lua Snacks.picker.lsp_config({ attached = 0 })
:lua Snacks.picker.git_diff({ base = "framework" })
:lua Snacks.picker.grep_buffers()
:lua Snacks.picker.pickers()
```

## Follow-ups (not in this pull request)

- Remove `supermaven-nvim` from `nvim/lua/plugins/completion.lua` and remove
  the `supermaven` source from `nvim/lua/configure/completionsources.lua`.
  The backend is returning `Unauthorized (fatal)`, and the plugin only adds
  log noise now.
- Either set `CODESTRAL_API_KEY` or switch Minuet to a working provider such
  as Gemini, DeepSeek, or a local Ollama model.
- Enable Copilot next-edit suggestions through Sidekick: add `copilot` to
  `managed_servers` in `nvim/lua/configure/languageservers.lua`, set
  `nes = { enabled = true }`, and bind
  `require("sidekick").nes_jump_or_apply()`.
- Consider enabling the `gh` module, `gitbrowse`, `scratch`, `words`, `zen`,
  and `profiler` in `snacks.nvim`. The `gh` module is currently disabled even
  though issue and pull-request pickers are already mapped.

## References

- Snacks picker documentation:
  <https://github.com/folke/snacks.nvim/blob/main/docs/picker.md>
- Snacks `gh` documentation:
  <https://github.com/folke/snacks.nvim/blob/main/docs/gh.md>
- Sidekick:
  <https://github.com/folke/sidekick.nvim>
- Minuet:
  <https://github.com/milanglacier/minuet-ai.nvim>
- Supermaven sunset announcement:
  <https://supermaven.com/blog/sunsetting-supermaven>

---

Prepared by Pi on 2026-11-13. Verify the mappings against the current
`snacking.lua` before merging.
