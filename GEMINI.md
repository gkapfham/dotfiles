# GEMINI.md

This document provides instructions for Gemini, the AI assistant, on how to
interact with this dotfiles repository.

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
  - Sections are delineated with folding markers (`## {{{
...
## }}}`).
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
  1.  Create a new file in `nvim/lua/plugins/` or add the plugin specification to
      an existing file.
  2.  The plugin specification should be a Lua table with the plugin's name and
      any necessary configuration.
  3.  If the plugin needs to be loaded on startup, set `lazy = false`.
  4.  If the plugin has a specific loading priority, set the `priority` property.

## Reading and Modifying Files

- Before modifying any file, read it to understand its structure and conventions.
- When adding new configurations, follow the existing style and organization.
- For Neovim, if adding a new plugin, create a new file in `nvim/lua/plugins/`.
- For Zsh, add new configurations to the appropriate section in `shell/.zshrc`.