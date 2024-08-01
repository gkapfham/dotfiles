-- File: plugins/movement.lua
-- Purpose: load and configure movement plugins

return {

  -- flash.nvim
  -- movements based on marking letters through both motions and search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      jump = {
        continue = false,
        history = true,
        register = true,
        nohlsearch = true,
      },
      label = {
        style = "eol"
      },
      highlight = {
        backdrop = false,
      },
      prompt = {
        enabled = false,
      },
      modes = {
        treesitter = {
          highlight = {
            backdrop = false,
          },
          label = { before = true, after = true, style = "eol" },
        },
        search = {
          enabled = true,
        },
        char = {
          highlight = {
            backdrop = false,
          },
          jump_labels = false
        }
      }
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- mini.bracketed
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

  -- nvim-treesitter-pairs
  -- Pair movement and highlighting
  -- (note could not get vim-matchup to work;
  -- it crashes when using % and gives errors
  -- suggesting a problem with treesitter integration)
  {
    "theHamsta/nvim-treesitter-pairs",
    event = "VeryLazy",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        pairs = {
          enable = true,
          disable = {},
          highlight_pair_events = { "CursorMoved" },
          highlight_self = false,
          goto_right_end = false,
          fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
          keymaps = {
            goto_partner = "<leader>%",
            delete_balanced = "X",
          },
          delete_balanced = {
            only_on_first_char = false,
            fallback_cmd_normal = nil,
            longest_partner = true,
          }
        }
      }
    end,
  },

  -- marks.nvim
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = function()
      require 'marks'.setup {
        default_mappings = false,
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 150,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        -- define mappings that are different than the default
        mappings = {
          next = "]a",
          prev = "[a",
          -- note that "delete" requires next
          -- that you give the actual mark;
          -- this means that "dma" would
          -- delete the mark called "a"
          delete = "dm",
          delete_line = "dm-",
          delete_buf = "dm<space>",
          preview = "m;",
        }
      }
    end,
  },

}
