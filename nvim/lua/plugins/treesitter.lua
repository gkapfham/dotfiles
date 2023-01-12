-- File: plugins/treesitter.lua
-- Purpose: load and configure the treesitter
-- that enables syntax highlighting and navigation

return {

  -- Textobjects
  {
    "kana/vim-textobj-user",
    dependencies = {
      "ColinKennedy/vim-textobj-block-party",
    },
    event = "VeryLazy",
    config = function()
      vim.g.python3_host_prog = '/home/gkapfham/.asdf/shims/python'
    end
  },

  -- Textobjects like backticks
  {
    "wellle/targets.vim",
    event = "VeryLazy"
  },

  -- Textobjects and motions for Python
  {
    "jeetsukumaran/vim-pythonsense",
    event = "VeryLazy"
  },

  -- Improve indentation that addresses
  -- the limitation of treesitter for Python
  {
    "yioneko/nvim-yati",
    event = "VeryLazy"
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup({
        sync_install = false,
        ensure_installed = {
          "bash",
          "bibtex",
          "c",
          "gitattributes",
          "gitignore",
          "go",
          "help",
          "html",
          "java",
          "javascript",
          "json",
          "latex",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        -- Highlighting
        highlight = { enable = true, disable = {"latex", "markdown"}, },
        -- Indenting
        indent = { enable = false, },
        -- Commenting
        context_commentstring = { enable = true, enable_autocmd = false },
        -- Alternate identing
        yati = {
          enable = true,
          default_lazy = true,
          default_fallback = "auto"
        },
      })
    end,
  },

}
