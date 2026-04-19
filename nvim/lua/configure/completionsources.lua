-- File: configure/completion_sources.lua
-- Purpose: Manage completion source state for nvim-cmp

local M = {}

local insert_primary_sources = {
  { name = "treesitter", max_item_count = 10, priority = 10, keyword_length = 1 },
  { name = "nvim_lsp", max_item_count = 10, priority = 10, keyword_length = 1 },
  { name = "copilot", max_item_count = 10, priority = 10, keyword_length = 1 },
  { name = "supermaven", max_item_count = 10, priority = 10, keyword_length = 1 },
  { name = "minuet", max_item_count = 10, priority = 10, keyword_length = 2 },
  {
    name = "buffer",
    max_item_count = 10,
    priority = 20,
    keyword_length = 3,
    option = {
      get_bufnrs = function()
        return vim.api.nvim_list_bufs()
      end,
    },
  },
  { name = "fuzzy_buffer", max_item_count = 5, priority = 6, keyword_length = 4 },
  { name = "cmp_yanky", max_item_count = 5, priority = 6, keyword_length = 4 },
  { name = "tags", max_item_count = 5, priority = 5, keyword_length = 2 },
  { name = "luasnip", max_item_count = 5, priority = 5, keyword_length = 2 },
  { name = "otter", max_item_count = 5, priority = 5, keyword_length = 2 },
  { name = "pandoc_references", max_item_count = 5, priority = 5, keyword_length = 2 },
  {
    name = "spell",
    option = {
      keep_all_entries = false,
      enable_in_context = function()
        return true
      end,
    },
    max_item_count = 5,
    priority = 10,
    keyword_length = 3,
  },
  {
    name = "path",
    option = {
      get_cwd = function()
        return vim.fn.getcwd()
      end,
    },
    max_item_count = 5,
    priority = 10,
    keyword_length = 3,
  },
  { name = "nerdfont", max_item_count = 10, priority = 1, keyword_length = 3 },
  { name = "nvim_lsp_signature_help" },
}

local insert_secondary_sources = {}

local cmdline_sources = {
  ["/"] = {
    primary = {
      { name = "path" },
      { name = "buffer", max_item_count = 15, priority = 10 },
      { name = "fuzzy_buffer", max_item_count = 15, priority = 5 },
    },
    secondary = {
      { name = "cmdline" },
    },
  },
  ["?"] = {
    primary = {
      { name = "path" },
      { name = "buffer", max_item_count = 15, priority = 10 },
      { name = "fuzzy_buffer", max_item_count = 15, priority = 5 },
    },
    secondary = {
      { name = "cmdline" },
    },
  },
  [":"] = {
    primary = {
      { name = "cmdline", max_item_count = 30 },
    },
    secondary = {},
  },
}

local disabled_sources = {}
local apply_cmp_setup = nil
local known_sources = {}

local function register_known_sources(sources)
  for _, source in ipairs(sources) do
    if source.name ~= nil and not vim.tbl_contains(known_sources, source.name) then
      table.insert(known_sources, source.name)
    end
  end
end

register_known_sources(insert_primary_sources)
register_known_sources(insert_secondary_sources)
for _, config in pairs(cmdline_sources) do
  register_known_sources(config.primary)
  register_known_sources(config.secondary)
end

local function ensure_valid_source(name)
  if not vim.tbl_contains(known_sources, name) then
    error("Unknown completion source: " .. name)
  end
end

local function filter_sources(sources)
  return vim.tbl_filter(function(source)
    return not disabled_sources[source.name]
  end, vim.deepcopy(sources))
end

function M.list()
  return vim.deepcopy(known_sources)
end

function M.is_enabled(name)
  ensure_valid_source(name)
  return not disabled_sources[name]
end

function M.set_enabled(name, enabled)
  ensure_valid_source(name)
  if enabled then
    disabled_sources[name] = nil
  else
    disabled_sources[name] = true
  end
  if apply_cmp_setup ~= nil then
    apply_cmp_setup()
  end
  return not disabled_sources[name]
end

function M.toggle(name)
  return M.set_enabled(name, disabled_sources[name] ~= nil)
end

function M.register(apply_fn)
  apply_cmp_setup = apply_fn
end

function M.get_insert_sources(cmp)
  return cmp.config.sources(filter_sources(insert_primary_sources), filter_sources(insert_secondary_sources))
end

function M.get_cmdline_sources(cmp, command_type)
  local config = cmdline_sources[command_type]
  if config == nil then
    error("Unknown completion command type: " .. command_type)
  end
  return cmp.config.sources(filter_sources(config.primary), filter_sources(config.secondary))
end

return M
