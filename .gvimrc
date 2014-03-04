" Always use syntax highlighting.
syntax on

" pick one of the color schemes that is available for use; I customized hybrid further
colorscheme hybrid 

" pick the Monaco font at size 11, note that it might not be installed, then the default looks bad, go to Ubuntu Mono then
set guifont=Ubuntu\ Mono\ 13  

" define a function that will maximize the window to full screen; only works on Ubuntu when the wmctrl program is installed
function Maximize_Window()
  silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction

" when the GUI is running, that is GVim is being used, then we should call the maximization function
au GUIEnter * call Maximize_Window()

" remove the right side and left side scroll bar, which is not really needed in Gvim, more of a minimal look this way
set guioptions-=r
set guioptions-=L

" Configure the airline status bar replacement that provides some delightful context 
" set laststatus=2
" let g:airline_theme='base16'
" let g:airline_powerline_fonts = 1
" let g:airline_detect_whitespace=0
" 
