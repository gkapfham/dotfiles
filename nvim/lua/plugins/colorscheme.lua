-- File: plugin/colorscheme.lua
-- Purpose: Configure the colorscheme

return {

  -- define the color scheme and load it
  -- in a non-lazy fashion as needed immediately
  {
    "gkapfham/vim-vitamin-onec",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme vitaminonec]])
      vim.cmd([[set termguicolors]])
    end,
  },

}
