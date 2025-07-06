# GEMINI.md

This document provides instructions for Gemini, the AI assistant, on how to
interact with this dotfiles repository.

## Build, Lint, and Test Commands

- **Makefile:** Use `make help` to list all available targets.
  - `make dotfiles`: Set up the dotfiles by creating necessary symlinks.
  - `make stow`: Stow all configurations using GNU Stow.
  - `make clean`: Remove generated files (in relevant subdirectories).
- **Zsh Plugins:**
  - `cd zsh-syntax-highlighting && make test`: Run all tests for the syntax
  highlighting plugin.
  - `cd zsh-autosuggestions && make test`: Run RSpec tests for the
  autosuggestions plugin.
- **C++ (gitstatus):**
  - `cd gitstatus && make`: Build the `gitstatus` binary.
  - `make clean`: Clean the build artifacts.

## Code Style Guidelines

- **General:**
  - **Indentation:** Use two spaces for indentation, unless the file type
  dictates otherwise (e.g., Makefiles use tabs).
  - **Blank Spaces:** Avoid trailing blank spaces.
  - **Naming:** Use clear, descriptive, and consistent names for files,
  functions, and variables.
- **Shell (Zsh):**
  - Strive for POSIX-compliant scripts where possible, but leverage Zsh features
  for `.zshrc` and interactive use.
  - Use lowercase, hyphen-separated names for files and directories.
  - Functions and variables should be descriptive and use snake_case.
- **Lua (Neovim):**
  - Follow the standard Lua style guide.
  - Use `local` for all variables unless they need to be globally accessible.
  - Prefer modules for organizing code.

## Neovim Configuration

- **Plugin Management:** Plugins are managed with `lazy.nvim`. Plugin
specifications are in `nvim/lua/plugins/`.
- **Structure:** The entry point is `nvim/init.lua`. Core configuration is in
`nvim/lua/configure/`.
- **Keymaps:** The leader key is `,`. Keymaps are in
`nvim/lua/configure/keymaps.lua`.

## Shell Configuration

- **Zsh:** The main configuration is `shell/.zshrc`, organized with `{{{ ...
}}}` folding markers.
- **Tmux:** The configuration is in `shell/.tmux.conf`.
- **Starship:** The prompt is configured in `starship/starship.toml`.

## Reading and Modifying Files

- Before modifying any file, read it to understand its structure and conventions.
- When adding new configurations, follow the existing style and organization.
- For Neovim, if adding a new plugin, create a new file in `nvim/lua/plugins/`.
- For Zsh, add new configurations to the appropriate section in `shell/.zshrc`.
