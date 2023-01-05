-- File: indentation.lua
-- Purpose: load and configure plugins for indentation

return {

  -- User interface enhancements
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPre",
    config = function()
      require('guess-indent').setup {}
    end,
  },

}
