-- File: plugins/quickfix.lua
-- Purpose: load and configure quickfix plugin

return {

  -- Qf
  {
    "ten3roberts/qf.nvim",
    event = "BufReadPost",
    config = function()
      require 'qf'.setup {
        -- Location list configuration
        l = {
          auto_close = true,
          auto_follow = 'prev',
          auto_follow_limit = 8,
          follow_slow = true,
          auto_open = true,
          auto_resize = false,
          max_height = 10,
          min_height = 10,
          wide = true,
          number = false,
          relativenumber = false,
          unfocus_close = false,
          focus_open = false,
        },
        -- Quickfix list configuration
        c = {
          auto_close = true,
          auto_follow = 'prev',
          auto_follow_limit = 8,
          follow_slow = false,
          auto_open = true,
          auto_resize = false,
          max_height = 10,
          min_height = 10,
          wide = true,
          number = false,
          relativenumber = false,
          unfocus_close = false,
          focus_open = false,
        },
        close_other = false,
        pretty = true,
      }
    end,
    -- Keys
    keys = {
      -- Toggle
      { "<Space>qf", "<cmd> lua require'qf'.toggle('c', true) <CR>", desc = "Quick Fix: Toggle quickfix list" },
      { "<leader>qf", "<cmd> lua require'qf'.toggle('c', true) <CR>", desc = "Quick Fix: Toggle quickfix list" },
    }
  },

}
