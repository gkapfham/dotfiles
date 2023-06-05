-- File: plugins/languageserver.lua
-- Purpose: load and configure plugins for installation
-- and use of language servers protocol implementations

return {

  -- Mason.nvim for LSP management
  {
    "williamboman/mason.nvim",
    event = "BufReadPost",
    build = ":MasonUpdate"
  },

  -- Neodev.nvim for LSP enhancement for Lua files
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
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "pyright", "cssls" },
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
      -- configure yamlls for YAML LSP
      lspconfig.yamlls.setup {}
      -- Use toggle_lsp_diagnostics to disable the virtual_text and then
      -- to support the display of the diagnostics
      require'toggle_lsp_diagnostics'.init({ start_on = true, virtual_text = false })
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
      { "<Space>sv", "<Plug>(toggle-lsp-diag-vtext)", desc = "Language Server: Toggle virtual text" },
      { "<Space>e", "<cmd> lua vim.diagnostic.open_float(0, {scope='line'})<CR>", desc = "Language Server: Display diagnostics"},
      { "<Space>k", "<cmd> lua vim.lsp.buf.hover()<CR>", desc = "Language Server: Symbol details"},
      { "<Space>c", "<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>", desc = "Language Server: Send to loclist"},
      { "<Space>c", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Language Server: Send to loclist"},
      { "<Space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Language Server: Perform code action"},
      { "<Space>rv", "<cmd> lua vim.lsp.buf.rename()<CR>", desc = "Language Server: Rename variable"},
    }
  },

  -- mason-null-ls.nvim
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "chktex", "pydocstyle", "black", "isort", "prettierd" },
        automatic_installation = false,
        handlers = {},
      })
      -- Configure null-ls for diagnostics and formatting
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.chktex,
          -- null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.diagnostics.pydocstyle,
          -- null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.formatting.black,
          -- null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.prettierd,
        },
      })
    end,
    keys = {
      -- Toggle virtual text from the language servers
      { "<Space>ff", "<cmd> lua vim.lsp.buf.format()<CR>", desc = "Language Server: format buffer" },
    }
  },

  -- venv-selector.nvim for selecting virtual environments after starting neovim
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = true,
    event = "VeryLazy",
    keys = {{
      "<leader>vv", "<cmd>:VenvSelect<cr>",
    }}
  },

}
