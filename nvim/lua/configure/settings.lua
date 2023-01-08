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

-- }}}

-- Indentation settings through the use of vim.cmd and vimscript commands {{{

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

-- Display trailing spaces
vim.cmd([[
set listchars=tab:▸▹,trail:•,extends:#,precedes:#,nbsp:⌻
set list
match ExtraWhitespace /\s\+$\|\t/
augroup extra_whitespace
  autocmd!
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END
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

-- Spelling settings through the use of vim.cmd and vimscript commands {{{

vim.cmd([[
" Enable spell checking
" syntax spell toplevel

" Configure the spelling files;
" note that this is not ideal because
" the Makefile for my dotfiles deletes
" this directory and then moves comments
set spellfile+=~/.config/nvim/spell/en.utf-8.add
set spellfile+=.extra.utf-8.add

" Correct spelling mistakes from insert mode when typing
" Reference:
" https://stackoverflow.com/questions/5312235/how-do-i-correct-vim-spelling-mistakes-quicker
" Note that this mapping does not seem to work for all filetypes
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Enable spell checking with two dictionaries
set spell spelllang=en_us,en_gb

" Disable spell checking in source code
au BufNewFile,BufRead,BufEnter *.c      set nospell
au BufNewFile,BufRead,BufEnter *.h      set nospell
au BufNewFile,BufRead,BufEnter *.cpp    set nospell
au BufNewFile,BufRead,BufEnter *.hpp    set nospell
au BufNewFile,BufRead,BufEnter *.java   set nospell
au BufNewFile,BufRead,BufEnter *.py     set nospell
au BufNewFile,BufRead,BufEnter *.sh     set nospell
au BufNewFile,BufRead,BufEnter *.xml    set nospell
au BufNewFile,BufRead,BufEnter *.sql    set nospell
au BufNewFile,BufRead,BufEnter *.bib    set nospell

" Disable spell checking in quickfix
augroup quickfixnospell
  autocmd!
  autocmd FileType qf setlocal nospell
augroup END

" Disable spell checking in git
augroup gitnospell
  autocmd!
  autocmd FileType git setlocal nospell
augroup END
]])

-- }}}
