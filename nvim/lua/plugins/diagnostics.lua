-- File: plugins/diagnostics.lua
-- Purpose: Load and configure plugins for diagnostic purposes

return {

  -- vim-startuptime
  -- Measure the startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- plenary.nvim
  -- Provide user interface support
  -- for other neovim plugins
  "nvim-lua/plenary.nvim",

  -- diagflow.nvim
  -- Display LSP diagnostics with borders at top-right
  -- Provides a toggleable, distraction-free diagnostic display
  {
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    config = function()
      require("diagflow").setup({
        -- Enable by default (use boolean, not function)
        enable = true,
        -- Maximum dimensions for the diagnostic window
        max_width = 60,
        max_height = 20,
        -- Severity highlight groups
        severity_colors = {
          error = "DiagnosticFloatingError",
          warning = "DiagnosticFloatingWarn",
          info = "DiagnosticFloatingInfo",
          hint = "DiagnosticFloatingHint",
        },
        -- Format diagnostic message
        format = function(diagnostic)
          return diagnostic.message
        end,
        -- Spacing and positioning
        gap_size = 1,
        scope = "line", -- Changed to 'line' to show all diagnostics on current line
        padding_top = 0,
        padding_right = 1,
        text_align = "right",
        placement = "top", -- Show at top-right of screen
        -- Events that trigger diagnostic display
        update_event = { "DiagnosticChanged", "BufReadPost" },
        render_event = { "CursorMoved", "DiagnosticChanged", "WinResized" },
        -- Events that trigger toggling; note that both
        -- are needed to ensure diagnostics are hidden during insert mode
        -- and then shown again when leaving insert mode
        toggle_event = { "InsertEnter", "InsertLeave" },
        -- Show diagnostic sign before message
        show_sign = true,
        -- Enable borders for boxed appearance
        show_borders = true,
        -- Border characters - using rounded corners to match completion menu
        border_chars = {
          top_left = "╭",
          top_right = "╮",
          bottom_left = "╰",
          bottom_right = "╯",
          horizontal = "─",
          vertical = "│",
        },
      })
    end,
    keys = {
      {
        "<Space>sv",
        function()
          -- Use the built-in toggle function
          require("diagflow").toggle()
          -- Notify user
          local enabled = require("diagflow").config.enable
          if enabled then
            vim.notify("Diagnostics: Enabled", vim.log.levels.INFO)
          else
            vim.notify("Diagnostics: Disabled", vim.log.levels.INFO)
          end
        end,
        desc = "Diagnostics: Toggle diagnostic display",
      },
    },
  },
}
