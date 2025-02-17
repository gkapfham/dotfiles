-- File: plugins/interface.lua
-- Purpose: load and configure plugins that control the interface

return {

  -- which-key.nvim
  -- Interactively and incrementally discover key mappings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 200,
      notify = true,
      preset = "helix",
      win = {
        border = "rounded",
        padding = { 1, 1 },
        wo = {
          winblend = 0,
        },
      },
      layout = {
        width = { min = 25 },
        spacing = 3,
        align = "left",
      },
      triggers = {
        { "<auto>", mode = "nixsotc" },
      },
      plugins = {
        marks = false,
        registers = false,
        spelling = {
          enabled = false,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
    },
    keys = {
      {
        "<Space>wk",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Which-key: Buffer-local keymaps",
      },
    },
  },

  -- nvim-notify
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
        render = "wrapped-compact",
        stages = "static",
        timeout = 1000,
        top_down = true
      })
    end
  },

  -- dressing.nvim
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

  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
      require("hover").setup {
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          require('hover.providers.gh')
          require('hover.providers.gh_user')
          require('hover.providers.diagnostic')
          require('hover.providers.man')
          require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = 'rounded'
        },
        preview_window = false,
        title = true,
        mouse_providers = {
          'LSP'
        },
        mouse_delay = 1000
      }
      -- keymaps
      vim.keymap.set("n", "K", require("hover").hover, { desc = "Hover: Default view" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "Hover: Select from providers" })
    end,
  },

  -- edgy.nvim for controlling sidebars:
  -- supports the display of multiple sidebars
  -- in the same consistently sized region
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      options = {
        left = { size = 25 },
        bottom = { size = 9 },
        right = { size = 25 },
        top = { size = 10 },
      },
      -- Configure the bottom panel
      bottom = {
        -- Trouble.nvim with diagnostics
        -- and symbols and quickfix and more
        {
          title = "Analysis",
          ft = "trouble"
        },
        -- ToggleTerm.nvim
        {
          title = "Terminal",
          ft = "toggleterm",
        },
        -- Standard quickfix window
        { ft = "qf", title = "QuickFix" },
      },
      -- Configure the right panel
      right = {
        -- Neotree filesystem
        {
          title = "Filesystem",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.5 },
        },
        -- Outline.nvim symbols
        {
          title = "Outline",
          ft = "Outline",
          pinned = false,
          size = { height = 0.30 },
          open = "OutlineOpen"
        },
        -- Neotree buffers
        {
          title = "Buffers",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "buffers"
          end,
          size = { height = 0.20 },
          pinned = false,
          open = "Neotree position=top buffers",
        },
        -- Neotree Git status
        {
          title = "Git",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          size = { height = 0.20 },
          pinned = false,
          open = "Neotree position=bottom git_status",
        },
        -- Aerial symbols
        {
          title = "Aerial",
          open = "AerialOpen",
          pinned = true,
          size = { height = 0.20 },
          ft = "aerial",
        },
      },
    },
  },

  -- snacks.nvim
  -- small improvements to the user interface
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      git = { enabled = false },
      lazygit = { enabled = false },
      indent = {
        enabled = false,
        animate = {
          enabled = false,
        },
        scope = {
          enabled = false,
        }
      },
      input = { enabled = false },
      notifier = {
        enabled = false,
      },
      picker = { enabled = false },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      styles = {
        notification = {
        }
      }
    },
    keys = {
      { "<leader>bd", function() Snacks.bufdelete() end,          desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.indent():map("<leader>ui")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
            "<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  -- auto-hlsearch.nvim
  -- Automatically disable search highlighting when
  -- it is not needed after performing a search; note
  -- that this is still needed even if all of the searches
  -- are run through the use of the flash.nvim plugin
  {
    "asiryk/auto-hlsearch.nvim",
    event = "BufReadPre",
    config = function()
      local auto_hlsearch = require("auto-hlsearch")
      auto_hlsearch.setup()
    end,
  },

  -- nvim-web-devicons
  -- Icons with overrides for filetypes
  -- where icons no longer display correctly with nerdfonts
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      -- set the filetype for configuration files
      -- without an extension; enables better highlighting
      -- for files that are named config
      -- set the filetype for rasi files (used for rofi)
      -- to also be configuration files; enables better
      -- highlighting for these files
      vim.cmd([[
        autocmd BufNewFile,BufRead config set filetype=config
        autocmd BufNewFile,BufRead *.rasi set filetype=config
        ]])
      -- add overrides for filenames/filetypes that are not detected
      require 'nvim-web-devicons'.setup {
        color_icons = false,
        strict = true,
        override_by_filename = {
          ["config"] = {
            icon = "",
            name = "Config"
          },
          ["Makefile"] = {
            icon = "",
            name = "Makefile"
          },
          [".zshrc"] = {
            icon = "󰿘",
            name = "Zsh"
          }
        },
        override_by_extension = {
          ["tex"] = {
            icon = "󰙩",
            name = "TeX"
          },
          ["toml"] = {
            icon = "",
            name = "Toml"
          },
          ["qmd"] = {
            icon = "󱨇",
            name = "Quarto"
          },
          [""] = {
            icon = "",
            name = "None"
          }
        },
      }
    end,
  },

  -- nuim.nvim
  -- User interface components
  "MunifTanjim/nui.nvim",

}
