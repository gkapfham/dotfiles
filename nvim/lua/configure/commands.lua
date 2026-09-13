-- File: Commands
-- Purpose: Define commands for use in neovim

local completion_sources = require("configure.completionsources")
local icons = require("configure.icons")
local language_servers = require("configure.languageservers")

local function split_args(args)
  return vim.split(vim.trim(args), "%s+", { trimempty = true })
end

local function filter_matches(items, arglead)
  local matches = {}
  for _, item in ipairs(items) do
    if arglead == "" or vim.startswith(item, arglead) then
      table.insert(matches, item)
    end
  end
  return matches
end

local function format_state_lines(items, is_enabled)
  local lines = {}
  for _, item in ipairs(items) do
    local state = is_enabled(item) and "enabled " or "disabled"
    table.insert(lines, string.format("%-8s %s", state, item))
  end
  return lines
end

local function format_icon_line(icon, name)
  -- Place spaces around the icon so that Nerd Font glyphs
  -- keep a consistent width in Noice notifications.
  return string.format("  %s %s", icon, name)
end

local function format_lsp_state_lines()
  -- Build one combined view that includes all managed language servers
  -- and any additional clients that are attached to the current buffer.
  local snapshot = {}
  local seen = {}

  for _, name in ipairs(language_servers.list()) do
    snapshot[#snapshot + 1] = {
      name = name,
      attached = false,
      enabled = language_servers.is_enabled(name),
      managed = true,
    }
    seen[name] = snapshot[#snapshot]
  end

  -- Update attachment state in one pass and add any extra clients
  -- so that the list reflects everything that is currently connected.
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local entry = seen[client.name]
    if entry == nil then
      entry = {
        name = client.name,
        attached = true,
        enabled = true,
        managed = false,
      }
      snapshot[#snapshot + 1] = entry
      seen[client.name] = entry
    else
      entry.attached = true
    end
  end

  -- Partition attached and detached servers instead of fully sorting
  -- the list so that attached items appear first at linear cost.
  local attached_lines = {}
  local enabled_detached_lines = {}
  local disabled_lines = {}

  for _, entry in ipairs(snapshot) do
    local line = format_icon_line(icons.lsp(entry.name), entry.name)
    if entry.attached then
      attached_lines[#attached_lines + 1] = line
    elseif entry.enabled then
      enabled_detached_lines[#enabled_detached_lines + 1] = line
    else
      disabled_lines[#disabled_lines + 1] = line
    end
  end

  local lines = {
    string.format("󰖩 Attached to current buffer (%d)", #attached_lines),
  }

  if #attached_lines == 0 then
    lines[#lines + 1] = "  󰅖 none"
  else
    vim.list_extend(lines, attached_lines)
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format(" Enabled but detached (%d)", #enabled_detached_lines)

  if #enabled_detached_lines == 0 then
    lines[#lines + 1] = "  󰅖 none"
  else
    vim.list_extend(lines, enabled_detached_lines)
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format(" Disabled (%d)", #disabled_lines)

  if #disabled_lines == 0 then
    lines[#lines + 1] = "  󰅖 none"
  else
    vim.list_extend(lines, disabled_lines)
  end

  return lines
end

local function format_completion_state_lines(items)
  -- Partition completion sources in a single pass so that
  -- enabled sources appear before disabled sources at low cost.
  local enabled_lines = {}
  local disabled_lines = {}

  for _, item in ipairs(items) do
    local line = format_icon_line(icons.completion_source(item), item)
    if completion_sources.is_enabled(item) then
      enabled_lines[#enabled_lines + 1] = line
    else
      disabled_lines[#disabled_lines + 1] = line
    end
  end

  local lines = {
    string.format(" Enabled completion sources (%d)", #enabled_lines),
  }

  if #enabled_lines == 0 then
    lines[#lines + 1] = "  󰅖 none"
  else
    vim.list_extend(lines, enabled_lines)
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = string.format(" Disabled completion sources (%d)", #disabled_lines)

  if #disabled_lines == 0 then
    lines[#lines + 1] = "  󰅖 none"
  else
    vim.list_extend(lines, disabled_lines)
  end

  return lines
end

local function show_states(title, items, is_enabled)
  vim.notify(table.concat(format_state_lines(items, is_enabled), "\n"), vim.log.levels.INFO, { title = title })
end

local function show_completion_states(title, items)
  -- Allow extra time for Noice to render the longer completion
  -- source summary without immediately collapsing the display.
  vim.notify(table.concat(format_completion_state_lines(items), "\n"), vim.log.levels.INFO, {
    title = title,
    timeout = 12000,
  })
end

local function show_lsp_states(title)
  -- Allow extra time for Noice to render the longer language
  -- server summary without immediately collapsing the display.
  vim.notify(table.concat(format_lsp_state_lines(), "\n"), vim.log.levels.INFO, {
    title = title,
    timeout = 12000,
  })
end

local function run_state_command(opts)
  local words = split_args(opts.fargs and table.concat(opts.fargs, " ") or opts.args)
  local action = words[1] or "list"
  local name = words[2]

  if action == "list" then
    if opts.show_states ~= nil then
      opts.show_states(opts.title)
    else
      show_states(opts.title, opts.list(), opts.is_enabled)
    end
    return
  end

  if name == nil then
    error(string.format("%s requires a name", action))
  end

  if action == "status" then
    if opts.show_states ~= nil then
      opts.show_states(opts.title)
    else
      show_states(opts.title, { name }, opts.is_enabled)
    end
    return
  end

  local enabled = nil
  if action == "enable" then
    enabled = true
  elseif action == "disable" then
    enabled = false
  elseif action == "toggle" then
    enabled = opts.toggle(name)
  else
    error("Unknown action: " .. action)
  end

  if action ~= "toggle" then
    enabled = opts.set_enabled(name, enabled)
  end

  local state = enabled and "enabled" or "disabled"
  vim.notify(string.format("%s %s %s", state:gsub("^%l", string.upper), opts.label, name), vim.log.levels.INFO)
end

local function complete_state_command(list_fn)
  return function(arglead, cmdline)
    local words = split_args(cmdline)
    local ends_with_space = vim.endswith(cmdline, " ")
    local actions = { "enable", "disable", "toggle", "status", "list" }

    if #words <= 1 then
      return filter_matches(actions, arglead)
    end

    if #words == 2 and not ends_with_space then
      return filter_matches(actions, arglead)
    end

    if words[2] == "list" then
      return {}
    end

    return filter_matches(list_fn(), arglead)
  end
end

-- Wrapping
vim.api.nvim_create_user_command("NoWrap", "set textwidth=0", {})
vim.api.nvim_create_user_command("StandardWrap", "set textwidth=80", {})
vim.api.nvim_create_user_command("TightWrap", "set textwidth=60", {})
vim.api.nvim_create_user_command("Wrap", "set textwidth=120", {})

-- Completion Sources
vim.api.nvim_create_user_command("CompletionSource", function(cmd)
  run_state_command({
    args = cmd.args,
    fargs = cmd.fargs,
    title = "Completion Sources",
    label = "completion source",
    list = completion_sources.list,
    is_enabled = completion_sources.is_enabled,
    show_states = function(title)
      show_completion_states(title, completion_sources.list())
    end,
    set_enabled = completion_sources.set_enabled,
    toggle = completion_sources.toggle,
  })
end, {
  nargs = "*",
  complete = complete_state_command(completion_sources.list),
  desc = "Enable, disable, toggle, or list nvim-cmp sources",
})

-- Language Servers
vim.api.nvim_create_user_command("LanguageServer", function(cmd)
  run_state_command({
    args = cmd.args,
    fargs = cmd.fargs,
    title = "Language Servers",
    label = "language server",
    list = language_servers.list,
    is_enabled = language_servers.is_enabled,
    show_states = show_lsp_states,
    set_enabled = language_servers.set_enabled,
    toggle = language_servers.toggle,
  })
end, {
  nargs = "*",
  complete = complete_state_command(language_servers.list),
  desc = "Enable, disable, toggle, or list managed language servers",
})

vim.api.nvim_create_user_command("LanguageServerRefreshHover", function()
  language_servers.refresh_hover()
  vim.notify("Refreshed hover.nvim LSP providers", vim.log.levels.INFO)
end, {
  desc = "Refresh hover.nvim providers for current LSP clients",
})
