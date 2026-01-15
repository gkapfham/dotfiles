-- File: plugins/lualine.lua
-- Purpose: load and configure the lualine plugin
-- and the extensions designed for lualine

-- Define functions in lua {{{

local function lsp_clients()
  -- Define a lookup table for LSP client abbreviations
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
    texlab = "",
    ty = "󱙨",
    yamlls = "",
    zk = "",
    zuban = "",
  }
  -- Get the active LSP clients
  -- and return the client names
  -- local clients = vim.lsp.get_active_clients()
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return "󱥑 LSP"
  end
  local client_names = {}
  for _, client in ipairs(clients) do
    -- Get the base name of the client
    -- and replace any dashes with underscores
    local base_name = client.name:match("^[^%[]+")
    base_name = base_name:gsub("-", "_")
    -- Get the abbreviation for the client
    -- and append it to the list of client names;
    -- note that the abbreviation is an icon
    -- defined in the lsp_abbreviations table;
    -- note that the abbreviation is an icon
    -- defined in the lsp_abbreviations table;
    -- Make sure that the abbreviation is not
    -- already in the list of client names
    -- (this can take place because of the fact
    -- that, for instance, the Otter-ls client
    -- has numbers in its name inside of brackets.
    -- But, there should only be a single icon
    -- to indicate that the client is active)
    local abbreviation = lsp_abbreviations[base_name] or base_name
    local exists = false
    for _, name in ipairs(client_names) do
      if name == abbreviation then
        exists = true
        break
      end
    end
    -- Only add the abbreviation if it does not already exist
    -- in the list of client names (this prevents an icon
    -- from being added and displayed in lualine twice)
    if not exists then
      table.insert(client_names, abbreviation)
    end
  end
  -- Return the client icons as a string with spaces
  return "" .. table.concat(client_names, " ")
end

local function spell_status()
  -- Use Nerd Font icons for languages
  local lang_icons = {
    ["en_us"] = "",
    ["en_gb"] = "",
  }
  -- Assign the icon based on the spelling language
  local lang = vim.o.spelllang
  local icon = lang_icons[lang] or ""
  if vim.o.spell then
    return "󰓆 󰔡 " .. icon
  else
    return "󰓆 󰔢 " .. icon
  end
end

local aerial = require("aerial")
local function format_status(symbols, depth, separator, icons_enabled)
  local parts = {}
  depth = depth or #symbols
  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end
  for _, symbol in ipairs(symbols) do
    if icons_enabled then
      table.insert(parts, string.format("%s %s", symbol.icon, symbol.name))
    else
      table.insert(parts, symbol.name)
    end
  end
  return table.concat(parts, separator)
end

-- The API to output the symbols structure
---@diagnostic disable-next-line: lowercase-global
function output_symbols_structure(depth, separator, icons_enabled)
  local symbols = aerial.get_location(true)
  local symbols_structure = format_status(symbols, depth, separator, icons_enabled)
  print(symbols_structure)
end

-- Define a function for displaying the current result number
-- out of total number of results when searching with / or ?.
-- Note that this assumes that the shortmess parameter has
-- already been set to include the S flag in configure/settings.lua.
local function search_count()
  if vim.api.nvim_get_vvar("hlsearch") == 1 then
    local res = vim.fn.searchcount({ maxcount = 999, timeout = 500 })
    if res.total > 0 then
      return string.format(" %d/%d %s", res.current, res.total, vim.fn.getreg("/"))
    end
  end
  return ""
end

-- Define a function for showing diff information in the
-- lualine through the use of the gitsigns plugin; note
-- that this approach seems faster than one in lualine
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

--- }}}

-- Define the color scheme for the lualine;
-- this matches the color scheme called
-- vitaminonec; see the lua/plugins/colorscheme.lua
-- for more details about the specific colorscheme
local colors = {
  color2 = "#87afd7",
  color7 = "#d75f5f",
  color10 = "#b7b757",
  color6 = "#626262",
  color3 = "#a569a5",
  color1 = "#262626",
  color0 = "#c1c1c1",
}
local vitaminonec = {
  normal = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color2, gui = "bold" },
    c = { fg = colors.color0, bg = colors.color1 },
  },
  visual = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color3, gui = "bold" },
  },
  inactive = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color0, bg = colors.color1, gui = "none" },
    c = { fg = colors.color6, bg = colors.color1 },
  },
  replace = {
    jb = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color7, gui = "bold" },
  },
  insert = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color10, gui = "bold" },
  },
}

