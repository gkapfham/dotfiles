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
      lspconfig.marksman.setup {}
      -- configure cssls for CSS LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.cssls.setup {
        capabilities = capabilities,
      }
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
      -- opts = {silent = true, noremap = true, documentFormatting = True}
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
      -- Configure null-ls for diagnostics and formatting
      local null_ls = require("null-ls")
      null_ls.setup({
          sources = {
            null_ls.builtins.diagnostics.chktex,
            null_ls.builtins.diagnostics.flake8,
            null_ls.builtins.diagnostics.pydocstyle,
            null_ls.builtins.diagnostics.pylint,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.isort,
            null_ls.builtins.formatting.prettierd,
          },
      })
    end,
    -- Keys
    keys = {
      -- Toggle virtual text from the language servers
      { "<Space>sv", "<Plug>(toggle-lsp-diag-vtext)", desc = "Language Server: Toggle virtual text" },
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

  -- -- Language servers with:
  -- -- nvim-lspconfig
  -- -- nvim-lsp-installer
  -- -- toggle_lsp_diagnostics
  -- {
  --   "neovim/nvim-lspconfig",
  --   event = "BufReadPost",
  --   dependencies = {
  --     "williamboman/nvim-lsp-installer",
  --     "hrsh7th/cmp-nvim-lsp",
  --     "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
  --     "jose-elias-alvarez/null-ls.nvim",
  --   },
  --   config = function(plugin)
  --     local lsp_installer = require'nvim-lsp-installer'
  --     function common_on_attach(client, bufnr)
  --       -- Start of the language service and connect to it the
  --       -- other programs that use the language server
  --       -- print("契Starting Language Server");
  --       vim.notify(" Starting Language Server(s)");
  --       local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  --       opts = {silent = true, noremap = true, documentFormatting = True}
  --       -- Create all of the keybindings that have the following purposes:
  --       -- display in a floating window details about symbol under cursor
  --       buf_set_keymap('n', '<leader>k', '<cmd> lua vim.lsp.buf.hover()<CR>', opts)
  --       -- display in a floating window details about parameter to called function
  --       buf_set_keymap('n', '<space>k', '<cmd> lua vim.lsp.buf.signature_help()<CR>', opts)
  --       -- display in a floating window diagnostics for the current line
  --       buf_set_keymap('n', '<space>e', '<cmd> lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
  --       -- send all of the diagnostics for the current window to the location list
  --       buf_set_keymap('n', '<space>c', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  --       -- go to the next diagnostic
  --       -- buf_set_keymap('n', ']d', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --       -- go to the previous diagnostic
  --       -- buf_set_keymap('n', '[d', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  --       -- run a code action on the current line of code
  --       buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --       -- rename the variable using a floating menu
  --       buf_set_keymap('n', '<space>rv', '<cmd> lua vim.lsp.buf.rename()<CR>', opts)
  --       -- reformat entire buffer content with a sync (i.e., reformat in a blocking fashion)
  --       buf_set_keymap('n', '<space>ff', '<cmd> lua vim.lsp.buf.format()<CR>', opts)
  --       -- attempt to tell the language server not to highlight semantic tokens
  --       -- (note that this approach does not seem to work correctly)
  --       client.server_capabilities.semanticTokensProvider = nil
  --     end
  --     -- Install each of the chosen language servers and then
  --     -- run the common_on_attach function for each of them
  --     local installed_servers = lsp_installer.get_installed_servers()
  --     for _, server in pairs(installed_servers) do
  --         opts = {
  --             on_attach = common_on_attach,
  --         }
  --         server:setup(opts)
  --     end
  --     -- Use toggle_lsp_diagnostics to disable the virtual_text and then
  --     -- to support the display of the diagnostics
  --     require'toggle_lsp_diagnostics'.init({ start_on = true, virtual_text = false })
  --     -- Define customized signs for diagnostics reported by the language server;
  --     -- note that this will define the signs displayed in the gutter
  --     local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  --     for type, icon in pairs(signs) do
  --       local hl = "DiagnosticSign" .. type
  --       vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = normal })
  --     end
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
  --   -- Keys
  --   keys = {
  --     -- Toggle virtual text from the language servers
  --     { "<Space>sv", "<Plug>(toggle-lsp-diag-vtext)", desc = "Language Server: Toggle virtual text" },
  --   }
  -- },

}
