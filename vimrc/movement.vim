" Keyboard Movement {{{

" Disable the arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap jk <ESC>
inoremap <ESC> <NOP>

" Define the leaders
let maplocalleader=','
let mapleader=','

" Move through CamelCase text
" call camelcasemotion#CreateMotionMappings('<leader>')

" Navigate through wrapped text
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Navigate to the next linting warning/error
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Quickly switch between two recent buffers
function! SwitchBuffer()
  b#
endfunction
" Use either control or space to activate
nmap <C-u> :call SwitchBuffer()<CR>
nmap <Space>u :call SwitchBuffer()<CR>

" Define <leader<leader> to create a colon in both
" normal mode and visual mode, thereby avoiding
" the need to frequently type the shift key
nnoremap <leader><leader> :
vnoremap <leader><leader> :

" }}}
