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
-- vim.wo.number=true

-- Display relative numbers
vim.cmd([[set relativenumber]])
-- vim.wo.relativenumber=true

--- }}}
