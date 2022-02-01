" FZF {{{

" NOTE: FZF is used in conjunction with telescope.nvim because
" plugins like wiki.vim are integrated with FZF. Moreover,
" although all FZF commands are no longer directly integrated into
" the workflow with nnoremap's, they are still available if needed.

" NOTE: There are alternate FZF-based commands for the use of,
" for instance, tags and grepping because Telescope's variants
" do not work correctly or do not work efficiently enough.
"
" The Telescope-based commands are prefixed with <Space>
" and the FZF-based commands are prefixed with <Leader>

" Define the layout of FZF's window so that it matches the height
" and width of the Telescope window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }

" Define unique colors for FZF's display
" inside of Neovim (note that these colors
" match telescope.nvim and not FZF in terminal)
let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Normal'],
      \ 'fg+':     ['fg', 'String', 'Normal', 'Normal'],
      \ 'bg+':     ['bg', 'Normal', 'Normal'],
      \ 'hl+':     ['fg', 'Identifier'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Comment'],
      \ 'prompt':  ['fg', 'Identifier'],
      \ 'pointer': ['fg', 'Identifier'],
      \ 'marker':  ['fg', 'Identifier'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" Use rg by default
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!{node_modules/*,.git/*}"'
  set grepprg=rg\ --vimgrep
endif

" Re-define the Rg command so that it considers hidden files
"
" Note that the use of "-uu" includes the hidden files
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -uu --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" --> Files matching search terms with either Ag or Rg
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" Use FZF to search through the TOC of a LaTeX document
nnoremap <leader>lf :call vimtex#fzf#run('ctli')<cr>

" Show the mappings that are currently available
nmap <leader><tab> <plug>(fzf--n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" }}}
