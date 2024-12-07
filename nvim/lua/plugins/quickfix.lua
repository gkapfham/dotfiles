-- File: plugins/quickfix.lua
-- Purpose: load and configure quickfix plugin

return {

  -- trouble.nvim
  -- Improve preview of diagnostics and
  -- the quickfix and locations lists
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<Space>td",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Trouble: Buffer Diagnostics",
      },
      {
        "<Space>tD",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Trouble: Diagnostics",
      },
      {
        "<Space>to",
        "<cmd>Trouble symbols toggle focus=false pinned=true win.relative=win win.position=bottom<cr>",
        desc = "Trouble: Symbols",
      },
      {
        "<Space>ql",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Trouble: Location List",
      },
      {
        "<Space>qf",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Trouble: Quickfix List",
      },
    },
  }

  -- -- qf.nvim
  -- -- Enhance the quickfix window; especially useful after
  -- -- using telescope to populate the quickfix list with all
  -- -- of the diagnostics that need to be resolved
  -- {
  --   "ten3roberts/qf.nvim",
  --   event = "BufReadPost",
  --   config = function()
  --     require 'qf'.setup {
  --       -- location list configuration
  --       l = {
  --         auto_close = true,
  --         auto_follow = 'prev',
  --         auto_follow_limit = 8,
  --         follow_slow = true,
  --         auto_open = true,
  --         auto_resize = false,
  --         max_height = 10,
  --         min_height = 10,
  --         wide = true,
  --         number = false,
  --         relativenumber = false,
  --         unfocus_close = false,
  --         focus_open = false,
  --       },
  --       -- quickfix list configuration
  --       c = {
  --         auto_close = true,
  --         auto_follow = 'prev',
  --         auto_follow_limit = 8,
  --         follow_slow = false,
  --         auto_open = true,
  --         auto_resize = false,
  --         max_height = 10,
  --         min_height = 10,
  --         wide = true,
  --         number = false,
  --         relativenumber = false,
  --         unfocus_close = false,
  --         focus_open = false,
  --       },
  --       close_other = false,
  --       pretty = true,
  --     }
  --   end,
  --   -- Keys
  --   keys = {
  --     -- Toggle
  --     { "<Space>qf", "<cmd> lua require'qf'.toggle('c', true) <CR>", desc = "Quick Fix: Toggle quickfix list" },
  --     { "<leader>qf", "<cmd> lua require'qf'.toggle('c', true) <CR>", desc = "Quick Fix: Toggle quickfix list" },
  --   }
  -- },

}
