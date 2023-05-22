-- File: plugins/interface.lua
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
        fps = 30,
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
        stages = "fade_in_slide_out",
        timeout = 1000,
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

  -- Automatically disable search highlighting when
  -- it is not needed after performing a search
  {
    "asiryk/auto-hlsearch.nvim",
    event = "BufReadPre",
    config = function()
      local auto_hlsearch = require("auto-hlsearch")
      auto_hlsearch.setup()
    end,
  },

  -- Make it easy to load a web site in a browser after
  -- typing gx inside of Neovim, all without using netrw
  {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("gx").setup {
      open_browser_app = "xdg-open",
      handlers = {
        plugin = true,
        github = true,
        package_json = true,
        search = true,
      },
      handler_options = {
        search_engine = "google",
      },
      vim.api.nvim_set_keymap('n', '<Space>gb', 'gx', {noremap=false})
    } end,
  },

  -- Icons
  "nvim-tree/nvim-web-devicons",

  -- User interface components
  "MunifTanjim/nui.nvim",

}
