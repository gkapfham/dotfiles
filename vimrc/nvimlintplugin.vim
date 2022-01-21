" Nvim-lint {{{

lua << EOF
-- load and configure the linting plugin
-- pick specific linters for specific file types
require('lint').linters_by_ft = {
  mail = {'proselint'},
  markdown = {'markdownlint', 'proselint'},
  python = {'flake8', 'pydocstyle', 'pylint'},
  tex = {'chktex'},
  vim = {'vint'},
  zsh = {'shellcheck'},
}
EOF

" Always run the linters whenever a file is saved
au BufWritePost * :lua require('lint').try_lint()

" Disable the display of linting diagnostics
command! NoLint lua vim.diagnostic.config({virtual_text = false})

" Enable the display of linting diagnostics;
" note that, by default, linting is enabled
command! ShowLint lua vim.diagnostic.config({virtual_text = true})

" }}}
