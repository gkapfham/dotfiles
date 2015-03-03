" Set Vim to run in not compatible mode
set nocompatible

call plug#begin('~/.vim/bundle')

" These are all of the Plugs that we use to enhance the behavior of Vim

" Plug 'https://github.com/ChrisYip/Better-CSS-Syntax-for-Vim.git'
" Plug 'https://github.com/bling/vim-bufferline.git'
" Plug 'https://github.com/tejr/nextag.git'
Plug 'https://github.com/FelikZ/ctrlp-py-matcher.git'
Plug 'https://github.com/Lokaltog/vim-easymotion.git'
Plug 'https://github.com/MarcWeber/vim-addon-mw-utils'
Plug 'https://github.com/Raimondi/delimitMate.git'
Plug 'https://github.com/SirVer/ultisnips.git'
Plug 'https://github.com/Valloric/ListToggle.git'
Plug 'https://github.com/Valloric/MatchTagAlways.git', {'for': 'html'}
Plug 'https://github.com/Valloric/YouCompleteMe.git'
Plug 'https://github.com/Z1MM32M4N/vim-superman.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/airblade/vim-rooter.git'
Plug 'https://github.com/amiorin/ctrlp-z.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/chrisbra/CheckAttach.git'
Plug 'https://github.com/chrisbra/csv.vim.git', {'for': 'csv'}
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'https://github.com/dterei/VimBookmarking.git'
Plug 'https://github.com/ervandew/ag.git'
Plug 'https://github.com/ervandew/supertab.git'
Plug 'https://github.com/freitass/todo.txt-vim.git'
Plug 'https://github.com/garbas/vim-snipmate'
Plug 'https://github.com/godlygeek/tabular.git'
Plug 'https://github.com/gorodinskiy/vim-coloresque.git'
Plug 'https://github.com/gregsexton/gitv.git'
Plug 'https://github.com/henrik/vim-qargs.git'
Plug 'https://github.com/honza/vim-snippets'
Plug 'https://github.com/int3/vim-extradite.git'
Plug 'https://github.com/ivalkeen/vim-ctrlp-tjump.git'
Plug 'https://github.com/jalvesaq/VimCom.git'
Plug 'https://github.com/jcfaria/Vim-R-plugin.git'
Plug 'https://github.com/jeetsukumaran/vim-filebeagle.git'
Plug 'https://github.com/jgdavey/tslime.vim.git'
Plug 'https://github.com/joeytwiddle/sexy_scroller.vim.git'
Plug 'https://github.com/justinmk/vim-sneak.git'
Plug 'https://github.com/kablamo/vim-git-log.git'
Plug 'https://github.com/kshenoy/vim-signature.git'
Plug 'https://github.com/lervag/vim-latex.git', {'for': 'tex'}
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/mattn/emmet-vim.git', {'for': 'html'}
Plug 'https://github.com/nathanaelkane/vim-indent-guides'
Plug 'https://github.com/scrooloose/syntastic.git'
Plug 'https://github.com/sgur/ctrlp-extensions.vim.git'
Plug 'https://github.com/sjl/gundo.vim.git', {'on': 'GundoToggle'}
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/tomtom/tlib_vim'
Plug 'https://github.com/tpope/vim-abolish.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-liquid.git'
Plug 'https://github.com/tpope/vim-ragtag.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-unimpaired.git'
Plug 'https://github.com/vim-scripts/AutoTag.git', {'for': 'html'}
Plug 'https://github.com/vim-scripts/HTML-AutoCloseTag.git', {'for': 'html'}
Plug 'https://github.com/vim-scripts/SyntaxAttr.vim.git'
Plug 'https://github.com/vim-scripts/TeX-9.git', {'for': 'tex'}
Plug 'https://github.com/wellle/tmux-complete.vim.git'
Plug 'https://github.com/xolox/vim-easytags.git'
Plug 'https://github.com/xolox/vim-misc.git'
call plug#end()

