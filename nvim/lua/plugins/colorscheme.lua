-- File: plugin/colorscheme.lua
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

  -- Color template creation
  {
    "lifepillar/vim-colortemplate",
    ft = "colortemplate",
  }

}
