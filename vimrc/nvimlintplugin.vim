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

lua << EOF
-- Use the lsp_lines.nvim plugin for the display
-- of diagnostics reported from the lsp implementation
require("lsp_lines").setup()
vim.diagnostic.config({
  virtual_text = false,
})
vim.keymap.set(
  "",
  "<Space>sl",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)
EOF

" Disable the display of linting diagnostics
" command! NoLint lua vim.diagnostic.config({virtual_lines = false})

" Enable the display of linting diagnostics;
" note that, by default, linting is enabled
" command! ShowLint lua vim.diagnostic.config({virtual_lines = true})

" }}}
