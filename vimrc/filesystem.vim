" File System {{{

" Configure the dirvish plugin
augroup dirvishconfiguration
  autocmd!
  " Disable spell checking for the Dirvish buffers
  autocmd FileType dirvish setlocal nospell

  " Map `gr` to reload the Dirvish buffer
  autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

  " Map `gh` to hide dot-prefixed files
  " To toggle this, press `gr` to reload
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
augroup END

" Define the symbols used to indicate the status of the
" version control repository in a dirvish buffer
let g:dirvish_git_indicators = {
\ 'Modified'  : '!',
\ 'Staged'    : '+',
\ 'Untracked' : '?',
\ 'Renamed'   : '➜',
\ 'Unmerged'  : '═',
\ 'Ignored'   : '',
\ 'Unknown'   : ''
\ }

" Define the highlight color for version control details in dirvish
let g:gitstatus = 'guifg=#d78700 ctermfg=172'

" Define the color scheme to always be the same color;
" this is acceptable because the symbols vary.
silent exe 'hi default DirvishGitModified '.g:gitstatus
silent exe 'hi default DirvishGitStaged '.g:gitstatus
silent exe 'hi default DirvishGitRenamed '.g:gitstatus
silent exe 'hi default DirvishGitUnmerged '.g:gitstatus
silent exe 'hi default DirvishGitIgnored guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
silent exe 'hi default DirvishGitUntracked guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
silent exe 'hi default link DirvishGitUntrackedDir DirvishPathTail'

" }}}

