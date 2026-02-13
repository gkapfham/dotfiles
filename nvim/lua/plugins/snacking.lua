-- File: plugins/snacking.lua
-- Purpose: load and configure the snacks.nvim plugin

return {

  -- snacks.nvim
  -- small improvements to the user interface,
  -- including pickers for numerous elements,
  -- a terminal window, and a file explorer
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      git = { enabled = false },
      gh = {
        enabled = false,
        icons = {
          reactions = {
            thumbs_up = " ",
            thumbs_down = " ",
            eyes = "󰡭 ",
            confused = "󱚟 ",
            heart = "󰣐 ",
            hooray = "󱁖 ",
            laugh = "󰱱 ",
            rocket = " ",
          },
        },
        layout = {
          layout = {
            backdrop = false,
          },
        },
      },
      lazygit = { enabled = false },
      indent = {
        enabled = true,
        animate = {
          enabled = true,
          style = "up_down",
          easing = "linear",
          duration = {
            step = 10,
            total = 100,
          },
        },
        scope = {
          enabled = true,
          underline = false,
        },
      },
      input = { enabled = false },
      notifier = {
        enabled = true,
        margin = { top = 1, right = 1, bottom = 0 },
        style = "fancy",
      },
      picker = {
        enabled = true,
        ui_select = true,
        icons = {
          diagnostics = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = "  ",
          },
        },
        layout = {
          layout = {
            backdrop = false,
          },
        },
        win = {
          input = {
            keys = {
              -- Remap toggle_live from <C-g> to <C-f> (avoids Zellij and spelling conflicts)
              -- <C-g> conflicts with Zellij lock
              ["<c-l>"] = { "toggle_live", mode = { "i", "n" } },
              ["<c-g>"] = false,
            },
          },
        },
        sources = {
          spelling = {
            layout = {
              layout = {
                border = "rounded",
              },
            },
          },
          icons = {
            layout = {
              layout = {
                border = "rounded",
              },
            },
          },
          command_history = {
            layout = {
              layout = {
                border = "rounded",
              },
            },
          },
          explorer = {
            layout = {
              layout = { position = "right", width = 35 },
            },
            styles = {
              zindex = 1,
            },
          },
          files = {
            layout = {
              layout = {
                backdrop = false,
              },
            },
          },
          scratch = {
            layout = {
              layout = {
                backdrop = false,
              },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = {
        enabled = false,
        treesitter = {
          blocks = {
            enabled = false,
          },
        },
      },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
    },
    keys = {
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gi",
        function()
          Snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>gI",
        function()
          Snacks.picker.gh_issue({ state = "all" })
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>gp",
        function()
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>gP",
        function()
          Snacks.picker.gh_pr({ state = "all" })
        end,
        desc = "GitHub Pull Requests (all)",
      },
      {
        "<leader>gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log_line()
        end,
        desc = "Git Log Line",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff (Hunks)",
      },
      {
        "<leader>gf",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git Log File",
      },
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<Space>0",
        function()
          Snacks.picker.explorer()
        end,
        desc = "File Explorer",
      },
      {
        "<Space>i",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Switch Buffers",
      },
      {
        "<Space>o",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = "Find Files: Hidden",
      },
      {
        "<Space>p",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files: Non-hidden",
      },
      {
        "<Space>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
      {
        "<Space>ch",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<Space>dd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Document Diagnostics",
      },
      {
        "<Space>ga",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep All",
      },
      {
        "<Space>gr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "LSP: Goto References",
      },
      {
        "<Space>gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "LSP: Goto Definitions",
      },
      {
        "<Space>gs",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Grep Highlighted Word",
      },
      {
        "<Space>ls",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP: Symbols",
      },
      {
        "<Space>sf",
        function()
          Snacks.picker.smart()
        end,
        desc = "Find Files: Smart",
      },
      {
        "<Space>si",
        function()
          require("similar").pick()
        end,
        desc = "Similar Files",
      },
      {
        "<Space>si",
        function()
          require("similar").pick_visual()
        end,
        mode = "v",
        desc = "Similar Files (selection)",
      },
      {
        "<Space>ta",
        function()
          require("aerial").snacks_picker()
        end,
        desc = "Aerial: Symbols",
      },
      {
        "<Space>ts",
        function()
          Snacks.picker.treesitter()
        end,
        desc = "Treesitter: Symbols",
      },
      {
        "<Space>wd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "LSP: Workspace Diagnostics",
      },
      {
        "<Space>ls",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP: Symbols",
      },
      {
        "<Space>ws",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP: Workspace Symbols",
      },
      {
        "<Space>tt",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
      },
      {
        "<Space>zz",
        function()
          Snacks.picker.spelling()
        end,
        desc = "Spelling Suggestions",
      },
    },
    init = function()
      local nvim_web_devicons = require("nvim-web-devicons")
      local current_icons = nvim_web_devicons.get_icons()
      local new_icons = {}
      for key, icon in pairs(current_icons) do
        icon.color = "#a8a8a8"
        new_icons[key] = icon
      end
      nvim_web_devicons.set_icon(new_icons)
      nvim_web_devicons.set_default_icon("", "#a8a8a8")
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.indent():map("<leader>ui")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  -- snacks-bibtex.nvim
  -- BibTeX citation picker for snacks.nvim
  {
    "krissen/snacks-bibtex.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      depth = 5,
      mappings = {
        ["<C-p>"] = false,
      },
      context = {
        enabled = true,
        fallback = true,
        inherit = true,
        depth = 1,
        max_files = 100,
      },
    },
    keys = {
      {
        "<Space>tb",
        function()
          require("snacks-bibtex").bibtex()
        end,
        desc = "BibTeX citations (Snacks)",
      },
    },
  },
}
