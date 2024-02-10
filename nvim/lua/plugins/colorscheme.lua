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

  -- customize the onedark_dark scheme
  -- so that it looks like vim-vitamin-onec;
  -- note that vim-vitamin-onec is not used
  -- because of the fact that it does not
  -- integrate well with new versions of treesitter.
  -- Define the color scheme and load it
  -- non-lazyily as it must function immediately
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        -- override the default colors
        colors = {
          bg = "#1c1c1c",
          fg = "#a8a8a8",
          red = "#d75f5f",
          orange = "#d78700",
          deeporange = "#af5f00",
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
        -- override the default highlights
        highlights = {
          -- standard highlights
          Comment = { fg = "${comment}", bg = "${bg}", italic = true },
          CmpItemKindCopilot = { fg = "${yellow}" },
          CmpItemMenu = { fg = "${fg}", undercurl = false },
          DiagnosticUnderlineError = { fg = "${red}", undercurl = false },
          DiagnosticUnderlineWarn = { fg = "${orange}", undercurl = false },
          DiagnosticUnderlineInfo = { fg = "${yellow}", undercurl = false },
          DiagnosticUnderlineHint = { fg = "${cyan}", undercurl = false },
          DiffAdd = { fg = "${green}" },
          DiffChange = { fg = "${blue}" },
          DiffDelete = { fg = "${red}" },
          DiffText = { fg = "${green}" },
          GitSignsAdd = { fg = "${green}" },
          GitSignsChange = { fg = "${blue}" },
          GitSignsDelete = { fg = "${red}" },
          GitSignsUntracked = { fg = "${orange}" },
          IncSearch = { fg = "NONE", bg = "NONE", bold = true, undercurl = true },
          FlashCurrent = { fg = "${bg}", bg = "${purple}", bold = true, reverse = true },
          FlashLabel = { fg = "${bg}", bg = "${orange}", bold = true, reverse = true },
          LineNr = { fg = "${gray}", bg = "${bg}" },
          Pmenu = { fg = "${fg}", bg = "${menu}" },
          PmenuSbar = { fg = "${black}", bg = "${black}" },
          PmenuSel = { fg = "${fg}", bg = "${highlight}" },
          PmenuThumb = { fg = "${fg}", bg = "${menu}" },
          NormalFloat = { fg = "${fg}", bg = "${menu}" },
          Search = { fg = "NONE", bg = "NONE", undercurl = true, bold = true },
          SymbolUsageRounding = { fg = "${menu}", bg = "${bg}" },
          SymbolUsageContent = { fg = "${deeporange}", bg = "${menu}", italic = true },
          SymbolUsageRef = { fg = "${deeporange}", bg = "${menu}", italic = true },
          SymbolUsageDef = { fg = "${deeporange}", bg = "${menu}", italic = true },
          SymbolUsageImpl = { fg = "${deeporange}", bg = "${menu}", italic = true },
          Type = { fg = "${orange}", bg = "${bg}" },
          TelescopeSelectionCaret = { fg = "${blue}", bg = "NONE" },
          TelescopeMatching = { fg = "${blue}", bg = "NONE" },
          TelescopeSelection = { fg = "${yellow}", bg = "NONE" },
          -- treesitter highlights
          ["@comment.error"] = { fg = "${red}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.fix"] = { fg = "${yellow}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.note"] = { fg = "${cyan}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.todo"] = { fg = "${blue}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.warning"] = { fg = "${orange}", bg = "${bg}", bold = true, undercurl = true },
          ["@function"] = { fg = "${green}", bg = "${bg}", italic = true },
          ["@string"] = { fg = "${yellow}", bg = "${bg}", italic = false },
          ["@variable"] = { fg = "${blue}" },
          ["@variable.member"] = { fg = "${blue}" },
          ["@property"] = { fg = "${blue}" },
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

}
