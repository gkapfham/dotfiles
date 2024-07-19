-- File: plugins/languageserver.lua
-- Purpose: load and configure plugins for installation
-- and use of language servers protocol (LSP) implementations

return {

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
      "hrsh7th/cmp-nvim-lsp",
      "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local lspconfig = require('lspconfig')
      -- draw the border for the LSP floating window; since the
      -- window used for commands like :LSPInfo is driven by the
      -- NormalFloat which is now set to dark to make the GitHub
      -- Copilot chat look as nice as possible there is a need
      -- to make the border visible so that these menus are okay
      require('lspconfig.ui.windows').default_options.border = 'single'
      -- draw the border for the LSP floating window that displays
      -- when requesting the documentation for source code; note
      -- that by default when you use <space>k it will display information
      -- about the source code under the cursor but do so without the box
      -- and this makes it difficult to see the information since the background
      -- is the same color and the diagnostic information
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      -- Setup LSP servers:
      -- 1) CSS
      -- 2) HTML
      -- 3) Lua
      -- 4) Markdown
      -- 5) Python
      -- 7) Go
      -- 7) LaTeX and BibTeX
      -- 8) Writing (Harper-ls)
      -- 9) YAML
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
      -- configure gopls for Go LSP
      lspconfig.gopls.setup{}
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
        settings = {
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
              executable = "zathura",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = false;
            },
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false
            }
          },
        }
      }
      -- configure harper_ls for writing
      lspconfig.harper_ls.setup {
        filetypes = { "mail", "markdown", "quarto", "text", },
        settings = {
          ["harper-ls"] = {
            userDictPath = "~/.config/nvim/spell/en.utf-8.add",
            linters = {
              spell_check = false,
              spelled_numbers = false,
              an_a = true,
              sentence_capitalization = true,
              unclosed_quotes = true,
              wrong_quotes = false,
              long_sentences = false,
              repeated_words = true,
              spaces = true,
              matcher = true,
              correct_number_suffix = true,
              number_suffix_capitalization = true,
            }
          }
        },
      }
      -- configure yamlls for YAML LSP
      lspconfig.yamlls.setup {}
      -- Use toggle_lsp_diagnostics to disable the virtual_text and then
      -- to support the display of the diagnostics
      require 'toggle_lsp_diagnostics'.init({ start_on = true, virtual_text = false })
      -- Define customized signs for diagnostics reported by the language server;
      -- note that this will define the signs displayed in the gutter
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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
        "<cmd> lua vim.diagnostic.open_float(0, {scope='line', border='rounded'})<CR>",
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
      { "<Space>ff", "<cmd> lua vim.lsp.buf.format()<CR>", desc = "Language Server: format buffer" },
    }
  },

  -- none-ls.nvim for LSP enhancement
  -- through the use of tools that are not
  -- language servers themselves but can
  -- be made to look like one with the
  -- support of this plugin
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Configure null-ls for diagnostics and formatting
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
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
      local function text_format(symbol)
        local res = {}
        local round_start = { '', 'SymbolUsageRounding' }
        local round_end = { '', 'SymbolUsageRounding' }
        if symbol.references then
          local usage = symbol.references <= 1 and 'usage' or 'usages'
          local num = symbol.references == 0 and 'no' or symbol.references
          table.insert(res, round_start)
          table.insert(res, { ' ', 'SymbolUsageRef' })
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

}
