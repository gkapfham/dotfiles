" Display Improvements {{{

" Display italics in terminal
set t_ZH=[3m
set t_ZR=[23m

" Do not display messages
set shortmess=FIWacto
set confirm

" Display line wraps
command! Wrap set textwidth=120
command! NoWrap set textwidth=0
command! StandardWrap set textwidth=80
set wrap linebreak nolist

" Display of line numbers
set number
set relativenumber

" Display screen redraws faster
set nocursorcolumn
set nocursorline
set ttyfast

" Disable these commands to improve
" screen performance in Neovim
set noshowcmd noruler

" Display linebreaks and tabs
set linebreak
set showbreak=━━
set breakindent
set tabstop=4

" Insert spaces for tab
set expandtab
set smarttab
set shiftround

" Display problematic whitespace
set listchars=tab:▸▹,trail:•,extends:#,precedes:#,nbsp:⌻
set list

" Display with faster timeouts in the TUI
"
" Setting also influences how quickly the
" WhichKey menu will appear with hints
set timeoutlen=500
set ttimeoutlen=10

" Display indentation
set autoindent
set copyindent
set shiftwidth=2
set smartindent

" Display goes to the next line
set whichwrap+=<,>,h,l,[,]

" Do not display spaces at end of line
set nojoinspaces

" Display the location list and quickfix window
let g:lt_location_list_toggle_map = '<leader>c'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Do not display the standard status line
set noshowmode

" Display the sign column for version control
set signcolumn=yes

" Configure how quickly interface updates
set updatetime = 100

" Work around a defect in Neovim for interface updates
let g:cursorhold_updatetime = 100

" Configure the display of parentheses matching
let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
let g:mta_filetypes = {
      \ 'html' : 1,
      \ 'xhtml' : 1,
      \ 'xml' : 1,
      \ 'jinja' : 1,
      \ 'liquid' : 1,
      \}

" Display the syntax group for the symbol under the cursor
map <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F5> :call SyntaxAttr() <CR>

" Do not display the match of an offscreen delimiter
let g:matchup_matchparen_status_offscreen = 0

" Configure the matchup plugin to override defaults in vimtex
let g:matchup_override_vimtex = 1

" Enable the Lua-based color highlighter for all filetypes
lua require'colorizer'.setup()

" Briefly highlight the yanked region using the background color for visual highlights
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=150}
augroup END

" }}}

