" Language Servers {{{

" Install and configure language servers using nvim-lsp-installer;
" for each language server installed, attach it to the buffer and
" register key mappings that are specifically useful when running
" a language server protocol for that buffer.

lua << EOF
local lsp_installer = require'nvim-lsp-installer'
local efmls = require 'efmls-configs'
function common_on_attach(client, bufnr)
  -- start of the language service and connect to it the
  -- other programs that use the language server
  print("契Starting Language Server");
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  opts = {silent = true, noremap = true, documentFormatting = True}
  buf_set_keymap('n', 'K', '<cmd> lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd> lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
  buf_set_keymap('n', '<space>k', '<cmd> lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>c', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<space>sm', '<cmd> lua print(vim.inspect(vim.lsp.buf_get_clients()[1].resolved_capabilities))<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>rv', '<cmd> lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ff', '<cmd> lua vim.lsp.buf.formatting_sync()<CR>', opts)
  -- attach the aerial plugin to this language server and the
  -- buffer so that it can provide code navigation
  require("aerial").on_attach(client, bufnr)
end
-- install each of the chosen language servers and then
-- run the common_on_attach function for each of them
local installed_servers = lsp_installer.get_installed_servers()
for _, server in pairs(installed_servers) do
    opts = {
        on_attach = common_on_attach,
    }
    server:setup(opts)
end
EOF

" Install and configure the efm language server that
" allows you run run linters and formatters that do not
" work standardly with the language server interface
" because they are not precisely an LSP implementation.

" This means that it is possible to run commands like
" black and prettierd through efm even though they
" are not specifically designed to work as an LSP
" implementation. Right now, I'm only using efmls
" for formatting and using nvim-lint for all extra
" linters (e.g., pydocstyle, pylint, and flake8).

lua << EOF
local efmls = require 'efmls-configs'
efmls.init {
  on_attach = common_on_attach,
  init_options = {
    documentFormatting = true,
  },
}
local prettier_d = require 'efmls-configs.formatters.prettier_d'
local black = require 'efmls-configs.formatters.black'
efmls.setup {
  css = {
    formatter = prettier_d,
  },
  javascript = {
    formatter = prettier_d,
  },
  markdown = {
    formatter = prettier_d,
  },
  python = {
    formatter = black,
  },
  yaml = {
    formatter = prettier_d,
  },
}
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
