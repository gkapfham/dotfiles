-- File: plugins/extras.lua
-- Purpose: load and configure extra plugins

return {

  -- -- MundoToggle
  -- {
  --   "simnalamburt/vim-mundo",
  --   cmd = "MundoToggle",
  -- },

  -- Surround
  {
    "echasnovski/mini.surround",
    keys = { "gz" },
    config = function()
      -- Use gz mappings instead of s to prevent conflict with leap
      require("mini.surround").setup({
        mappings = {
          add = "gza",
          delete = "gzd",
          find = "gzf",
          find_left = "gzF",
          highlight = "gzh",
          replace = "gzr",
          update_n_lines = "gzn",
        },
      })
    end,
  },

  -- Bracketed
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    config = function()
      require("mini.bracketed").setup({
        buffer     = { suffix = 'b', options = {} },
        comment    = { suffix = 'e', options = {} },
        conflict   = { suffix = 'x', options = {} },
        diagnostic = { suffix = 'd', options = {} },
        file       = { suffix = 'f', options = {} },
        indent     = { suffix = 'i', options = {} },
        jump       = { suffix = 'j', options = {} },
        location   = { suffix = 'l', options = {} },
        oldfile    = { suffix = 'o', options = {} },
        quickfix   = { suffix = 'q', options = {} },
        treesitter = { suffix = 't', options = {} },
        undo       = { suffix = 'u', options = {} },
        window     = { suffix = 'w', options = {} },
        yank       = { suffix = 'y', options = {} },
      }
      )
    end,
  },

  -- Align
  {
    "echasnovski/mini.align",
    keys = { "ga" },
    config = function()
      require("mini.align").setup()
    end,
  },

  -- Trailspace
  {
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    config = function()
      require("mini.trailspace").setup({
      }
      )
    end,
  },

}
