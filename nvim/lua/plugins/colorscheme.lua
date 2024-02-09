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
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        colors = {
          bg = "#1c1c1c",
          fg = "#a8a8a8",
          red = "#d75f5f",
          orange = "#d78700",
          yellow = "#afaf5f",
          green = "#5f8700",
          cyan = "#00afaf",
          blue = "#87afd7",
          purple = "#875f87",
          white = "#a8a8a8",
          black = "#767676",
          gray = "#6c6c6c",
          highlight = "#585858",
          comment = "#808080",
          float_bg = "#1c1c1c",
          menu = "#303030",
          none = "NONE",
        },
        highlights = {
          Comment = { fg = "${comment}", bg = "${bg}", italic = true },
          DiagnosticUnderlineError = { fg = "${red}", undercurl = false },
          DiagnosticUnderlineWarn = { fg = "${orange}", undercurl = false },
          DiagnosticUnderlineInfo = { fg = "${yellow}", undercurl = false },
          DiagnosticUnderlineHint = { fg = "${cyan}", undercurl = false },
          DiffAdd = { fg = "${green}" },
          DiffChange = { fg = "${blue}" },
          DiffDelete = { fg = "${red}" },
          DiffText = { fg = "${green}" },
          IncSearch = { fg = "NONE", bg = "NONE", bold = true, undercurl = true },
          FlashLabel = { fg = "${bg}", bg = "${orange}", bold = true, reverse = true },
          Pmenu = { fg = "${fg}", bg = "${menu}" },
          PmenuSbar = { fg = "${black}", bg = "${black}" },
          PmenuSel = { fg = "${fg}", bg = "${highlight}" },
          PmenuThumb = { fg = "${fg}", bg = "${menu}" },
          NormalFloat = { fg = "${fg}", bg = "${menu}" },
          Search = { fg = "NONE", bg = "NONE", undercurl = true, bold = true },
          Type = { fg = "${orange}", bg = "${bg}"  },
          TelescopeSelectionCaret = { fg = "${blue}", bg = "NONE" },
          TelescopeMatching = { fg = "${blue}", bg = "NONE" },
          TelescopeSelection = { fg = "${yellow}", bg = "NONE" },
          ["@function"] = { fg = "${green}", bg = "${bg}", italic = true },
          ["@string"] = { fg = "${yellow}", bg = "${bg}", italic = false },
          ["@variable"] = { fg = "${blue}" },
          ["@variable.member"] = { fg = "${blue}" },
          ["@property"] = { fg = "${blue}" },


          -- TelescopeBorder white none
          -- TelescopePromptBorder white none
          -- TelescopeResultsBorder white none
          -- TelescopePreviewBorder white none
          -- TelescopeMatching blue none
          -- TelescopeSelectionCaret blue none
          -- TelescopeSelection yellow none
          -- TelescopeMultiSelection brightyellow none bold



        }
      })
      vim.cmd([[colorscheme onedark_dark]])
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

  -- -- vim-colortemplate
  -- -- Color template creation
  -- {
  --   "lifepillar/vim-colortemplate",
  --   ft = "colortemplate",
  -- }

}
