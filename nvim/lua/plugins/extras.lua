-- File: plugins/extras.lua
-- Purpose: load and configure extra plugins

return {

  -- Devdocs
  {
    "luckasRanarison/nvim-devdocs",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      previewer_cmd = "rich",
      cmd_args = { "-", "--markdown", "--force-terminal"}
    },
    -- Keys
    keys = {
      {
        "<Leader>dd",
        "<cmd> DevdocsOpen<CR>",
        desc =
          "DevDocs: Open DevDocs in Telescope"
      },
    },
  },

  -- Undotree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  -- -- mail?
  -- {
  --   "https://git.sr.ht/~soywod/himalaya-vim",
  --   cmd = "Himalaya",
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