" Automatically identify the filetype for the plugins and always use syntax highlighting
filetype indent plugin on | syn on

" Set the completion function for a variety of different file types
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType tex set omnifunc=latex#complete#omnifunc

" Allow syntastic to populate a list of problems for a given file
let g:syntastic_always_populate_loc_list = 1

" Disable the arrow keys so that I keep my fingers on home row during programming
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Set the completion function in general if there is not a specific type
set omnifunc=syntaxcomplete#Complete

" Set the syntax for the todo file so that the file highlighting is correct
autocmd FileType todo set syntax=todo

" Set it so that the todo mode is always run when editing the file called todo.txt or Todo.txt
autocmd BufNewFile,BufRead [Tt]odo.txt set filetype=todo

" Set the syntax for the markdown files so that the file highlighting is correct
au BufRead,BufNewFile *.md set filetype=markdown

" Set indenting to work correctly for the HTML file type (may not be need now)
au BufRead,BufNewFile *.html set filetype=html
let g:html_indent_inctags = "html,body,head,tbody,div"

" Set it so that the CSV mode is always run when editing this type of file (does not autodetect?)
autocmd BufRead,BufNewFile *.csv,*.dat set filetype=csv

" Set up a dictionary so that I can do word completion by looking up words!
set dictionary-=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english

" Set the encoding to utf 8, the most common encoding used for text
set encoding=utf-8

" set the hybrid color scheme for vim running in the terminal window
" let g:hybrid_use_Xresources = 1
colorscheme hybrid

" define some commands for wrapping and not wrapping a line or paragraph
command Wrap set textwidth=120
command NoWrap set textwidth=0
command StandardWrap set textwidth=80

" set up vim so that it displays line numbers in a hybrid fashion
set relativenumber
set number

" tmux configuration
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

" Make sure that you can load the dot files when you are searching the file system
let g:ctrlp_show_hidden = 1

