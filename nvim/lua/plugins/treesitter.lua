-- File: plugins/treesitter.lua
-- Purpose: load and configure the treesitter
-- that enables syntax highlighting and navigation

return {

  -- nvim-treesitter
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
      -- that all plugins that use the deprecated one do not
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
          "comment",
          "css",
          "csv",
          "diff",
          "gitattributes",
          "git_config",
          "gitcommit",
          "gitignore",
          "go",
          "html",
          "java",
          "javascript",
          "json",
          "json5",
          "latex",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "mermaid",
          "nix",
          "python",
          "query",
          "regex",
          "rust",
          "scss",
          "tmux",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        -- highlighting
        highlight = { enable = true, },
        -- indenting
        indent = { enable = true, },
        -- commenting
        context_commentstring = { enable = true, enable_autocmd = false },
        require "nvim-treesitter.configs".setup {
          playground = {
            enable = true,
            disable = {},
            updatetime = 25,
            persist_queries = false,
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
      vim.cmd [[
        autocmd VimEnter * TSEnable highlight
      ]]
    end,
  },

  -- sentiment.nvim
  {
    "utilyre/sentiment.nvim",
    event = "VeryLazy",
    opts = {
      pairs = {
        { "(", ")" },
        { "{", "}" },
        { "[", "]" },
      },
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },

  -- nvim-treesitter-textobjects
  -- supports definition of custom
  -- objects and motions defined
  -- on what is available in treesitter
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              -- define operators based on
              -- treesitter nodes; note that
              -- block is useful for fenced code
              -- blocks. Use :Inspect or :InspectTree
              -- to identify which nodes to use
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
            },
          },
        },
      }
    end,
  },

}
