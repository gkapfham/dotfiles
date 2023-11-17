-- File: plugins/movement.lua
-- Purpose: load and configure movement plugins

return {

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      highlight = {
        backdrop = false,
      },
      prompt = {
        enabled = false,
      },
      modes = {
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
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- which-key.nvim: Display diagnostic information about different keymaps,
  -- including information about the clipboard and spelling
  {
    "folke/which-key.nvim",
    enable = false,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      triggers = {"z"},
      triggers_nowait = {
        -- spelling
        "z=",
      },
    }
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

  -- Pair movement and highlighting
  -- (note could not get vim-matchup to work;
  -- it crashes when using % and gives errors
  -- suggesting a problem with treesitter integration)
  {
    "theHamsta/nvim-treesitter-pairs",
    event = "VeryLazy",
    config = function()
      require'nvim-treesitter.configs'.setup {
        pairs = {
          enable = true,
          disable = {},
          highlight_pair_events = {"CursorMoved"},
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

  -- Marks
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = function()
      require'marks'.setup {
        default_mappings = false,
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 150,
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        -- define mappings that are different than the default
        mappings = {
          next = "]a",
          prev = "[a",
          -- Note that "delete" requires next
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

  -- -- Spider for improved word movement
  -- {
  --   "chrisgrieser/nvim-spider",
  --   event = "VeryLazy",
  --   config = function()
  --     require("spider").setup({
  --       skipInsignificantPunctuation = true
  --     })
  --     vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
  --     vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
  --     vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
  --     vim.keymap.set({"n", "o", "x"}, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
  --   end,
  -- },

}
