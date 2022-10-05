" Nvim-lint {{{

" Configure nvim-lint, avoiding its use when
" possible and instead using efmls which provides
" diagnostics a little faster and gives a label to
" clearly indicate that the error came from a
" specific linter, which nvim-lint does not do.

lua << EOF
-- load and configure the linting plugin
-- pick specific linters for specific file types
require('lint').linters_by_ft = {
  -- Disabled: using efmls
  -- mail = {'proselint'},
  -- Disabled: using efmls
  -- markdown = {'markdownlint', 'proselint'},
  markdown = {'markdownlint'},
  -- Disabled: using efmls
  -- python = {'flake8', 'pydocstyle', 'pylint'},
  python = {'pydocstyle'},
  tex = {'chktex'},
  -- Disabled: using efmls
  -- vim = {'vint'},
  -- Disabled: using efmls
  -- zsh = {'shellcheck'},
}
EOF

" Always run the linters whenever a file is saved
au BufWritePost * :lua require('lint').try_lint()

" lua << EOF
" local diagnostics_active = true
" vim.keymap.set('n', '<Space>td', function()
"   diagnostics_active = not diagnostics_active
"   if diagnostics_active then
"     vim.diagnostic.show()
"     -- vim.diagnostic.config({virtual_lines = true})
"   else
"     -- vim.diagnostic.config({virtual_lines = false})
"     vim.diagnostic.hide()
"   end
" end)
" EOF

" " Disable the display of linting diagnostics
" command! NoLint lua vim.diagnostic.config({virtual_lines = false})
" nmap <Space>nl :NoLint <CR>

" " Enable the display of linting diagnostics;
" " note that, by default, linting is enabled
" command! ShowLint lua vim.diagnostic.config({virtual_lines = true})
" nmap <Space>sl :ShowLint <CR>

lua << EOF
require'toggle_lsp_diagnostics'.init({ start_on = true, virtual_text = false })
EOF

nmap <Space>sl <Plug>(toggle-lsp-diag-vtext)

" }}}
