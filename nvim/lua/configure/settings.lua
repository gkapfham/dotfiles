-- File: configure/autocmds.lua
-- Purpose: Configure variables that are a part of neovim's global environment

-- Stop running the health checks for the Perl provider {{{

vim.cmd([[
  let g:loaded_perl_provider = 0
]])

-- }}}

-- Define settings for vim.opt variables {{{

-- Define the signcolumn
vim.opt.signcolumn = "yes:1"

-- Disable the welcome message
vim.opt.shortmess = "FIWacto"

-- Improve performance
vim.opt.lazyredraw = false

-- }}}

-- Display settings through use of vim.cmd and then vimscript commands {{{

-- Display screen redraws faster
vim.cmd([[
  set nocursorcolumn
  set nocursorline
  set ttyfast
]])

-- Display numbers
vim.cmd([[set number]])

-- Display relative numbers
vim.cmd([[set relativenumber]])

-- Display improved find and replace
vim.cmd([[set inccommand=split]])

-- Do not display commands in right-hand corner
vim.cmd([[set noshowcmd]])

-- Ignorecase search: "J" and "j" are the same
-- Smartcase search: "J" is different than "j" if capitalized used
-- Both of these variables are respected by flash.nvim; see the
-- plugins/movement.lua file for more information about flash.nvim
vim.cmd([[
  set ignorecase
  set smartcase
]])

-- }}}

-- Indentation settings through the use of vim.cmd and vimscript commands {{{

-- Improved indentation
vim.cmd([[
  " Always continue a comment in code to
  " the next line when pressing "return"
  set formatoptions+=r
  " Control the indentation of copied lines
  set copyindent
  set shiftwidth=2
]])

-- Display linebreaks and tabs
vim.cmd([[
  set linebreak
  set showbreak=━━
  set tabstop=4
]])

-- -- Separate linebreaks and tabs for Python
-- vim.cmd([[
--   autocmd Filetype python setlocal softtabstop=4
--   autocmd Filetype python setlocal shiftwidth=4
-- ]])

-- Separate linebreaks and tabs for Golang
vim.cmd([[
  au Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  au Filetype go setlocal listchars+=tab:\ \
]])

-- Insert spaces for a tab
vim.cmd([[
  set expandtab
  set smarttab
  set shiftround
]])

-- Disable linewrapping in gitcommit buffer when using fugitive
vim.cmd([[
  " Disable line wrapping when entering a gitcommit buffer
  autocmd BufEnter * if &filetype == 'gitcommit' | setlocal formatoptions-=t | endif
  " Re-enable line wrapping when leaving a gitcommit buffer
  autocmd BufLeave * if &filetype == 'gitcommit' | setlocal formatoptions+=t | endif
]])

-- }}}

-- Movement settings through the use of vim.cmd and vimscript commands {{{

-- Word wrapping goes to the next line
vim.cmd([[
  set whichwrap+=<,>,h,l,[,]
]])

-- Navigate through wrapped text
vim.cmd([[
  nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
  nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'
]])

-- }}}
