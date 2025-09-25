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
          "norg",
          "python",
          "query",
          "regex",
          "rust",
          "svelte",
          "scss",
          "tmux",
          "tsx",
          "typescript",
          "typst",
          "vim",
          "vue",
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
      -- make sure that quarto files use the markdown
      -- parser for treesitter (there is no parser for quarto);
      -- note that this is important to set because, without
      -- it, the preview feature in Snacks.nvim's pickers for
      -- .qmd files will not display syntax highlighting correctly
      vim.treesitter.language.register('markdown', 'quarto')
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
              -- to identify which nodes to use.
              -- Note that this only works for the
              -- treesitter objects already supported
              -- by this package; otherwise, you must
              -- define new treesitter queries
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@conditional.outer",
              ["ic"] = "@conditional.inner",
              ["am"] = "@comment.outer",
              ["im"] = "@comment.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["as"] = "@statement.outer",
            },
          },
        },
      }
    end,
  },


  {
    "monkoose/matchparen.nvim",
    event = "VeryLazy",
    config = function()
      require('matchparen').setup({
          -- Set to `false` to disable at matchpren at startup
          -- Enable matchparen manually with `:MatchParenEnable`
          enabled = true,
          -- Highlight group of the matched brackets
          -- Change it to any other or adjust colors of "MathParen" highlight group
          -- in your colorscheme to your liking
          hl_group = 'MatchParen',
          -- Debounce time in milliseconds for rehighlighting brackets
          -- Set to 0 to disable debouncing
          debounce_time = 60,
      })
    end
  },

  -- targets.vim
  -- provides additional text objects
  -- not already supported by the capture
  -- groups for nvim-treesitter-textobjects
  -- (e.g., * and ** in Quarto or Markdown)
  {
    "wellle/targets.vim",
    event = "VeryLazy",
  },

}
