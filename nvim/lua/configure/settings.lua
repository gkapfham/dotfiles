-- Configure variables that are a part of neovim's global environment

-- Define settings for vim.opt variables {{{

-- Define the signcolumn
vim.opt.signcolumn="yes:1"

-- Disable the welcome message
vim.opt.shortmess="FIWacto"

-- }}}

-- Display settings through use of vim.cmd and then vimscript commands {{{

-- Display numbers
vim.cmd([[set number]])

-- Display relative numbers
vim.cmd([[set relativenumber]])

-- Improved indentation
vim.cmd([[
set autoindent
set copyindent
set shiftwidth=2
set smartindent
]])

-- Display linebreaks and tabs
vim.cmd([[
set linebreak
set showbreak=━━
set breakindent
set tabstop=4
]])

-- Insert spaces for a tab
vim.cmd([[
set expandtab
set smarttab
set shiftround
]])

--- }}}
