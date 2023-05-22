-- File: plugins/languageserver.lua
-- Purpose: load and configure plugins for installation
-- and use of language servers protocol implementations

return {

  {
    "williamboman/mason.nvim",
    event = "BufReadPost",
    build = ":MasonUpdate"
  },

  {
    "folke/neodev.nvim",
    event = "BufReadPost",
    config = function()
      require("neodev").setup()
    end
  },

  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   event = "BufReadPost",
  --   config = function()
  --     -- Configure null-ls for diagnostics and formatting
  --     local null_ls = require("null-ls")
  --     null_ls.setup({
  --         sources = {
  --           null_ls.builtins.diagnostics.chktex,
  --           null_ls.builtins.diagnostics.flake8,
  --           null_ls.builtins.diagnostics.pydocstyle,
  --           null_ls.builtins.diagnostics.pylint,
  --           null_ls.builtins.formatting.black,
  --           null_ls.builtins.formatting.isort,
  --           null_ls.builtins.formatting.prettierd,
  --         },
  --     })
  --   end,
  -- },

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
      -- configure pyright for Python LSP
      lspconfig.pyright.setup {}
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
      -- configure html_ls for HTML
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.html.setup {
        capabilities = capabilities,
        filetypes = { 'markdown', 'quarto', 'html' },
      }
      -- configure cssls for CSS LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.cssls.setup {
        capabilities = capabilities,
      }
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
      -- Create all of the keybindings that have the following purposes:
      -- display in a floating window details about symbol under cursor
      local map = function(type, key, value)
        vim.api.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
      end
      -- display in a floating window details about symbol under cursor
      map('n', '<leader>k', '<cmd> lua vim.lsp.buf.hover()<CR>')
      -- display in a floating window details about parameter to called function
      map('n', '<space>k', '<cmd> lua vim.lsp.buf.signature_help()<CR>')
      -- display in a floating window diagnostics for the current line
      map('n', '<space>e', '<cmd> lua vim.diagnostic.open_float(0, {scope="line"})<CR>')
      -- send all of the diagnostics for the current window to the location list
      map('n', '<space>c', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>')
      -- run a code action on the current line of code
      map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
      -- rename the variable using a floating menu
      map('n', '<space>rv', '<cmd> lua vim.lsp.buf.rename()<CR>')
      -- reformat entire buffer content with a sync (i.e., reformat in a blocking fashion)
      map('n', '<space>ff', '<cmd> lua vim.lsp.buf.format()<CR>')
      -- -- Configure null-ls for diagnostics and formatting
      -- local null_ls = require("null-ls")
      -- null_ls.setup({
      --     sources = {
      --       null_ls.builtins.diagnostics.chktex,
      --       null_ls.builtins.diagnostics.flake8,
      --       null_ls.builtins.diagnostics.pydocstyle,
      --       null_ls.builtins.diagnostics.pylint,
      --       null_ls.builtins.formatting.black,
      --       null_ls.builtins.formatting.isort,
      --       null_ls.builtins.formatting.prettierd,
      --     },
      -- })
    end,
    -- Keys
    keys = {
      -- Toggle virtual text from the language servers
      { "<Space>sv", "<Plug>(toggle-lsp-diag-vtext)", desc = "Language Server: Toggle virtual text" },
    }
  },

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
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.prettierd,
        },
      })
    end,
    keys = {
      -- Toggle virtual text from the language servers
      { "<Space>ff", "<cmd> lua vim.lsp.buf.format()<CR>", desc = "Language Server: format buffer" },
    }
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = true,
    -- event = "BufReadPost",
    keys = {{
      "<leader>vv", "<cmd>:VenvSelect<cr>",
    }}
  },

}