local function statusline_python_env()
  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= "" then
    local name = venv:match("([^/]+)$")
    if name then
      return " " .. name
    end
  end
  return ""
end

local function statusline_readonly()
  return vim.bo.readonly and "" or ""
end

-- local function statusline_spell()
--   return vim.wo.spell and "A-Z " or "A-Z "
-- end

-- local function file_tree()
--   return ""
-- end

-- local function treesitter_context()
--   local ok, ts_status = pcall(vim.fn.nvim_treesitter_statusline, 90)
--   if ok then
--     return ts_status
--   end
--   return ""
-- end

return {

  -- lualine.nvim
  -- Lualine for top and bottom bars
  -- and for the winbar
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
      "arkav/lualine-lsp-progress",
      "nvim-lua/plenary.nvim",
    },
    -- Configure
    config = function()
      vim.cmd([[set noshowmode]])
      require("lualine").setup({
        -- Define the global options for lualine
        options = {
          icons_enabled = true,
          theme = vitaminonec,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            winbar = { "aerial", "neo-tree", "snacks_terminal", "trouble", "toggleterm", "Outline" },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        -- Define how quickly the lualine must update
        refresh = {
          statusline = 200,
          tabline = 200,
          winbar = 200,
        },
        -- Bottom section of status line
        sections = {
          -- Bottom left display
          -- from left (far left corner) to right (middle): {a} {b} {c}
          lualine_a = { { "mode" } },
          lualine_b = { { "branch", icon = "󰘬" }, { "diff", source = diff_source, icon = "" } },
          lualine_c = {
            statusline_readonly,
            { "filename", icon = "󰓈 ", path = 0, file_status = false, symbols = { unnamed = "", newfile = "" } },
            { "selectioncount", icon = "󰉄" },
          },
          -- Bottom right display
          -- from left (middle) to right (far right corner): {x} {y} {z}
          lualine_x = {
            {
              "lsp_progress",
              icon = "",
              cond = function()
                return vim.tbl_count(vim.lsp.get_clients({ bufnr = 0 })) > 0
              end,
            },
          },
          lualine_y = {
            search_count,
            { "encoding", icon = "" },
            {
              "fileformat",
              symbols = {
                unix = "  LF",
                dos = "  CRLF",
                mac = "  CR",
              },
            },
            { "filesize", icon = "󰖡" },
          },
          lualine_z = { { "filetype", colored = false } },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
        },
        winbar = {
          lualine_b = {
            {
              "filename",
              path = 3,
              file_status = false,
              icon = "󰉋",
              shorting_target = 80,
              symbols = { unnamed = "", newfile = "" },
            },
            { "progress", icon = "󰮴" },
            { "location", icon = "" },
            {
              "aerial",
              colored = false,
              cond = function()
                return vim.fn.exists("*aerial#statusline") == 1 or package.loaded["aerial"] ~= nil
              end,
            },
          },
        },
        tabline = {
          -- Top left display
          -- from left (far left corner) to right (middle): {a} {b} {c}
          -- Note that {b} and {c} are currently disabled because there
          -- are normally a significant number of buffers on display in {a}
          lualine_a = {
            {
              "buffers",
              show_modified_status = true,
              -- Define a custom label for the Aerial buffer;
              -- note that other plugins seem to do this automatically
              -- but unless it is done for Aerial it will show a "No Name"
              -- label whenever you change into the Aerial buffer
              -- Also define a custom label for the snacks picker
              -- and for any other components that do not feature a
              -- default display inside of the tabline of lualine
              filetype_names = {
                aerial = "Aerial",
                codecompanion = "CodeCompanion",
                fugitive = "Fugitive",
                snacks_picker_input = "Picker",
                snacks_picker_list = "Explorer",
                snacks_terminal = "Terminal",
                sidekick_terminal = "Sidekick",
              },
              -- Define symbols attached to each file in the tabline
              symbols = {
                modified = " ●",
                alternate_file = " ",
                directory = "",
              },
            },
          },
          lualine_b = {},
          lualine_c = {},
          -- Top right display
          -- from left (middle) to right (far right corner): {x} {y} {z}
          lualine_x = {
            { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          },
          lualine_y = {
            statusline_python_env,
          },
          lualine_z = {
            function()
              return spell_status() .. " " .. lsp_clients()
            end,
          },
        },
        -- Define the extensions which ensure that lualine
        -- makes better customized menus when they are used
        extensions = { "quickfix", "aerial", "oil" },
      })
    end,
  },
}
