-- Configure variables that are a part of neovim's global environment

-- Define settings for vim.opt variables {{{

-- Define the signcolumn
vim.opt.signcolumn="yes:1"

-- Disable the welcome message
vim.opt.shortmess="FIWacto"

-- }}}

-- Display settings for vim.wo variables {{{

-- Display numbers
vim.cmd([[set number]])

-- Display relative numbers
vim.cmd([[set relativenumber]])

-- }}}

-- Display settings through use of vim.cmd and then vimscript commands {{{

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
