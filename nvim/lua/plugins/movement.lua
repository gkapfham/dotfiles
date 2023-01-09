-- File: plugins/movement.lua
-- Purpose: load and configure movement plugins

return {

  -- Leap and flit
  {
    "ggandoj/leap.nvim",
    event = "VeryLazy",
    dependencies = { {"ggandor/flit.nvim", config = {
      multiline = true,
      eager_ops = true,
      keymaps = { f = 'f', F = 'F', t = 't', T = 'T' }
    } } },
    config = function()
      require("leap").add_default_mappings(true)
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

}
