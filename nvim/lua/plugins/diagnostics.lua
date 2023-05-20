-- File: plugins/diagnostics.lua
-- Purpose: load and configure plugins for diagnostic purposes

return {

  -- Measure the startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Provide user interface support
  -- for other neovim plugins
  "nvim-lua/plenary.nvim",

}
