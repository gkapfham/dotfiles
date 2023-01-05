-- File: diagnostics.lua
-- Purpose: load and configure plugins for diagnostic purposes

return {

  -- measure the startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- library used by other plugins
  "nvim-lua/plenary.nvim",

}
