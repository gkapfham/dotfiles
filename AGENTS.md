# AGENTS.md

This document outlines the standards and conventions for maintaining this dotfiles
repository. Adhering to these guidelines ensures consistency, readability, and
ease of maintenance.

## Philosophy

These dotfiles are intended to create a highly personalized and efficient
development environment on a NixOS-based Linux workstation. The configurations
prioritize:

- **Performance:** Tools and configurations are chosen and optimized for speed.
- **Keyboard-driven workflow:** Heavy reliance on keyboard shortcuts and
  command-line tools.
- **Consistency:** A cohesive experience across different tools (e.g., shell,
  editor, terminal).
- **Minimalism:** Avoid unnecessary clutter and complexity.

## Makefile

The `Makefile` in this repository automates the setup and management of dotfiles.
It uses GNU Stow to create symbolic links from the files in this repository to
the appropriate locations in the user's home directory.

- **`make dotfiles`**: This is the default target. It runs the `create`, `stow`,
  and `stow-external` targets to set up all dotfiles.
- **`make create`**: Creates the necessary directories in `~/.config` and `~/.zsh`
  for the dotfiles to be stowed correctly.
- **`make stow`**: Stows the dotfiles for the core applications and configurations.
- **`make stow-external`**: Stows the dotfiles for the Zsh plugins that are
  included as submodules.
- **`make clean`**: This target is not fully implemented and should be used with
  caution. It is intended to remove generated files.
- **`make purge`**: This target is also not fully implemented and should be used
  with caution. It is intended to remove all stowed dotfiles.
- **`make help`**: Lists all available targets in the Makefile.

When adding a new configuration that needs to be stowed, you will need to add a
new target to the `Makefile`. The target should be named `stow-<program>` and
should depend on a `create-<program>` target that creates the necessary
directories.

## Commenting Strategy

The commenting strategy in this repository varies by file type, but the general
goal is to explain the *why* behind the code, not the *what*.

- **Lua (Neovim):**
  - File-level comments describe the purpose of the file (e.g.,
    `-- File: plugins/colorscheme.lua`).
  - Multi-line comments (`--[[ ... ]]`) are used for more detailed explanations.
  - Single-line comments (`--`) are used for brief explanations of specific
    lines or blocks of code.
- **Zsh (`.zshrc`):**
  - Sections are delineated with folding markers (`{{{ ... }}}`).
  - Comments within sections explain the purpose of aliases, functions, and
    environment variables.
- **Makefile:**
  - Sections are delineated with folding markers (\`## {{{
    ...

## }}}\`).

- Comments explain the purpose of each target and the overall structure of the
  file.

## Neovim Configuration

The Neovim configuration is managed by `lazy.nvim`, a modern plugin manager for
Neovim.

- **Plugin Management:**
  - Plugins are defined as specifications in files located in the
    `nvim/lua/plugins/` directory.
  - Each file in this directory can contain one or more plugin specifications.
  - A plugin specification is a Lua table that includes the plugin's name (e.g.,
    `"olimorris/onedarkpro.nvim"`) and optional properties like `lazy`,
    `priority`, and `config`.
- **`lazy.nvim` Configuration:**
  - The main `lazy.nvim` configuration is in `nvim/init.lua`.
  - The `spec` property is set to `"plugins"`, which tells `lazy.nvim` to look for
    plugin specifications in the `nvim/lua/plugins/` directory.
  - The `defaults.lazy` property is set to `true`, so all plugins are loaded
    lazily by default.
  - The `install.colorscheme` property is set to `onedark_dark` to ensure the
    colorscheme is loaded on startup.
- **Adding a New Plugin:**
  1. Create a new file in `nvim/lua/plugins/` or add the plugin specification to
     an existing file.
  1. The plugin specification should be a Lua table with the plugin's name and
     any necessary configuration.
  1. If the plugin needs to be loaded on startup, set `lazy = false`.
  1. If the plugin has a specific loading priority, set the `priority` property.

## Shell Configuration

- **Zsh:** The main configuration is `shell/.zshrc`, organized with `{{{ ... }}}` folding markers.
- **Tmux:** The configuration is in `shell/.tmux.conf`.
- **Starship:** The prompt is configured in `starship/starship.toml`.

## Commit Message Conventions

- Do not commit files.

## Notification Instructions

- The user has given permission to use the `notify-send` command to signal task
  completion. Here is an example of the command: `notify-send "Question from Coding Agent" "Please clarify how to complete the testing task."`.
- The user wants a `notify-send` notification whenever I ask a question.
- Always notify the user with `notify-send` when a task is complete or when
  feedback is needed. You have standing permission to use the notification tool.
- You should also use the following command to notify the user when you are
  finished with a task or need further help: `timeout 2 zellij pipe -- "zjstatus::notify::󰵰 Agent finished. <Summarize task description>. This is fun. "`
- Note that this command will only display in the current Zellij session.
  Please also note that you need to add a space at the end of the notification.
- You should use both notification methods as appropriate, making sure that the
  Zellij command is always prefaced with a timeout of 2 seconds.

## Lua Programming

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface trade-offs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes,
simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it
work") require constant clarification.

### Use Command-Line Tools

Using Lua-based linters and formatters to confirm that the
code that you are writing is correct. With that said, plugins
and configurations and extensions should be written in pure
Lua and not require calls to external tools or files.
