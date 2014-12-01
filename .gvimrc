" Always use syntax highlighting.
syntax on

" pick one of the color schemes that is available for use; I customized hybrid further
colorscheme hybrid 

" pick the Monaco font at size 11, note that it might not be installed, then the default looks bad, go to Ubuntu Mono then
" set guifont=Ubuntu\ Mono\ 13  
set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 13 

" define a function that will maximize the window to full screen; only works on Ubuntu when the wmctrl program is installed
function Maximize_Window()
  silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction

" when the GUI is running, that is GVim is being used, then we should call the maximization function
" In Ubuntu 14.04, this cases the terminal to maximize sometimes, creating problems. Now, I am using
" the Compiz Place Windows plugin to achieve the same functionality, and it seems to be faster.
" au GUIEnter * call Maximize_Window()

" remove the right side and left side scroll bar, which is not really needed in Gvim, more of a minimal look this way
set guioptions-=r
set guioptions-=L

" Remove the toolbar at the top of the page so that the extra icons are not visible, more minimal again
set guioptions-=T 

" set up vim so that it displays line numbers in a hybrid fashion
" set relativenumber 
" set number

" Configure the airline status bar replacement that provides some delightful context 
" set laststatus=2
" let g:airline_theme='base16'
" let g:airline_powerline_fonts = 1
" let g:airline_detect_whitespace=0
" 
