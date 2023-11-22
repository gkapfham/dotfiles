-- File: plugins/aerial.lua
-- Purpose: Configure the aerial plugin
-- for creation of a navigation sidebar
-- Note: this plugin also has a telescope integration

return {

  -- aerial.nvim plugin
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
      { "<Space>-", "<cmd> AerialToggle <CR>", desc = "Aerial: Toggle visibility" },
    }
  },

}
