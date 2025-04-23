-- File: plugins/snacking.lua
-- Purpose: load and configure the snacks.nvim plugin

return {

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
      picker = {
        enabled = true,
        layout = {
          layout = {
            backdrop = false,
            border = "rounded",
          }
        },
        sources = {
          command_history = {
            layout = {
              layout = {
                border = "rounded",
              }
            },
          },
          explorer = {
            layout = {
              layout = { position = "right", width = 0.25 },
            },
          },
          files = {
            layout = {
              layout = {
                backdrop = false,
              }
            },
          },
        },
      },
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
      { "<leader>bd", function() Snacks.bufdelete() end,                     desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,            desc = "Rename File" },
      { "<leader>gb", function() Snacks.picker.git_branches() end,           desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end,                desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end,           desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end,             desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end,              desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end,               desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end,           desc = "Git Log File" },
      { '<leader>s"', function() Snacks.picker.registers() end,              desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end,         desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end,               desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end,                  desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end,        desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end,               desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end,            desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,     desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end,                   desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end,             desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end,                  desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end,                  desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end,                desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end,                desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end,                  desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end,                    desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end,                   desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end,                 desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end,                 desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end,                   desc = "Undo History" },
      { "<Space>0",   function() Snacks.picker.explorer() end,               desc = "File Explorer" },
      { "<Space>i",   function() Snacks.picker.buffers() end,                desc = "Switch Buffers" },
      { "<Space>o",   function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files: Hidden" },
      { "<Space>p",   function() Snacks.picker.files() end,                  desc = "Find Files: Non-hidden" },
      { "<Space>n",   function() Snacks.picker.notifications() end,          desc = "Notification History" },
      { "<Space>ch",  function() Snacks.picker.command_history() end,        desc = "Command History" },
      { "<Space>ga",  function() Snacks.picker.grep() end,                   desc = "Grep All" },
      { "<Space>gr",  function() Snacks.picker.lsp_references() end,         desc = "LSP: Goto References" },
      { "<Space>gd",  function() Snacks.picker.lsp_definitions() end,        desc = "LSP: Goto Definitions" },
      { "<Space>gs",  function() Snacks.picker.grep_word() end,              desc = "Grep All: Highlighted Word" },
      { "<Space>ls",  function() Snacks.picker.lsp_symbols() end,            desc = "LSP: Symbols" },
      { "<Space>so",  function() Snacks.picker.smart() end,                  desc = "Find Files: Smart" },
      { "<Space>ts",  function() Snacks.picker.treesitter() end,             desc = "Treesitter: Symbols" },
      { "<Space>wd",  function() Snacks.picker.diagnostics() end,            desc = "Workspace Diagnostics" },
      { "<Space>dd",  function() Snacks.picker.diagnostics_buffer() end,     desc = "Document Diagnostics" },
      { "<Space>wd",  function() Snacks.picker.diagnostics() end,            desc = "Workspace Diagnostics" },
      { "<Space>zz",  function() Snacks.picker.spelling() end,               desc = "Spelling Suggestions" },
    },
    init = function()
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


}
