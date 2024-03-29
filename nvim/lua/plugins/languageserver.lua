-- File: plugins/languageserver.lua
-- Purpose: load and configure plugins for installation
-- and use of language servers protocol implementations

return {

  -- mason.nvim for LSP management
  {
    "williamboman/mason.nvim",
    event = "BufReadPost",
    build = ":MasonUpdate"
  },

  -- neodev.nvim for LSP enhancement for Lua files
  {
    "folke/neodev.nvim",
    event = "BufReadPost",
    config = function()
      require("neodev").setup()
    end
  },

  -- nvim-lspconfig for LSP management
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "pyright", "ruff_lsp", "cssls" },
      }
      local lspconfig = require('lspconfig')
      -- Setup LSP servers:
      -- 1) CSS
      -- 2) HTML
      -- 3) Lua
      -- 4) Markdown
      -- 5) Python
      -- 6) YAML
      -- configure cssls for CSS LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.cssls.setup {
        capabilities = capabilities,
      }
      -- configure html_ls for HTML
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.html.setup {
        capabilities = capabilities,
        filetypes = { 'markdown', 'quarto', 'html' },
      }
      -- configure luals (with neovim support) for Lua LSP
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace"
            }
          }
        }
      })
      -- configure marksman for Markdown LSP
      lspconfig.marksman.setup {
        filetypes = { 'markdown', 'quarto' },
      }
      -- configure pyright for Python LSP
      lspconfig.pyright.setup {}
      -- configure ruff for Python LSP
      lspconfig.ruff_lsp.setup {}
      -- configure texlab for LaTeX and BibTeX LSP
      lspconfig.texlab.setup {
        texlab = {
          auxDirectory = ".",
          bibtexFormatter = "texlab",
          build = {
            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            executable = "latexmk",
            forwardSearchAfter = false,
            onSave = false
          },
          chktex = {
            onEdit = false,
            onOpenAndSave = false
          },
          diagnosticsDelay = 300,
          formatterLineLength = 0,
          forwardSearch = {
            args = {}
          },
          latexFormatter = "latexindent",
          latexindent = {
            modifyLineBreaks = false
          }
        }
      }
      -- configure yamlls for YAML LSP
      lspconfig.yamlls.setup {}
      -- Use toggle_lsp_diagnostics to disable the virtual_text and then
      -- to support the display of the diagnostics
      require 'toggle_lsp_diagnostics'.init({ start_on = true, virtual_text = false })
      -- Define customized signs for diagnostics reported by the language server;
      -- note that this will define the signs displayed in the gutter
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = normal })
      end
    end,
    -- Keys
    keys = {
      {
        "<Space>sv",
        "<Plug>(toggle-lsp-diag-vtext)",
        desc =
        "Language Server: Toggle virtual text"
      },
      {
        "<Space>e",
        "<cmd> lua vim.diagnostic.open_float(0, {scope='line'})<CR>",
        desc =
        "Language Server: Display diagnostics"
      },
      {
        "<Space>k",
        "<cmd> lua vim.lsp.buf.hover()<CR>",
        desc =
        "Language Server: Symbol details"
      },
      {
        "<Space>c",
        "<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>",
        desc =
        "Language Server: Send to loclist"
      },
      {
        "<Space>c",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        desc =
        "Language Server: Send to loclist"
      },
      {
        "<Space>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        desc =
        "Language Server: Perform code action"
      },
      {
        "<Space>rv",
        "<cmd> lua vim.lsp.buf.rename()<CR>",
        desc =
        "Language Server: Rename variable"
      },
    }
  },

  -- mason-null-ls.nvim
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "chktex", "pydocstyle", "ruff", "prettierd" },
        automatic_installation = false,
        handlers = {},
      })
      -- Configure null-ls for diagnostics and formatting
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.chktex,
          null_ls.builtins.diagnostics.pydocstyle,
          null_ls.builtins.formatting.ruff,
          null_ls.builtins.formatting.prettierd,
        },
      })
    end,
    keys = {
      -- Perform a format of the content in the buffer
      { "<Space>ff", "<cmd> lua vim.lsp.buf.format()<CR>", desc = "Language Server: format buffer" },
    }
  },

  -- symbol-usage.nvim displays symbol usage information in virtual text
  {
    'Wansmer/symbol-usage.nvim',
    event = "BufReadPre",
    config = function()
      local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end
      vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Conceal').fg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Conceal').fg, bg = h('CursorLine').bg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })
      local function text_format(symbol)
        local res = {}
        local round_start = { '', 'SymbolUsageRounding' }
        local round_end = { '', 'SymbolUsageRounding' }
        if symbol.references then
          local usage = symbol.references <= 1 and 'usage' or 'usages'
          local num = symbol.references == 0 and 'no' or symbol.references
          table.insert(res, round_start)
          table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
          table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
          table.insert(res, round_end)
        end
        if symbol.definition then
          if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
          end
          table.insert(res, round_start)
          table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
          table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
          table.insert(res, round_end)
        end
        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
          end
          table.insert(res, round_start)
          table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
          table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
          table.insert(res, round_end)
        end
        return res
      end
      require('symbol-usage').setup({
        text_format = text_format,
      })
    end
  },

  -- venv-selector.nvim for selecting virtual environments after starting neovim
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = true,
    event = "VeryLazy",
    keys = { {
      "<leader>vv", "<cmd>:VenvSelect<cr>",
    } }
  },

}
