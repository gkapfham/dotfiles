-- File: plugins/aerial.lua
-- Purpose: Configure the aerial plugin
-- (and similar types of plugins)
-- for creation of various sidebars
-- Note: none of these plugins work reliably for
-- every type of filetype (especially for Markdown)

return {

  -- outline.nvim plugin
  -- A navigation sidebar
  -- for document symbols
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<Space>9", "<cmd>Outline<CR>", desc = "Outline: Toggle visibility" },
    },
    opts = {
      providers = {
        priority = { "markdown", "lsp", "coc", "norg" },
        markdown = {
          filetypes = { "markdown", "quarto" },
        },
      },
      outline_items = {
        show_symbol_details = false,
      },
      outline_window = {
        width = 22,
        relative_width = true,
      },
      symbol_folding = {
        autofold_depth = false,
        auto_unfold = {
          hovered = true,
          only = true,
        },
        markers = { '', '' },
      },
      symbols = {
        filter = nil,
        icon_fetcher = nil,
        icon_source = nil,
        icons = {
          File = { icon = '󰈙"', hl = 'Identifier' },
          Module = { icon = '󰆧', hl = 'Include' },
          Namespace = { icon = '󰅪', hl = 'Include' },
          Package = { icon = '󰏗', hl = 'Include' },
          Class = { icon = '󰠱', hl = 'Type' },
          Method = { icon = 'ƒ', hl = 'Function' },
          Property = { icon = '󰜢', hl = 'Identifier' },
          Field = { icon = '󰆨', hl = 'Identifier' },
          Constructor = { icon = '', hl = 'Special' },
          Enum = { icon = '', hl = 'Type' },
          Interface = { icon = '', hl = 'Type' },
          Function = { icon = '󰊕', hl = 'Function' },
          Variable = { icon = '󰀫', hl = 'Constant' },
          Constant = { icon = '', hl = 'Constant' },
          String = { icon = '', hl = 'String' },
          Number = { icon = '#', hl = 'Number' },
          Boolean = { icon = '', hl = 'Boolean' },
          Array = { icon = '󰅪', hl = 'Constant' },
          Object = { icon = '⦿', hl = 'Type' },
          Key = { icon = '󰌋', hl = 'Type' },
          Null = { icon = '', hl = 'Type' },
          EnumMember = { icon = '', hl = 'Identifier' },
          Struct = { icon = '󰌋', hl = 'Structure' },
          Event = { icon = '󰚰', hl = 'Type' },
          Operator = { icon = '󰆕', hl = 'Identifier' },
          TypeParameter = { icon = '𝙏', hl = 'Identifier' },
          Component = { icon = '󰅴', hl = 'Function' },
          Fragment = { icon = '󰅴', hl = 'Constant' },
          TypeAlias = { icon = ' ', hl = 'Type' },
          Parameter = { icon = ' ', hl = 'Identifier' },
          StaticMethod = { icon = ' ', hl = 'Function' },
          Macro = { icon = '󰍍', hl = 'Function' },
        },
      },
    },
  },

  -- aerial.nvim plugin
  -- A navigation sidebar
  -- that integrates with one of
  -- the pickers provided by snacks.nvim
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    config = function()
      require("aerial").setup({
        backends = { "treesitter", "lsp", "markdown" },
        attach_mode = "window",
        default_bindings = true,
        disable_max_lines = 10000,
        disable_max_size = 2000000,
        filter_kind = {
          "Array",
          "Class",
          "Constant",
          "Constructor",
          "Enum",
          "EnumMember",
          "File",
          "Field",
          "Function",
          "Interface",
          "Key",
          "Method",
          "Module",
          "Namespace",
          "Object",
          "Operator",
          "Package",
          "Property",
          "Struct",
          "TypeParameter",
          "Variable",
        },
        highlight_mode = "full_width",
        highlight_closest = true,
        highlight_on_hover = true,
        highlight_on_jump = 300,
        icons = {},
        ignore = {
          unlisted_buffers = true,
          filetypes = {},
          buftypes = "special",
          wintypes = "special",
        },
        layout = {
          default_direction = "right",
          max_width = { 40, 0.2 },
          min_width = { 04, 0.2 },
        },
        link_folds_to_tree = false,
        link_tree_to_folds = true,
        manage_folds = false,
        width = nil,
        nerd_font = "auto",
        on_first_symbols = nil,
        open_automatic = false,
        placement = "window",
        close_automatic_events = { "unsupported" },
        post_jump_cmd = "normal! zz",
        close_on_select = false,
        show_guides = true,
        update_events = "TextChanged,InsertLeave",
        guides = {
          mid_item = "├─",
          last_item = "└─",
          nested_top = "│ ",
          whitespace = "  ",
        },
        lsp = {
          diagnostics_trigger_update = true,
          update_when_errors = true,
          update_delay = 300,
        },
        treesitter = {
          update_delay = 300,
        },
        markdown = {
          update_delay = 300,
        },
      })
    end,
    -- Keys
    keys = {
      -- Toggle display of aerial
      { "<Space>a", "<cmd> AerialToggle <CR>", desc = "Aerial: Toggle visibility" },
    }
  },

}
