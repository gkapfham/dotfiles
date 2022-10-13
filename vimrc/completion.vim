" Basic Completion {{{

" Define basic completion function
set omnifunc=syntaxcomplete#Complete

" Define the dictionaries
set dictionary-=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english

" Completion includes dictionaries
" set complete-=k complete+=k
" set complete+=kspell
" set complete+=]

" Set the completion approach for the engine
set completeopt=menuone,noselect

" Do not echo messages (nor will searches)
set noshowmode

" Infer the case when doing completion
set infercase

" }}}
