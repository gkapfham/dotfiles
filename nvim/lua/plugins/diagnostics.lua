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

}
