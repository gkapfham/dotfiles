-- File: plugins/colorscheme.lua
-- Purpose: Configure the colorscheme and plugins that highlight colors

return {

  -- mini.trailspace
  -- Trailing space management
  {
    "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
  },

  -- vim-vitamin-onec
  -- Define the color scheme and load it
  -- non-lazyily as it must function immediately
  {
    -- "gkapfham/vim-vitamin-onec",
    "olimorris/onedarkpro.nvim",
    -- dir = "/home/gkapfham/working/source/lush-vitamin-onec",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        colors = {
          dark = { bg = "#1C1C1C" },
          bg = "#000000",
          fg = "#abb2bf",
          red = "#ef596f",
          orange = "#d19a66",
          yellow = "#e5c07b",
          green = "#89ca78",
          cyan = "#2bbac5",
          blue = "#61afef",
          purple = "#d55fde",
          white = "#abb2bf",
          black = "#000000",
          gray = "#434852",
          highlight = "#e2be7d",
          comment = "#7f848e",
          none = "NONE",
        }
      })
      -- vim.cmd([[colorscheme vitaminonec]])
      -- vim.cmd([[colorscheme lush-vitamin-onec]])


      vim.cmd([[colorscheme onedark_dark]])
      vim.cmd([[set termguicolors]])


    end,
  },

  -- -- vim-vitamin-onec
  -- -- Define the color scheme and load it
  -- -- non-lazyily as it must function immediately
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("tokyonight").setup({
  --       style = "night",
  --       transparent = false,
  --       terminal_colors = true,
  --       styles = {
  --         comments = { italic = true },
  --         keywords = { italic = true },
  --         functions = {},
  --         variables = {},
  --         sidebars = "dark",
  --         floats = "normal",
  --       },
  --       sidebars = { "qf", "help" },
  --       hide_inactive_statusline = true,
  --       dim_inactive = false,
  --       lualine_bold = true,
  --       -- on_colors = function(colors)
  --       -- end,
  --       on_highlights = function(highlights, colors)
  --         colors.bg = "#1c1c1c"
  --         colors.fg = "#8a8a8a"
  --         colors.orange = "#d78700"
  --         highlights.String = { fg = "#afaf5f", }
  --       end,
  --     })
  --     vim.cmd([[colorscheme tokyonight]])
  --     vim.cmd([[set termguicolors]])
  --   end,
  -- },

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

  -- -- vim-colortemplate
  -- -- Color template creation
  -- {
  --   "lifepillar/vim-colortemplate",
  --   ft = "colortemplate",
  -- }

}