" Configure ctrlp so that it uses a faster matcher
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Ignore these directories in all programs like ctrlp
set wildignore+=*/build/**
set wildignore+=*/.git/*
set wildignore+=*.class
set wildignore+=*/tmp/*

" change the mapleader from \ to , -- this makes it easier to perform compilation in LaTeX
let maplocalleader=","
let mapleader=","

" Setting up SyncTex and compilation support for Tex-9
let g:tex_nine_config = {
            \'compiler': "latexmk",
            \'synctex': 1
            \}

" Adding in the conceal option for latex. Trying this out to see if I like the rendering of mathematics
set cole=2
let g:tex_conceal= 'adgms'
hi Conceal ctermbg=234 ctermfg=143

" Starting to use vim-latex and it needs several configurations to work correctly
let g:latex_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -shell-escape -synctex=1'"
let g:latex_fold_enabled = 0
let g:latex_quickfix_mode = 2
let g:latex_quickfix_open_on_warning = 1
let g:latex_toc_resize = 0
let g:latex_toc_hide_help = 1
let g:latex_indent_enabled = 1
let g:latex_latexmk_enabled = 1
let g:latex_latexmk_callback = 0

" Define a function that will insert the correct kind of quotation marks, but only in LaTeX documents
" Note that this then requires you to run a CTRL-V " to get a traditional quotation mark
fu! TexQuotes()
    let line = getline(".")
    let curpos = col(".")-1
    let insert = "''"

    let left = strpart(line, curpos-1, 1)
    if (left == ' ' || left == '        ' || left == '')
        let insert = '``'
    endif
    return insert
endfu
autocmd FileType tex imap " <c-r>=TexQuotes()<cr>

" Turn on smart indentation with the Latex plugins, nice and very helpful
set smartindent

" " Commands that allow for the invocation of the SyncTex support
nmap <C-LeftMouse> :call tex_nine#ForwardSearch()<CR>
nmap <C-l> :call tex_nine#ForwardSearch()<CR>

" Configure completion (and thus SuperTab so that it include the dictionary in the p and n completion type)
" set complete=.,b,u,]
set complete-=k complete+=k
set complete+=kspell
set complete+=]

" " This is the default context completion that will be used if there is not a separate autocommand configuration
" " let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabContextDefaultCompletionType = "<c-n>"
" let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
" let g:SuperTabDefaultCompletionType = "context"
" let g:SuperTabLongestEnhanced = 1

" You Complete Me configuration for LaTeX, using the vim-latex plugin
" Note that the last one does not work correctly even though I think that
" it should! An alternative is to type ctrl-space for the second reference and
" this will ensure that I can still search through for references
let g:ycm_semantic_triggers = {
\  'tex'  : ['\cite{', '\ref{', '!re\\cite([^]]*\])?\{([^}]*,)*[^}]*'],
\ }

" You Complete Me configuration
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'qf' : 1,
        \ 'notes' : 1,
        \ 'unite' : 1,
        \ 'text' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \}

" make YCM compatible with UltiSnips
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsListSnippets = "<C-l>"
let g:UltiSnipsJumpBackwardTrigger=""

" make YCM compatible with the tmux-complete
let g:tmuxcomplete#trigger = 'omnifunc'

" allow CTRLP to show fifteen total matches, helping in cases where there are
" many matches that we still want to display and consider
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:15'
let g:ctrlp_extensions = ['buffertag', 'quickfix']

" This allows you to jump to the definition of a function using CtrlP
nnoremap <c-]> :CtrlPtjump<cr>
vnoremap <c-]> :CtrlPtjumpVisual<cr>

" Very exciting, this allows for Ctrl-P to automatically generate tags for LaTeX using e-ctags
let g:ctrlp_buftag_types = {
    \ 'tex'          : '--language-force=latex'
\ }

" let g:ctrlp_buftag_types = {
" \ 'go'           : '--language-force=go --golang-types=ftv',
" \ 'coffee'     : '--language-force=coffee --coffee-types=cmfvf',
" \ 'markdown'   : '--language-force=markdown --markdown-types=hik',
" \ 'objc'       : '--language-force=objc --objc-types=mpci',
" \ 'rc'         : '--language-force=rust --rust-types=fTm',
" \ 'r'          : '--language-force=r --r-types=fgv'
" \ }

" let g:ycm_key_list_previous_completion=[]
" let g:ycm_key_list_select_completion=[]
" let g:SuperTabDefaultCompletionType = '<C-Tab>'
" let g:ycm_key_list_previous_completion = ['<C-S-Tab>', '<Up>']
" let g:ycm_key_list_select_completion = ['<C-Tab>', '<Down>']

" Java autocompletion must use the completefunc (ctrl-x ctrl-u) to work correctly, so set it separately
" autocmd FileType java let g:SuperTabDefaultCompletionType = "context"
" autocmd FileType java let g:SuperTabContextDefaultCompletionType = "<c-n>"
" autocmd FileType java let g:SuperTabContextTextOmniPrecedence = ['&completefunc', '&omnifunc']

" note that menu provides a substantially better configuration for viewing the autocompletion output that is available
" in gvim
set cot=menu
set completeopt=longest,menuone

" start using the wildmenu to complete different commands in command-mode
set wildmenu
set wildmode=longest:full,full

" Adding in a bunch of additional commands from:
" http://nvie.com/posts/how-i-boosted-my-vim/

set nowrap        " don't wrap lines
set wrap          " go ahead and allow the wrapping of long lines to take place
set linebreak     " make sure that you break the lines in a way that preserves words
set showbreak=━━  " set an ellipse character so that you can tell when lines are wrapped
set tabstop=4     " a tab is four spaces
set expandtab    " insert spaces whenever the tab key is pressed, helps with formatting Java code
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set infercase     " predict the case that is needed when doing auto completion
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set incsearch     " show search matches as you type
set history=1000  " remember more commands and search history
set undolevels=1000 " use many muchos levels of undo
set pastetoggle=<F2> " allow vim to paste a large amount of source code or tex
set timeout timeoutlen=1000 ttimeoutlen=10 " make the escape key function faster in the terminal window
set whichwrap+=<,>,h,l,[,] " wrap when you get to the end of a line and you are using the arrow keys
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. "highlight problematic whitespace
set list " also required to ensure that problematic whitespace is highlighted correctly

" turn on spell checking so that I can do this for Latex documents
set spell spelllang=en_us,en_gb
set mousemodel=popup

" turn of spell checking for some types of buffers, mostly Java and other programming languages
au BufNewFile,BufRead,BufEnter *.c      set nospell
au BufNewFile,BufRead,BufEnter *.h      set nospell
au BufNewFile,BufRead,BufEnter *.cpp    set nospell
au BufNewFile,BufRead,BufEnter *.hpp    set nospell
au BufNewFile,BufRead,BufEnter *.java   set nospell
au BufNewFile,BufRead,BufEnter *.sh     set nospell
au BufNewFile,BufRead,BufEnter *.xml    set nospell
au BufNewFile,BufRead,BufEnter *.sql    set nospell
au BufNewFile,BufRead,BufEnter *.bib    set nospell

" Allow spelling to be easily toggled on and off
nmap <silent> <leader>s :set spell!<CR>

" Give a special key for turning on and off the Tagbar, a great feature for browsing source code, such as Java programs
nmap <F12> :TagbarToggle<CR>

" Configure the Tagbar so that it can handle the Markdown language
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
\ }

" Configure the Tagbar so that it can handle the R language
let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
    \ ]
\ }

" Configure the Tagbar so that it can handle the UltiSnips format
let g:tagbar_type_snippets = {
    \ 'ctagstype' : 'snippets',
    \ 'kinds' : [
        \ 's:snippets',
    \ ]
\ }

" Configure the Tagbar so that it can handle the CSS format
let g:tagbar_type_css = {
\ 'ctagstype' : 'Css',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 's:selectors',
        \ 'i:identities'
    \ ]
\ }

" " Give a special key for turning on and off the NERDTree, a great feature for browsing the entire file system
" nmap <F11> :NERDTreeToggle<CR>
" " Set up the NERDTree so that it does not display the silly help message at the top, this is not minimal enough.
" let NERDTreeMinimalUI=1
" " Always show the hidden files inside of the NerdTree
" let NERDTreeShowHidden=1

" Stop vim from redrawing the screen during complex operations, supposed to make the user interface much smoother, let's try!
" set lazyredraw
" set synmaxcol=145
" syntax sync minlines=256
set nocursorcolumn
set nocursorline
set ttyfast

" Make the source code history browsing feature open windows horizontally, as this supports better browsing
let g:Gitv_OpenHorizontal=1

" Do not display the welcome message / splash screen when opening gvim or vim
" with no specified file
set shortmess=I

" Set up the enter key to ensure that after completing words a return is not pressed; this was all used with the
" standard SuperTab completion and now I am leaving it even though I primarily use YouCompleteMe

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
            \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <tab> pumvisible() ? '<tab>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Configure the airline status bar replacement that provides some delightful context
set laststatus=2
let g:airline_theme='tomorrow'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
set nosmd " turn of the status line that shows the silly word insert, airline is much better!

" Configure the way that colors are displayed for the sneak feature of searching in the text, seems to work very nicely
" let g:sneak#streak = 1
hi link SneakPluginScope Visual
hi link SneakPluginTarget Type

"replace 'f' with 1-char Sneak
    nmap f <Plug>Sneak_f
    nmap F <Plug>Sneak_F
    xmap f <Plug>Sneak_f
    xmap F <Plug>Sneak_F
    omap f <Plug>Sneak_f
    omap F <Plug>Sneak_F
    "replace 't' with 1-char Sneak
    nmap t <Plug>Sneak_t
    nmap T <Plug>Sneak_T
    xmap t <Plug>Sneak_t
    xmap T <Plug>Sneak_T
    omap t <Plug>Sneak_t
    omap T <Plug>Sneak_T

" map <Leader> <Plug>(easymotion-prefix)
" nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" change the default EasyMotion shading to something more readable
hi link EasyMotionTarget Type
hi link EasyMotionShade Comment
hi link EasyMotionIncSearch Type
hi link EasyMotionIncCursor Type
hi link EasyMotionMoveHL Type

" Don't create the shaded background ; seems the better choice, but not perfect
let g:EasyMotion_do_shade = 0

" Tell EasyMotion to use capital letter since these are easier to see
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;'

" Configure scrolling in the window; breaks with the mouse flick but fine with the keyboard
let g:SexyScroller_MaxTime = 500
let g:SexyScroller_EasingStyle = 3

" Configuring the EasyTags and Ctrl-P plugins to better support tag creation and browsing and good syntax highlighting
set tags=./tags;
let g:easytags_ignored_filetypes = ''
let g:easytags_dynamic_files = 1
let g:easytags_updatetime_warn = 0
let g:easytags_always_enabled = 1
let g:easytags_async = 1
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_use_caching = 0
let g:ctrlp_z_nerdtree = 1
" let g:ctrlp_cmd = 'CtrlPBuffer'

" I could not get this to work as a CTRL-P extension, so I had to map to separate commands, which does seem to work
nnoremap zd :CtrlPZ<Cr>
nnoremap zf :CtrlPF<Cr>
nnoremap <Tab> :CtrlPBuffer<Cr>

" Set a command that allows for the creation of a tags file for exuberant ctags
nmap <C-t> :!ctags -R<CR>

" Define a function that allows you to determine what syntax group is being used
map <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F5> :call SyntaxAttr()<CR>

" I am not using GitGutter in the signs column because I don't like the slight delay;
" but, I am using it to display information inside of the Airline at the bottom of Vim
let g:gitgutter_signs = 0
" let g:gitgutter_sign_column_always = 1

" adding in some extra features for the GitGutter, let's see if this works correctly
" let g:gitgutter_realtime = 1
" let g:gitgutter_eager = 1

" Automatically save changes before switching buffer with some
" commands, like :cnfile. Very useful when running Qdo on a QuickFix list
set autowrite

" However, if you follow the Java guidelines about how functions and classes are
" supposed to be named (with respect to upper and lowercase), use >
" Basically, make the syntax highlighting for method declarations a lot better
" let java_highlight_functions="indent"
let java_highlight_functions="style"

" Configure a different indenting plugin that has smooth lines
" let g:indent_guides_soft_pattern = ' '
" let g:indent_guides_space_guides = 1
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=1

" An extra configuration to handle the use of the indent guides when running GVim
if !has("gui_running")
    let g:indent_guides_auto_colors = 0
    hi IndentGuidesEven ctermbg=darkgrey
endif

" Make a separate key binding that allows for the toggling of the indent guides
nmap <Leader>g :IndentGuidesToggle<CR>

" " Add in the path to the WordNet binary, allowing for a <Leader>wnd command to easily run
" let g:wordnet_path = "/usr/bin/"
" nmap <Leader>wnd "wyiw:call WordNetOverviews(@w)<CR>

" Call the GUndo plugin Toggle to see the version history with the F5 key
nnoremap <F6> :GundoToggle<CR>
let g:gundo_help=0

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Create a mapping that allows for the insertion of a blank line without
" having to enter insert mode and then leave it. Works nicely, but only in GVim
nmap <S-Enter> O<Esc>
nmap oo O<Esc>

" This function will allow you to rename a file inside of vim, works correctly
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>m :call RenameFile()<cr>

" Allow the Vim-R-Plugin to create the R assignment, but only with two
" underscore presses when writing code in Vim
let vimrplugin_assign = 2

" Add in a command that will allow me to remove the trailing white space
nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

let g:checkattach_filebrowser = 'ranger'
let g:checkattach_once = 'y'
