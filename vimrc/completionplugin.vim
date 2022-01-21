" Completion with UltiSnips, Coq.nvim, and Wilder.nvim {{{

" Completion engine is compatible with UltiSnips
let g:UltiSnipsExpandTrigger='<C-s>'
let g:UltiSnipsJumpForwardTrigger='<C-s>'
let g:UltiSnipsJumpBackwardTrigger='<C-j>'

" Always start coq.nvim when entering buffer
autocmd VimEnter * COQnow --shut-up

" Disable the default coq.nvim keybindings
let g:coq_settings = { 'keymap.recommended': v:false }

" Specify customized coq.nvim settings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

" Additional coq.nvim settings
let g:coq_settings = {"display.pum.source_context" : ["  ", " "], "display.pum.kind_context" : [" ", " "], 'auto_start': 'shut-up'}

" Basic configuration for the wilder.nvim plugin
" that makes searching in the wildmenu possible
call wilder#setup({'modes': [':', '/', '?']})

" Configure the wilder.nvim so that it supports
" the theme from the lightline and renders in it;
" this means that the completion items render in
" the lightline at the bottom of the screen. Nice!
call wilder#set_option('renderer', wilder#wildmenu_renderer(
      \ wilder#wildmenu_lightline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': ' · ',
      \ })))

" }}}
