" Search Highlighting {{{

" Incrementally highlight the search matches
set incsearch

" Support the highlighting of words
nnoremap <silent><expr> <Leader>i (&hls && v:hlsearch ? ':set nohlsearch' : ':set hlsearch')."\n"

" Carefully ignore the case of words when searching
set ignorecase
set smartcase

" Make :grep use ripgrep and use -uu to not ignore files
" This is an alternative to :Rg or :Ag which ignore some files
set grepprg=rg\ -uu\ --vimgrep\ --no-heading\ --smart-case

" }}}
