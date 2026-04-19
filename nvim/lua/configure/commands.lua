-- File: Commands
-- Purpose: Define commands for use in neovim

local completion_sources = require("configure.completionsources")
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

local function format_lsp_state_lines(items)
  -- Inspect the current buffer's attached clients once so that
  -- listing all managed servers does not repeatedly query LSP state.
  local attached_clients = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    attached_clients[client.name] = true
  end

  local lines = {}
  for _, item in ipairs(items) do
    local enabled = language_servers.is_enabled(item) and "enabled " or "disabled"
    local attached = attached_clients[item] and "attached" or "detached"
    table.insert(lines, string.format("%-8s %-8s %s", enabled, attached, item))
  end
  return lines
end

local function show_states(title, items, is_enabled)
  vim.notify(table.concat(format_state_lines(items, is_enabled), "\n"), vim.log.levels.INFO, { title = title })
end

local function show_lsp_states(title, items)
  vim.notify(table.concat(format_lsp_state_lines(items), "\n"), vim.log.levels.INFO, { title = title })
end

local function run_state_command(opts)
  local words = split_args(opts.fargs and table.concat(opts.fargs, " ") or opts.args)
  local action = words[1] or "list"
  local name = words[2]

  if action == "list" then
    if opts.show_states ~= nil then
      opts.show_states(opts.title, opts.list())
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
      opts.show_states(opts.title, { name })
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

vim.api.nvim_create_user_command("CompletionSource", function(cmd)
  run_state_command({
    args = cmd.args,
    fargs = cmd.fargs,
    title = "Completion Sources",
    label = "completion source",
    list = completion_sources.list,
    is_enabled = completion_sources.is_enabled,
    set_enabled = completion_sources.set_enabled,
    toggle = completion_sources.toggle,
  })
end, {
  nargs = "*",
  complete = complete_state_command(completion_sources.list),
  desc = "Enable, disable, toggle, or list nvim-cmp sources",
})

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
