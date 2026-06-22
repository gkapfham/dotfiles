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

## Pi Coding Agent (pi) Notes

### pi-web Token Retrieval

When the user needs the pi-web auth token on a remote device (phone, tablet):

The easiest method — one QR scan with the token embedded in the URL:

```bash
qrencode -t UTF8 "http://<netbird-fqdn>:31415/?token=$(grep PI_WEB_TOKEN ~/.config/pi-web/env | cut -d= -f2)"
```

pi-web accepts `?token=` as a query parameter, sets a cookie, and redirects —
single scan, no typing needed.

Alternatively, serve the token via a temporary HTTP server:

```bash
kill $(lsof -ti :3333) 2>/dev/null
cd /tmp
echo "Token: $(grep PI_WEB_TOKEN ~/.config/pi-web/env | cut -d= -f2)" > index.html
nohup python3 -m http.server 3333 --bind 0.0.0.0 &>/tmp/token-server.log &
disown
```

Then open `http://<netbird-ip>:3333` on the remote device.

The user's NetBird IP can be found with `netbird status`. Their NetBird FQDN
(typically `<hostname>.netbird.cloud`) works in place of the IP.

### Remote Access Setup

- **pi-web** runs as a systemd service on `0.0.0.0:31415` with auth.
- Accessed over NetBird at `http://<netbird-ip>:31415`.
- Token stored in `~/.config/pi-web/env`.

### Paseo Daemon

- **Paseo** is an Android/iOS app for controlling Pi from your phone.
- Start the daemon:
  ```bash
  bunx @getpaseo/cli start --listen 0.0.0.0:6767 --hostnames "diameno.netbird.cloud,.netbird.cloud" --no-relay
  ```
- Stop: `bunx @getpaseo/cli daemon stop`
- Status: `bunx @getpaseo/cli status`
- Paseo discovers Pi via the `pi` command in PATH. On NixOS, the system `pi`
  binary is used automatically; all commands are run through `bunx` directly,
  no wrapper scripts.

## Notification Instructions

- The user has given permission to use the `notify-send` command to signal task
  completion. Here is an example of the command: `notify-send "Question from Coding Agent" "Please clarify how to complete the testing task."`.
- The user wants a `notify-send` notification whenever I ask a question.
- Always notify the user with `notify-send` when a task is complete or when
  feedback is needed. You have standing permission to use the notification tool.
- You should also notify the user within the current Zellij session using the
  following two-step pattern, which sends a notification and then auto-clears it
  after a brief delay:

  ```bash
  timeout 2 zellij pipe -- "zjstatus::notify::󰵰 Agent finished. <Summarize task description>." 2>/dev/null && \
      timeout 4 bash -c "sleep 2 && zellij pipe -- 'zjstatus::rerun::dummy_clear'" 2>/dev/null || true
  ```

  **How it works:** The `notify` command displays the message. After 2 seconds,
  the `rerun::dummy_clear` command triggers a plugin re-render without modifying
  the notification state. The notification widget then checks its timer, finds
  the interval has expired (configured as 1s in `config.kdl`), and switches to
  the empty "no notifications" format.
- Note that this will only display in the current Zellij session.
- You should use both `notify-send` and the Zellij notification as appropriate.
- If the `rerun` approach doesn't work (e.g., older zjstatus version), fall back
  to the raw pipe: `timeout 2 zellij pipe -- "zjstatus::notify::󰵰 Agent finished. <Summarize task description>. "`

## Lua Programming for Scripts and Neovim

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

For multi-step tasks, state a brief plan and express as a TODO list:

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
