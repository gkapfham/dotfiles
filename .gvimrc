syntax on
" colorscheme darkspectrum
colorscheme hybrid
set guifont=Monaco\ 11  
function Maximize_Window()
  silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction
au GUIEnter * call Maximize_Window()

" Configure the airline status bar replacement that provides some delightful context 
" set laststatus=2
" let g:airline_theme='base16'
" let g:airline_powerline_fonts = 1
" let g:airline_detect_whitespace=0
" 
