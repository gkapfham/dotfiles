-- File: interface.lua
-- Purpose: load and configure plugins that control the interface

return {

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "BufReadPre",
    keys = {
      {
        "<Space>dn",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    config = function()
      local customized_notify = require("notify")
      vim.notify = customized_notify
      customized_notify.setup({
        background_colour = "#1c1c1c",
        fps = 60,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade",
        timeout = 2000,
        top_down = true
      })
    end
  },

  -- User interface enhancements
  {
    "stevearc/dressing.nvim",
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- Icons
  "nvim-tree/nvim-web-devicons",

  -- User interface components
  "MunifTanjim/nui.nvim",

}
