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
      { "<leader>bd", function() Snacks.bufdelete() end,                 desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,        desc = "Rename File" },
      { "<Space>0",   function() Snacks.picker.explorer() end,           desc = "File Explorer" },
      { "<Space>i",   function() Snacks.picker.buffers() end,            desc = "Switch Buffers" },
      { "<Space>o",   function() Snacks.picker.smart() end,              desc = "Find Files: Smart" },
      { "<Space>p",   function() Snacks.picker.files() end,              desc = "Find Files: Non-hidden" },
      { "<Space>p",   function() Snacks.picker.files() end,              desc = "Find Files: Non-hidden" },
      { "<Space>ga",  function() Snacks.picker.grep() end,               desc = "Grep All" },
      { "<Space>gr",  function() Snacks.picker.lsp_references() end,     desc = "LSP: Goto References" },
      { "<Space>gd",  function() Snacks.picker.lsp_definitions() end,    desc = "LSP: Goto Definitions" },
      { "<Space>gs",  function() Snacks.picker.grep_word() end,          desc = "Grep All: Highlighted Word" },
      { "<Space>wd",  function() Snacks.picker.diagnostics() end,        desc = "Workspace Diagnostics" },
      { "<Space>dd",  function() Snacks.picker.diagnostics_buffer() end, desc = "Document Diagnostics" },
      { "<Space>wd",  function() Snacks.picker.diagnostics() end,        desc = "Workspace Diagnostics" },
      { "<Space>:",   function() Snacks.picker.command_history() end,    desc = "Command History" },
      { "<Space>n",   function() Snacks.picker.notifications() end,      desc = "Notification History" },
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


}
