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
  -- (note could not get vim-matchup to work)
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

}
