" Language Servers {{{

lua << EOF
local lsp_installer = require'nvim-lsp-installer'
function common_on_attach(client, bufnr)
  -- start of the language service and connect to it the
  -- other programs that use the language server
  print("契Starting Language Server");
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  opts = {silent = true, noremap = true}
  buf_set_keymap('n', 'K', '<cmd> lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd> lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
  buf_set_keymap('n', '<space>k', '<cmd> lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>c', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<space>sm', '<cmd> lua print(vim.inspect(vim.lsp.buf_get_clients()[1].resolved_capabilities))<CR>', opts)
  buf_set_keymap('n', '<space>sm', '<cmd> lua print(vim.inspect(vim.lsp.buf_get_clients()[1].resolved_capabilities))<CR>', opts)
  buf_set_keymap('n', '<space>rv', '<cmd> lua vim.lsp.buf.rename()<CR>', opts)
  require("aerial").on_attach(client, bufnr)
end
local installed_servers = lsp_installer.get_installed_servers()
for _, server in pairs(installed_servers) do
    opts = {
        on_attach = common_on_attach,
    }
    server:setup(opts)
end
EOF

" Configure the dressing plugin that makes menus;
" this is useful for renaming files and other types
" of refactoring as the menus appear inside the editor
" instead of appearing at the very bottom of the screen
lua << EOF
require("dressing").setup {
  input = {
    winblend = 0,
    winhighlight = 'NormalFloat:Normal',
    override = function(conf)
      conf.col = -1
      conf.row = 0
      return conf
    end,
  },
}
EOF

" Define a mapping for toggling the Aerial plugin;
" note that this plugin can handle outlines of
" documents through a custom markdown parser and
" then both LSP and treesitter. I think that it is
" currently the only plugin support all of the backends.
nnoremap <Space>- :AerialToggle<CR>

" }}}
