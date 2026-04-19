-- File: configure/language_servers.lua
-- Purpose: Manage runtime state for built-in Neovim LSP servers

local M = {}

local managed_servers = {
  "cssls",
  "html",
  "gopls",
  "lua_ls",
  "marksman",
  "rumdl",
  "basedpyright",
  "pyrefly",
  "ruff",
  "ty",
  "zuban",
  "texlab",
  "harper_ls",
  "yamlls",
  "jsonls",
  "nil_ls",
  "rust_analyzer",
}

local disabled_servers = {}
local lsp_ready = false

local function refresh_hover_providers()
  -- Avoid eager initialization of hover.nvim before the first
  -- use of K because hover itself performs one-time setup that
  -- would otherwise duplicate the provider name decoration.
  if package.loaded["hover.actions"] == nil then
    return
  end

  local hover_config = require("hover.config")

  local config = hover_config.get()
  if config == nil or type(config.providers) ~= "table" then
    return
  end

  local hover_providers = require("hover.providers")

  -- hover.nvim builds its provider registry once and does not
  -- reliably add newly attached LSP clients to that registry.
  hover_providers.providers = {}
  package.loaded["hover.providers.lsp"] = nil
  hover_providers.init(config.providers)
end

local function ensure_valid_server(name)
  if not vim.tbl_contains(managed_servers, name) then
    error("Unknown language server: " .. name)
  end
end

function M.list()
  return vim.deepcopy(managed_servers)
end

function M.is_enabled(name)
  ensure_valid_server(name)
  if lsp_ready then
    return vim.lsp.is_enabled(name)
  end
  return not disabled_servers[name]
end

function M.set_enabled(name, enabled)
  ensure_valid_server(name)
  if enabled then
    disabled_servers[name] = nil
  else
    disabled_servers[name] = true
  end
  if lsp_ready then
    vim.lsp.enable(name, enabled)
    vim.schedule(refresh_hover_providers)
  end
  return not disabled_servers[name]
end

function M.toggle(name)
  return M.set_enabled(name, disabled_servers[name] ~= nil)
end

function M.apply()
  lsp_ready = true
  for _, name in ipairs(managed_servers) do
    vim.lsp.enable(name, not disabled_servers[name])
  end
end

function M.attached(name, bufnr)
  ensure_valid_server(name)
  bufnr = bufnr or 0
  return #vim.lsp.get_clients({ bufnr = bufnr, name = name }) > 0
end

function M.refresh_hover()
  refresh_hover_providers()
end

return M
