" Manual Pages {{{

" Define a special configuration for man buffers
augroup manconfiguration
  autocmd!
  " Disable spell checking for the man buffers
  autocmd FileType man setlocal nospell
augroup END

" Fuzzy search through the man pages with Fzf and then
" display the selected man page inside of Vim
command! -nargs=? Superman call fzf#run(fzf#wrap({'source': 'man -k -s 1 '.shellescape(<q-args>).' | cut -d " " -f 1', 'sink': 'tab Man', 'options': ['--preview', 'MANPAGER=cat MANWIDTH='.(&columns/2-4).' man {}']}))

" }}}
