" System {{{

" Enable spell checking
syntax spell toplevel

" Configure the spelling files
set spellfile+=~/.config/nvim/spell/en.utf-8.add
set spellfile+=.extra.utf-8.add

" Correct spelling mistakes from insert mode when typing
" Reference:
" https://stackoverflow.com/questions/5312235/how-do-i-correct-vim-spelling-mistakes-quicker
" Note that this mapping does not seem to work for all filetypes
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Make changes automatically saved during Qdo
set autowrite

" Enable spell checking with two dictionaries
set spell spelllang=en_us,en_gb
set mousemodel=popup

" Disable spell checking in source code
au BufNewFile,BufRead,BufEnter *.c    set nospell
au BufNewFile,BufRead,BufEnter *.h    set nospell
au BufNewFile,BufRead,BufEnter *.cpp  set nospell
au BufNewFile,BufRead,BufEnter *.hpp  set nospell
au BufNewFile,BufRead,BufEnter *.java set nospell
au BufNewFile,BufRead,BufEnter *.sh   set nospell
au BufNewFile,BufRead,BufEnter *.xml  set nospell
au BufNewFile,BufRead,BufEnter *.sql  set nospell
au BufNewFile,BufRead,BufEnter *.bib  set nospell

" Disable spell checking in quickfix
augroup quickfix
  autocmd!
  autocmd FileType qf setlocal nospell
augroup END

" Disable spell checking in git
augroup quickfix
  autocmd!
  autocmd FileType git setlocal nospell
augroup END

" Ignore these directories
set wildignore+=*/build/**
set wildignore+=*/.git/*
set wildignore+=*.class
set wildignore+=*/tmp/*

" Set levels for history an undo
set history=1000
set undolevels=1000

" Set persistent undo
set undofile
set undodir=~/.vim/undo

" Source the vimrc file with Reload
command! Reload :source $MYVIMRC

" Define a mapping for the easy use of Reload
nnoremap <leader>rr :Reload<CR>

" }}}
