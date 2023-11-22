-- File: plugins/colorscheme.lua
-- Purpose: Configure the colorscheme and plugins that highlight colors

return {

  -- vim-vitamin-onec
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

  -- nvim-colorizer.lua
  -- Colorizer for highlighting colors
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      local comment = require("colorizer")
      comment.setup(
        {
          filetypes = { "*" },
          user_default_options = {
            RGB = true,
            RRGGBB = true,
            names = true,
            RRGGBBAA = false,
            AARRGGBB = false,
            rgb_fn = false,
            hsl_fn = false,
            css = false,
            css_fn = false,
            mode = "virtualtext",
            tailwind = false,
            sass = { enable = false, parsers = { "css" }, },
            virtualtext = "■",
            always_update = false
          },
          -- all the sub-options of filetypes apply to buftypes
          buftypes = {},
        }
      )
    end,
  },

  -- vim-colortemplate
  -- Color template creation
  {
    "lifepillar/vim-colortemplate",
    ft = "colortemplate",
  }

}
