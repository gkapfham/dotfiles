-- File: plugins/colorscheme.lua
-- Purpose: Configure the colorscheme and plugins that highlight colors
-- Note: A variant of the vitamin-onec colorscheme is re-created
-- by using onedarkpro as a base. Note that this color scheme is now
-- more vibrant than the original vitamin-onec colorscheme.

return {

  -- onedarkpro.nvim: onedark theme
  -- Customize the onedark_dark scheme
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
          fg = "#c1c1c1",
          -- red = "#d75f5f",
          red = "#d74f47",
          deepred = "#813939",
          orange = "#d78700",
          deeporange = "#af5f00",
          yellow = "#b7b757",
          green = "#6f9500",
          deepgreen = "#4c6c00",
          cyan = "#00afaf",
          blue = "#87afd7",
          -- purple = "#875f87",
          purple = "#a569a5",
          white = "#b2b2b2",
          black = "#767676",
          gray = "#6c6c6c",
          highlight = "#585858",
          comment = "#808080",
          float_bg = "#1c1c1c",
          darkmenu = "#303030",
          menu = "#262626",
          none = "NONE",
          magenta = "#d75f87",
        },
        -- defined by the standard version
        -- of this colorscheme; define first
        -- those that are standard and/or
        -- defined by a plugin and then
        -- define those for treesitter
        highlights = {
          -- standard highlights
          AvanteTitle = { fg = "${fg}", bg = "NONE" },
          AvanteThirdTitle = { fg = "${fg}", bg = "NONE" },
          AvanteReversedTitle = { fg = "${bg}", bg = "NONE" },
          AvanteReversedThirdTitle = { fg = "${bg}", bg = "NONE" },
          AvanteConflictCurrent = { bg = "${bg}" },
          AvanteConflictCurrentLabel = { fg = "${cyan}", bg = "${bg}" },
          AvanteConflictIncoming = { bg = "${bg}" },
          AvanteConflictIncomingLabel = { fg = "${orange}", bg = "${bg}" },
          Comment = { fg = "${comment}", bg = "NONE", italic = true },
          CursorLineNr = { fg = "${magenta}" },
          CmpItemKindCopilot = { fg = "${yellow}" },
          CmpItemKindEnum = { fg = "${orange}" },
          CmpItemKindLook = { fg = "${red}" },
          CmpItemKindSpell = { fg = "${red}", italic = true },
          CmpItemKindSupermaven = { fg = "${yellow}" },
          CmpItemKindTree = { fg = "${orange}" },
          CmpItemKindTreesitter = { fg = "${orange}" },
          CmpItemMenu = { fg = "${fg}", undercurl = false },
          DiagnosticUnderlineError = { fg = "${red}", undercurl = false },
          DiagnosticUnderlineWarn = { fg = "${orange}", undercurl = false },
          DiagnosticUnderlineInfo = { fg = "${yellow}", undercurl = false },
          DiagnosticUnderlineHint = { fg = "${cyan}", undercurl = false },
          DiffAdd = { fg = "${fg}", bg = "${darkmenu}" },
          DiffChange = { fg = "${blue}" },
          DiffDelete = { fg = "${red}" },
          DiffText = { fg = "${green}", bg = "${darkmenu}" },
          FloatBorder = { fg = "${highlight}", bg = "${bg}" },
          GitConflictCurrentLabel = { fg = "${fg}", bg = "${darkmenu}", bold = true },
          GitConflictIncomingLabel = { fg = "${fg}", bg = "${darkmenu}", bold = true },
          GitSignsAdd = { fg = "${green}" },
          GitSignsAddPreview = { fg = "${fg}", bg = "${deepgreen}" },
          GitSignsChange = { fg = "${blue}" },
          GitSignsChangeDelete = { fg = "${yellow}" },
          GitSignsDelete = { fg = "${red}" },
          GitSignsDeletePreview = { fg = "${fg}", bg = "${deepred}" },
          GitSignsUntracked = { fg = "${orange}" },
          IncSearch = { fg = "NONE", bg = "NONE", bold = true, undercurl = true },
          FlashCurrent = { fg = "${bg}", bg = "${purple}", bold = true, reverse = true },
          FlashLabel = { fg = "${bg}", bg = "${orange}", bold = true, reverse = true },
          LazyButton = { fg = "${fg}", bg = "${menu}", bold = true },
          LazyButtonActive = { fg = "${orange}", bg = "${menu}", bold = true },
          LazyNormal = { fg = "${fg}", bg = "${menu}" },
          LualineDiagnostics = { fg = "${orange}", bold = true },
          LineNr = { fg = "${gray}", bg = "${bg}" },
          LspLens = { fg = "${cyan}", italic = true },
          Pmenu = { fg = "${fg}", bg = "${menu}" },
          PmenuSbar = { fg = "${black}", bg = "${black}" },
          PmenuSel = { fg = "${fg}", bg = "${highlight}" },
          PmenuThumb = { fg = "${fg}", bg = "${menu}" },
          NonText = { fg = "${fg}" },
          NormalFloat = { fg = "${fg}", bg = "NONE" },
          Search = { fg = "NONE", bg = "NONE", undercurl = true, bold = true },
          CurSearch = { fg = "${orange}", bg = "NONE", undercurl = true, bold = true },
          RenderMarkdownCode = { bg = "${bg}" },
          RenderMarkdownCodeInline = { bg = "${bg}" },
          RenderMarkdownH1 = { fg = "${orange}" },
          RenderMarkdownH2 = { fg = "${green}" },
          RenderMarkdownH3 = { fg = "${purple}" },
          RenderMarkdownH4 = { fg = "${cyan}" },
          RenderMarkdownH1Bg = { bg = "${bg}" },
          RenderMarkdownH2Bg = { bg = "${bg}" },
          RenderMarkdownH3Bg = { bg = "${bg}" },
          RenderMarkdownH4Bg = { bg = "${bg}" },
          RenderMarkdownH5Bg = { bg = "${bg}" },
          RenderMarkdownH6Bg = { bg = "${bg}" },
          SnacksIndentScope = { fg = "${cyan}" },
          SnacksPicker = { bg = "${bg}" },
          SnacksPickerTree = { fg = "${gray}" },
          SymbolUsageRounding = { fg = "${menu}" },
          SymbolUsageContent = { fg = "${cyan}", italic = true },
          SymbolUsageRef = { fg = "${cyan}", italic = true },
          SymbolUsageDef = { fg = "${cyan}", italic = true },
          SymbolUsageImpl = { fg = "${cyan}", italic = true },
          Substitute = { fg = "NONE", bg = "NONE", bold = true, undercurl = true },
          ToggleTerm = { fg = "NONE", bg = "${bg}" },
          TomlKey = { fg = "${blue}" },
          Type = { fg = "${orange}", bg = "NONE" },
          TelescopeMatching = { fg = "${blue}", bg = "NONE" },
          TelescopePromptPrefix = { fg = "${blue}", bg = "NONE" },
          TelescopeSelection = { fg = "${yellow}", bg = "NONE" },
          TelescopeSelectionCaret = { fg = "${blue}", bg = "NONE" },
          -- treesitter highlights
          ["@attribute"] = { fg = "${purple}" },
          ["@odp.decorator.python"] = { fg = "${cyan}" },
          ["@comment.error"] = { fg = "${red}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.fix"] = { fg = "${yellow}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.note"] = { fg = "${cyan}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.todo"] = { fg = "${blue}", bg = "${bg}", bold = true, undercurl = true },
          ["@comment.warning"] = { fg = "${orange}", bg = "${bg}", bold = true, undercurl = true },
          ["@diff.plus"] = { fg = "${green}" },
          ["@diff.minus"] = { fg = "${red}" },
          ["@diff.change"] = { fg = "${blue}" },
          ["@keyword.conditional"] = { fg = "${cyan}" },
          ["@keyword.gitcommit"] = { fg = "${magenta}", bold = true, italic = true },
          ["@keyword.function.python"] = { fg = "${cyan}" },
          ["@keyword.return.python"] = { fg = "${cyan}" },
          ["@constructor"] = { fg = "${orange}" },
          ["@function"] = { fg = "${purple}", italic = true },
          ["@punctuation.special"] = { fg = "${orange}", italic = true },
          ["@markup.heading"] = { fg = "${orange}" },
          ["@markup.heading.1.markdown"] = { fg = "${orange}" },
          ["@markup.heading.2.markdown"] = { fg = "${green}" },
          ["@markup.heading.3.markdown"] = { fg = "${purple}" },
          ["@markup.heading.4.markdown"] = { fg = "${cyan}" },
          ["@markup.raw"] = { bg = "${bg}" },
          ["@markup.raw.markdown_inline"] = { fg = "${fg}", bold = true, undercurl = true },
          ["@string.yaml"] = { bg = "${bg}" },
          ["@string"] = { fg = "${yellow}", italic = false },
          ["@string.documentation.python"] = { fg = "${yellow}", italic = true },
          ["@variable"] = { fg = "${blue}" },
          ["@variable.member"] = { fg = "${blue}" },
          ["@variable.parameter"] = { fg = "${green}" },
          ["@odp.interpolation.python"] = { fg = "${green}" },
          ["@odp.punctuation.special.python"] = { fg = "${orange}" },
          ["@number.python"] = { fg = "${red}" },
          ["@property"] = { fg = "${blue}" },
          ["@label.markdown"] = { fg = "${cyan}", italic = true },
        }
      })
      -- select the color scheme and set the termguicolors
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
