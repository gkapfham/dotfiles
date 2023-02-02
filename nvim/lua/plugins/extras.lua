-- File: plugins/extras.lua
-- Purpose: load and configure extra plugins

return {

  -- MundoToggle
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
  },

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

  -- -- Sentencer
  -- {
  --   event = "VeryLazy",
  --   "whonore/vim-sentencer",
  -- },

  -- Align
  {
    "echasnovski/mini.align",
    keys = { "ga" },
    config = function()
      require("mini.align").setup()
    end,
  },

}
