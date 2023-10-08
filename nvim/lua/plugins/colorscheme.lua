-- File: plugins/colorscheme.lua
-- Purpose: Configure the colorscheme

return {

  -- Define the color scheme and load it
  -- non-lazyily as it must function immediately
  {
    "gkapfham/vim-vitamin-onec",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme vitaminonec]])
      vim.cmd([[set termguicolors]])
    end,
  },

  -- Colorizer for highlighting colors
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      local comment = require("colorizer")
      comment.setup()
    end,
  },

  -- Color template creation
  {
    "lifepillar/vim-colortemplate",
    ft = "colortemplate",
  }

}
