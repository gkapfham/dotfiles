-- File: configure/icons.lua
-- Purpose: Define the icons used throughout neovim

local M = {}

-- Define a lookup table for LSP client abbreviations;
-- note that the names are normalized to use underscores
-- so that clients with dashes match the same icon table.
local lsp_abbreviations = {
  cssls = "",
  copilot = "󰊤",
  harper_ls = "󰈙",
  html = "",
  htmx = "",
  jsonls = "",
  lua_ls = "󰢱",
  gopls = "",
  marksman = "",
  nil_ls = "",
  null_ls = "󰁨",
  otter_ls = "󰌨",
  pyrefly = "",
  basedpyright = "󱔎",
  pyright = "󰌠",
  render_markdown = "󰍕",
  ruff = "󱝁",
  ruff_lsp = "󱝁",
  rumdl = "󱒄",
  rust_analyzer = "󱘗",
  texlab = "",
  ty = "󱙨",
  yamlls = "",
  zk = "",
  zuban = "",
}

-- Define a lookup table for completion source icons;
-- note that the values here mirror the visual language
-- already used inside of the nvim-cmp completion menu.
local completion_source_icons = {
  buffer = "",
  cmdline = "",
  cmp_yanky = "",
  copilot = "󰊤",
  fuzzy_buffer = "󰓐",
  luasnip = "",
  minuet = "",
  nerdfont = "",
  nvim_lsp = "",
  nvim_lsp_document_symbol = "",
  nvim_lsp_signature_help = "󰋖",
  otter = "󰌨",
  pandoc_references = "",
  path = "",
  spell = "",
  supermaven = "",
  tags = "",
  treesitter = "",
}

local function normalize_lsp_name(name)
  local base_name = name:match("^[^%[]+") or name
  return base_name:gsub("-", "_")
end

function M.lsp(name)
  return lsp_abbreviations[normalize_lsp_name(name)] or ""
end

function M.completion_source(name)
  return completion_source_icons[name] or "󰘦"
end

return M
