-- File: interface.lua
-- Purpose: load and configure plugins that control the display

return {

  -- User interface enhancements
  {
    "stevearc/dressing.nvim",
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- Icons
  "nvim-tree/nvim-web-devicons",

  -- User interface components
  "MunifTanjim/nui.nvim",
}
