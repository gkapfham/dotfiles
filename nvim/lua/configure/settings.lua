-- Configure variables that are a part of neovim's global environment

-- Define settings for vim.opt variables {{{

-- Define the signcolumn
vim.opt.signcolumn="yes:1"

-- Disable the welcome message
vim.opt.shortmess="FIWacto"

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

-- }}}

-- Indentation settings through the use of vim.cmd and vimscript commands {{{

-- Improved indentation
vim.cmd([[

" Automatically identify the filetype
" Always use syntax highlighting
" filetype indent plugin on | syn on

" Always continue a comment in code to
" the next line when pressing "return"
set formatoptions+=r

  " set autoindent
  set copyindent
  set shiftwidth=2
  " " set smartindent



]])

-- Display linebreaks and tabs
vim.cmd([[
  set linebreak
  set showbreak=━━
  " set breakindent
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

-- vim.opt.smartindent = true -- Insert indents automatically
-- vim.opt.autoindent = true -- Insert indents automatically

-- Display trailing spaces
vim.cmd([[
  " set listchars=tab:▸▹,trail:•,extends:#,precedes:#,nbsp:⌻
  " set list
  " match ExtraWhitespace /\s\+$\|\t/
  " let ftToIgnore = ['neotest-output-panel']
  " augroup extra_whitespace
  "   autocmd!
  "   autocmd BufWinEnter * if index(ftToIgnore, &ft) < 0 | match ExtraWhitespace /\s\+$/
  "   autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  "   autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  "   autocmd BufWinLeave * call clearmatches()
  " augroup END
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
