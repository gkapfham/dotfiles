-- File: plugins/extras.lua
-- Purpose: load and configure extra plugins

return {

  -- undotree
  -- Create a tree of undo branches
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  -- mini.surround
  -- surround management
  {
    "echasnovski/mini.surround",
    keys = { "gz" },
    config = function()
      -- Use gz mappings instead of s to prevent conflict with flash.nvim
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

  -- mini.align
  -- Align management
  {
    "echasnovski/mini.align",
    keys = { "ga" },
    config = function()
      require("mini.align").setup()
    end,
  },

  -- mini.trailspace
  -- Trailing space management
  {
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    config = function()
      require("mini.trailspace").setup({})
    end,
  },

}
