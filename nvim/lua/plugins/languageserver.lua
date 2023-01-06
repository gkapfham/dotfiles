-- File: Languageserver.lua
-- Purpose: load and configure plugins for installation
-- and use of language servers protocol implementations

return {

  -- Language servers with:
  -- nvim-lspconfig
  -- nvim-lsp-installer
  -- toggle_lsp_diagnostics
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/nvim-lsp-installer",
      "hrsh7th/cmp-nvim-lsp",
      "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    },
    config = function(plugin)
      local lsp_installer = require'nvim-lsp-installer'
      function common_on_attach(client, bufnr)
        -- Start of the language service and connect to it the
        -- other programs that use the language server
        print("契Starting Language Server");
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        opts = {silent = true, noremap = true, documentFormatting = True}
        -- Create all of the keybindings that have the following purposes:
        -- display in a floating window details about symbol under cursor
        buf_set_keymap('n', 'K', '<cmd> lua vim.lsp.buf.hover()<CR>', opts)
        -- display in a floating window details about parameter to called function
        buf_set_keymap('n', '<space>k', '<cmd> lua vim.lsp.buf.signature_help()<CR>', opts)
        -- display in a floating window diagnostics for the current line
        buf_set_keymap('n', '<space>e', '<cmd> lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
        -- send all of the diagnostics for the current window to the location list
        buf_set_keymap('n', '<space>c', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        -- go to the next diagnostic
        buf_set_keymap('n', ']d', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        -- go to the previous diagnostic
        buf_set_keymap('n', '[d', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        -- run a code action on the current line of code
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        -- rename the variable using a floating menu
        buf_set_keymap('n', '<space>rv', '<cmd> lua vim.lsp.buf.rename()<CR>', opts)
        -- reformat content (normal or visual mode) in a sync (i.e., blocking fashion)
        buf_set_keymap('n', '<space>fb', '<cmd> lua vim.lsp.buf.formatting_sync()<CR>', opts)
        buf_set_keymap('v', '<space>fb', '<cmd> lua vim.lsp.buf.formatting_sync()<CR>', opts)
        -- reformat content (normal or visual mode) in a async (i.e., fast, non-blocking fashion)
        buf_set_keymap('n', '<space>ff', '<cmd> lua vim.lsp.buf.formatting()<CR>', opts)
        buf_set_keymap('v', '<space>ff', '<cmd> lua vim.lsp.buf.formatting()<CR>', opts)
      end
      -- Install each of the chosen language servers and then
      -- run the common_on_attach function for each of them
      local installed_servers = lsp_installer.get_installed_servers()
      for _, server in pairs(installed_servers) do
          opts = {
              on_attach = common_on_attach,
          }
          server:setup(opts)
      end
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
      -- Toggle virtual text from the language servers
      { "<Space>sv", "<Plug>(toggle-lsp-diag-vtext)", desc = "Language Server: Toggle virtual text" },
    }
  },

}
