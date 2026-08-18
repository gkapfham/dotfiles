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

  -- -- dressing.nvim
  -- -- User interface enhancements
  -- {
  --   "stevearc/dressing.nvim",
  --   init = function()
  --     vim.ui.select = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.select(...)
  --     end
  --     vim.ui.input = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.input(...)
  --     end
  --   end,
  -- },

  -- hover.nvim
  -- Hover information for LSP
  -- and other sources for documentation
  -- like the built-in dictionary
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
      local language_servers = require("configure.languageservers")
      require("hover").setup({
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          require("hover.providers.diagnostic")
          require("hover.providers.man")
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = "rounded",
        },
        preview_window = false,
        title = true,
        mouse_providers = {
          "LSP",
        },
        mouse_delay = 1000,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          vim.schedule(language_servers.refresh_hover)
        end,
      })
      -- keymaps
      vim.keymap.set("n", "K", function()
        require("hover").open()
      end, { desc = "hover.nvim (open)" })
      vim.keymap.set("n", "gK", function()
        require("hover").enter()
      end, { desc = "hover.nvim (enter)" })
      vim.keymap.set("n", "<Space>sp", function()
        require("hover").switch("previous")
      end, { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<Space>sn", function()
        require("hover").switch("next")
      end, { desc = "hover.nvim (next source)" })
    end,
  },

  -- noice.nvim
  -- Enhanced command line and message display,
  -- especially nice for the command-palette that
  -- is visible when you press ":" and for the
  -- search interface when you press "/"
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            -- requires hrsh7th/nvim-cmp
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          -- disable the bottom search, meaning that the
          -- search appears at the same location as the
          -- command palette, keeping eyes in the same location
          bottom_search = false,
          -- position the cmdline and popupmenu together
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        views = {
          -- move the command palette a little lower on the
          -- screen; the command_palette preset places it at
          -- row 3 (near the very top) and this override wins
          -- because noice merges the user options after the
          -- presets; tune the row percentage to taste
          cmdline_popup = {
            position = {
              row = "12.5%",
            },
            -- make the cmdline/search popup narrower: the noice
            -- default floor is 60 columns (min_width), so even a
            -- short ":w" or "/foo" stretches to 60 columns;
            -- lower the minimum and optionally cap the width
            -- (a number is columns, a string like "40%" is a
            -- percentage of the editor width)
            size = {
              min_width = 40,
              width = "auto",
              height = "auto",
            },
          },
        },
      })
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
        bottom = { size = 15 },
        right = { size = 35 },
        top = { size = 10 },
      },
      -- Configure the bottom panel
      -- that is used for the terminal
      -- provided by snacks.nvim
      bottom = {
        {
          title = "Terminal",
          ft = "snacks_terminal",
        },
      },
      -- Configure the right-side panel
      right = {
        -- Snacks.nvim with the file explorer;
        -- note that a customized handling for
        -- the file explorer (that is a picker)
        -- is needed for snacks.nvim to work
        -- with edgy because of the fact that
        -- there are multiple types of pickers
        -- that have the same filetype
        {
          title = "Explorer",
          ft = "snacks_layout_box",
          pinned = true,
          open = function()
            Snacks.explorer()
          end,
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        -- Trouble.nvim with diagnostics
        -- and symbols and quickfix and more
        {
          title = "Analyzer",
          pinned = true,
          ft = "trouble",
        },
        -- Aerial symbols
        {
          title = "Aerializer",
          open = "AerialOpen",
          pinned = false,
          ft = "aerial",
        },
        -- Outline symbols
        {
          title = "Outliner",
          open = "OutlineOpen",
          pinned = false,
          ft = "Outline",
        },
      },
    },
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
      require("nvim-web-devicons").setup({
        color_icons = false,
        strict = true,
        override_by_filename = {
          ["config"] = {
            icon = "",
            name = "Config",
          },
          ["Makefile"] = {
            icon = "",
            name = "Makefile",
          },
          [".zshrc"] = {
            icon = "󰿘",
            name = "Zsh",
          },
        },
        override_by_extension = {
          ["css"] = {
            icon = "",
            name = "CSS",
          },
          ["kdl"] = {
            icon = "",
            name = "Zellij",
          },
          ["tex"] = {
            icon = "󰙩",
            name = "TeX",
          },
          ["toml"] = {
            icon = "",
            name = "Toml",
          },
          ["qmd"] = {
            icon = "󱨇",
            name = "Quarto",
          },
          [""] = {
            icon = "",
            name = "None",
          },
        },
      })
    end,
  },

  -- tiny-glimmer.nvim
  -- A minimalist way to highlight text,
  -- mostly for text that is yanked or pasted
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10, -- Low priority to catch other plugins' keybindings
    config = function()
      require("tiny-glimmer").setup()
    end,
  },

  -- nuim.nvim
  -- User interface components
  "MunifTanjim/nui.nvim",
}
