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

  -- Tree-climber
  {
    "drybalka/tree-climber.nvim",
    event = "VeryLazy",
    config = function()
      local keyopts = { noremap = true, silent = true }
      vim.keymap.set({'n', 'v', 'o'}, '<c-h>', require('tree-climber').goto_parent, keyopts)
      vim.keymap.set({'n', 'v', 'o'}, '<c-l>', require('tree-climber').goto_child, keyopts)
      vim.keymap.set({'n', 'v', 'o'}, '<c-j>', require('tree-climber').goto_next, keyopts)
      vim.keymap.set({'n', 'v', 'o'}, '<c-k>', require('tree-climber').goto_prev, keyopts)
      vim.keymap.set({'v', 'o'}, 'in', require('tree-climber').select_node, keyopts)
      -- vim.keymap.set('n', '<c-k>', require('tree-climber').swap_prev, keyopts)
      -- vim.keymap.set('n', '<c-j>', require('tree-climber').swap_next, keyopts)
      -- vim.keymap.set('n', '<c-h>', require('tree-climber').highlight_node, keyopts)
    end
  },

  -- -- Improve indentation that addresses
  -- -- the limitation of treesitter for Python
  -- {
  --   "yioneko/nvim-yati",
  --   event = "VeryLazy"
  -- },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/playground",
    },
    config = function()
      -- rewrite deprecated function to the new function so
      -- that all plugins who use the deprecated one do not
      -- produce the warning message about using wrong one
      local ts_utils = require("nvim-treesitter.ts_utils")
      ts_utils.is_in_node_range = vim.treesitter.is_in_node_range
      -- setup the treesitter and install it for all needed languages
      require("nvim-treesitter.configs").setup({
        sync_install = false,
        ensure_installed = {
          "bash",
          "bibtex",
          "c",
          "gitattributes",
          "gitignore",
          "go",
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
        highlight = { enable = true, disable = {"html", "latex"}, },
        -- Indenting
        indent = { enable = true, },
        -- Commenting
        context_commentstring = { enable = true, enable_autocmd = false },
        -- Alternate identing
        -- yati = {
        --   enable = true,
        --   default_lazy = true,
        --   default_fallback = "auto"
        -- },
        require "nvim-treesitter.configs".setup {
          playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = 'o',
              toggle_hl_groups = 'i',
              toggle_injected_languages = 't',
              toggle_anonymous_nodes = 'a',
              toggle_language_display = 'I',
              focus_language = 'f',
              unfocus_language = 'F',
              update = 'R',
              goto_node = '<cr>',
              show_help = '?',
            },
          }
        },
      })
    end,
  },

}
