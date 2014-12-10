" Set Vim to run in not compatible mode
set nocompatible 

" Setting up Vundle -- the vim plugin bundler -- and another plugin management tool that I will demonstrate
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" These are all of the Bundles that we use to enhance the behavior of Vim
Bundle 'https://github.com/ChrisYip/Better-CSS-Syntax-for-Vim.git'
Bundle 'https://github.com/Lokaltog/vim-easymotion.git'
Bundle 'https://github.com/MarcWeber/vim-addon-mw-utils'
Bundle 'https://github.com/Raimondi/delimitMate.git'
Bundle 'https://github.com/SirVer/ultisnips.git'
Bundle 'https://github.com/Valloric/ListToggle.git'
Bundle 'https://github.com/Valloric/MatchTagAlways.git'
Bundle 'https://github.com/Valloric/YouCompleteMe.git'
Bundle 'https://github.com/Wolfy87/vim-enmasse.git'
Bundle 'https://github.com/airblade/vim-gitgutter.git'
Bundle 'https://github.com/amiorin/ctrlp-z.git'
Bundle 'https://github.com/bling/vim-airline.git'
Bundle 'https://github.com/chrisbra/csv.vim.git'
Bundle 'https://github.com/dterei/VimBookmarking.git'
Bundle 'https://github.com/ervandew/ag.git'
Bundle 'https://github.com/ervandew/supertab.git'
Bundle 'https://github.com/freitass/todo.txt-vim.git'
Bundle 'https://github.com/garbas/vim-snipmate'
Bundle 'https://github.com/godlygeek/tabular.git'
Bundle 'https://github.com/gorodinskiy/vim-coloresque.git'
Bundle 'https://github.com/gregsexton/gitv.git'
Bundle 'https://github.com/henrik/vim-qargs.git'
Bundle 'https://github.com/honza/vim-snippets'
Bundle 'https://github.com/int3/vim-extradite.git'
Bundle 'https://github.com/joeytwiddle/sexy_scroller.vim.git'
Bundle 'https://github.com/justinmk/vim-sneak.git'
Bundle 'https://github.com/kablamo/vim-git-log.git'
Bundle 'https://github.com/kien/ctrlp.vim.git'
Bundle 'https://github.com/kshenoy/vim-signature.git'
Bundle 'https://github.com/lervag/vim-latex.git'
Bundle 'https://github.com/majutsushi/tagbar'
Bundle 'https://github.com/mattn/emmet-vim.git'
Bundle 'https://github.com/nathanaelkane/vim-indent-guides'
Bundle 'https://github.com/osyo-manga/vim-over.git'
Bundle 'https://github.com/scrooloose/nerdtree.git'
Bundle 'https://github.com/sjl/gundo.vim.git'
Bundle 'https://github.com/tejr/nextag.git'
Bundle 'https://github.com/terryma/vim-multiple-cursors.git'
Bundle 'https://github.com/tomtom/tlib_vim'
Bundle 'https://github.com/tpope/vim-abolish.git'
Bundle 'https://github.com/tpope/vim-commentary.git'
Bundle 'https://github.com/tpope/vim-fugitive.git'
Bundle 'https://github.com/tpope/vim-liquid.git'
Bundle 'https://github.com/tpope/vim-ragtag.git'
Bundle 'https://github.com/tpope/vim-surround.git'
Bundle 'https://github.com/tpope/vim-unimpaired.git'
Bundle 'https://github.com/tsaleh/vim-matchit.git'
Bundle 'https://github.com/vim-scripts/AutoTag.git'
Bundle 'https://github.com/vim-scripts/HTML-AutoCloseTag.git'
Bundle 'https://github.com/vim-scripts/SQLComplete.vim.git'
Bundle 'https://github.com/vim-scripts/SyntaxAttr.vim.git' 
Bundle 'https://github.com/vim-scripts/TeX-9.git'
Bundle 'https://github.com/xolox/vim-easytags.git'
Bundle 'https://github.com/xolox/vim-misc.git'
Bundle 'https://github.com/jgdavey/tslime.vim.git'
Bundle 'https://github.com/wellle/tmux-complete.vim.git'
Bundle 'https://github.com/FelikZ/ctrlp-py-matcher.git'
Bundle 'https://github.com/airblade/vim-rooter.git'

" Install all of the bundles that are not already installed
if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif

" Automatically identify the filetype for the plugins and always use syntax highlighting
filetype indent plugin on | syn on

" Set the completion function for a variety of different file types
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType tex set omnifunc=latex#complete#omnifunc 

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

" Starting to use vim-latex and it needs several configurations to work correctly
let g:latex_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -synctex=1'"
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
let g:ycm_semantic_triggers = {
\  'tex'  : ['\cite{', '\ref{'],
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

" set up some commands for adding, removing, and navigating bookmarks inside of vim; very useful
" map <silent> bb :ToggleBookmark<CR>
" map <silent> bn :NextBookmark<CR>
" map <silent> bp :PreviousBookmark<CR>

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

" Give a special key for turning on and off the NERDTree, a great feature for browsing the entire file system
nmap <F11> :NERDTreeToggle<CR>

" Set up the NERDTree so that it does not display the silly help message at the top, this is not minimal enough.
let NERDTreeMinimalUI=1

" Always show the hidden files inside of the NerdTree
let NERDTreeShowHidden=1

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
let g:airline_theme='base16'
let g:airline_powerline_fonts = 1
let g:airline_detect_whitespace=0
set nosmd " turn of the status line that shows the silly word insert, airline is much better!

" Configure the way that colors are displayed for the sneak feature of searching in the text, seems to work very nicely
" let g:sneak#streak = 1
hi link SneakPluginScope Visual
hi link SneakPluginTarget Type 

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
let g:SexyScroller_MaxTime = 250 
let g:SexyScroller_EasingStyle = 0

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

" I could not get this to work as a CTRL-P extension, so I had to map to separate commands, which does seem to work
nnoremap zd :CtrlPZ<Cr>
nnoremap zf :CtrlPF<Cr> 

" Set a command that allows for the creation of a tags file for exuberant ctags
nmap <C-t> :!ctags -R<CR>

" Define a function that allows you to determine what syntax group is being used
map <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F5> :call SyntaxAttr()<CR>

" " HTML needs to have a chained completion function 
" autocmd FileType html
"             \ if &omnifunc != '' |
"             \   call SuperTabChain(&omnifunc, "<c-n>") |
"             \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
"             \ endif

" " HTML needs to have a chained completion function 
" autocmd FileType mail 
"             \ if &omnifunc != '' |
"             \   call SuperTabChain(&omnifunc, "<c-n>") |
"             \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
"             \ endif

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

" Add in the path to the WordNet binary, allowing for a <Leader>wnd command to easily run
let g:wordnet_path = "/usr/bin/"
nmap <Leader>wnd "wyiw:call WordNetOverviews(@w)<CR>

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

" Configure the identing line plugin so that it will use the correct colors and symbols ; deprecated
" let g:indentLine_color_term = 239
" let g:indentLine_color_gui = "#707880"
" let g:indentLine_char = '│'

" Control how the delimitmate handles the return character, does not seem to work correctly
" IMPORTANT NOTE: Adding the first line will cause tab completion with supertab not to work correctly
" let delimitMate_expand_cr = 2
" let delimitMate_expand_space = 1

" Do not go to the next line with a comment when you press enter
" set formatoptions-=or

" No longer needed because the new latex plugin does this correctly for you
" autocmd FileType tex set omnifunc=latex#complete

" Configure the Calendar plugin so that it can access the Google calendar, nice for viewing your schedule
" let g:calendar_google_calendar = 1
" 
" let g:ctrlp_extensions = ['funky', 'tag', 'buffertag', 'F']
" let g:ctrlp_extensions = ['Z', 'F']
" let g:ctrlp_extensions = ['F']
" let g:ctrlp_funky_syntax_highlight = 1

" let g:ycm_complete_in_comments = 1
" let g:ycm_collect_identifiers_from_comments_and_strings = 1
" let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_seed_identifiers_with_syntax = 1
" let g:ycm_cache_omnifunc = 1
" 
" Extra code that is not needed or did not work correctly.

" autocmd FileType html set omnifunc=emmet#completeTag 

" " Commands that allow for the invocation of the SyncTex support
" noremap <buffer><silent> <C-LeftMouse> :call tex_nine#ForwardSearch()<CR>
" noremap <buffer><silent> <C-l> :call tex_nine#ForwardSearch()<CR>

" Start interactive EasyAlign in visual mode
" vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
" nmap <Leader>a <Plug>(EasyAlign)

" Configure the SingleCompile plugin so that 
" map <Leader>c :SCCompile<cr>
" nmap <Leader>e :SCCompileRun<cr>

" This will not work because of the fact that I have to press enter in the
" quick fix window to go to the entry! 
" nmap <CR> o<Esc>

" let g:user_emmet_complete_tag = 1
" let g:user_emmet_mode='a'    "enable all function in all mode.
" imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
" let g:user_emmet_expandabbr_key = '<Tab>'
" let g:use_emmet_complete_tag = 1
" let user_emmet_expandabbr_key = '<c-y>'
" let g:user_emmet_expandabbr_key = '<Leader>e'

" The Silver Searcher -- could not get it to work in the past, it is fine, I
" think, now
" if executable('ag')
"     " Use ag over grep
"     set grepprg=ag\ --nogroup\ --nocolor
" 
"     " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
"     " let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
" 
"     " ag is fast enough that CtrlP doesn't need to cache
"     let g:ctrlp_use_caching = 0
" endif
" 
" autocmd BufRead java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
" autocmd BufRead java set makeprg=ant\ -find\ build.xml compile
" 
" 2>&1| tee /tmp/llv4iZDP3/24

" autocmd BufRead *.java set makeprg=ant\ -find\ build.xml compile

" !ant -find build.xml compile 2>&1| tee /tmp/vO3vLMp/32
" map gqb vip:join<CR>0:call SplitLineBySentence()<CR>

" nmap gqb vip:s/\./\./ 

" map <Leader>bs vap::s/\./\./

" Define function (! means it will redefine it if it exists)
" function! SplitLineBySentence()
"      " Set variables to hold current cursor line and column
"      let lastline=line('.')
"      let lastcol=col('.')
"      " Run normal command ) that moves to end of paragraph
"      normal )
"      " while the current column has changed, but not the line, and the cursor
"      " is not on the last character of the line (nor beyond it)...
" 
"      while lastline==line('.') && lastcol!=col('.') && col('.')<col('$')-1
"         " ':execute" the following expression as a command...
"         " :normal -- run normal mode commands
"         " h -- cursor left
"         " viw -- visually select inner word (actually selects the whitespace)
"         " s -- change character normal mode command...like 'cl'
"         " \<CR> -- Enter. \< inside double quotes is used to include special
"         " characters in a string.
"         " \<Esc> -- Escape. To exit insert mode (that 's' puts us into)
" 
" 		exe "normal hvi\<CR>\<Esc>"
"         " We are on a new line now, so update the variables
" 
"         let lastline=line('.')
"         let lastcol=col('.')
"         normal )
"      endwhile
"      " normal mode {+ -- move to previous paragraph then down one line
"      normal {+
" endfunction
" 
" Indicate that a file with the quicktask extension should always put us into QuickTask mode for editing task listings
" autocmd BufNewFile,BufRead todo.txt setf todo.txt

" We want to use next word tab completion for email and then use the dictionary otherwise. Testing now, seems fine.
" autocmd FileType mail let g:SuperTabDefaultCompletionType = "<c-x><c-n>"
" autocmd FileType mail let g:SuperTabContextDefaultCompletionType = "<c-x><c-k>"

" It turns out that Java tab completion works correctly without using something special, so this is not needed
" autocmd FileType java let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
" This is a nice feature, but it takes to long for the screen to redraw when using it
" set relativenumber 

" ULtimately, I decided that it was better for us to not use this feature by default
"set hidden        " allow a new buffer to be opened even if current one is not saved

" Adding in a command that will open up the :MarksBrowser easily
" nmap <C-m> :MarksBrowser<CR>

" set the status line to contain additional information (displayed during
" save, etc)
" set statusline=%F\ %m\ %{fugitive#statusline()}\ %y%=%l,%c\ %P

" This plugin seems to cause screen redraws to progress slowly, so I am no longer using it
" let g:gitgutter_sign_column_always=1

" " some additional settings for the use of CTRLP -- I found that there was an
" easier and better way to do this and thus I no longer need these code segments
" runtime! plugin/ctrlp.vim
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\.git/|\bin/|\build/|/tmp/',
"   \ 'file': '\.*$\'
"   \ }
"

" extra commands that are not needed for CTRLP and reloading the vimrc file

" set wildignore+=*/bin/**

"set wildignore+=.*
" do not use a cache for ctrlp
"let g:ctrlp_use_caching = 0
"let g:ctrlp_dotfiles = 0

" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\.git$\|\build$\|\bin$\|\tmp$',
"   \ }
" 
" seems to do kinda strange things, but it works, unsafe for right now.

" command Reload :so! $MYVIMRC

" These features are no longer needed with the current configuration of eclim in Vim
" disable the extra menu at the top of the screen in eclim autocomplete
" this makes it significantly faster to display autocompletions in gvim!

" this flag enables you to open other files even if the current one is not
" saved this is a very important feature for me to use regularly

"set cot-=preview

" Bundle 'L9'
" Bundle 'https://github.com/Chiel92/vim-autoformat.git'
" Bundle 'https://github.com/Keithbsmiley/investigate.vim.git'
" Bundle 'https://github.com/LaTeX-Box-Team/LaTeX-Box.git'
" Bundle 'https://github.com/Lokaltog/vim-easymotion'
" Bundle 'https://github.com/Rykka/colorv.vim.git'
" Bundle 'https://github.com/Shougo/neocomplcache.vim.git'
" Bundle 'https://github.com/Shougo/neocomplete.vim.git'
" Bundle 'https://github.com/Townk/vim-autoclose.git'
" Bundle 'https://github.com/Yggdroot/indentLine.git'
" Bundle 'https://github.com/aaronbieber/quicktask.git'
" Bundle 'https://github.com/airblade/vim-gitgutter.git'
" Bundle 'https://github.com/altercation/vim-colors-solarized.git'
" Bundle 'https://github.com/ap/vim-css-color.git'
" Bundle 'https://github.com/coot/atp_vim.git'
" Bundle 'https://github.com/edkolev/tmuxline.vim.git'
" Bundle 'https://github.com/flazz/vim-colorschemes.git'
" Bundle 'https://github.com/gabrielelana/vim-markdown.git'
" Bundle 'https://github.com/garbas/vim-snipmate'
" Bundle 'https://github.com/gcmt/tag-surfer.git'
" Bundle 'https://github.com/gcmt/wildfire.vim.git'
" Bundle 'https://github.com/gerw/vim-latex-suite.git'
" Bundle 'https://github.com/goldfeld/vim-seek.git'
" Bundle 'https://github.com/gorodinskiy/vim-coloresque.git'
" Bundle 'https://github.com/gorodinskiy/vim-coloresque.git'
" Bundle 'https://github.com/guns/xterm-color-table.vim.git'
" Bundle 'https://github.com/hlissner/vim-multiedit.git'
" Bundle 'https://github.com/honza/vim-snippets'
" Bundle 'https://github.com/itchyny/calendar.vim.git'
" Bundle 'https://github.com/jcf/vim-latex.git'
" Bundle 'https://github.com/jeetsukumaran/vim-markology.git'
" Bundle 'https://github.com/junegunn/vim-easy-align.git'
" Bundle 'https://github.com/kshenoy/vim-signature.git'
" Bundle 'https://github.com/mbadran/headlights.git'
" Bundle 'https://github.com/mhinz/vim-signify.git'
" Bundle 'https://github.com/mhinz/vim-startify.git'
" Bundle 'https://github.com/michalliu/jsoncodecs.vim.git'
" Bundle 'https://github.com/michalliu/jsruntime.vim.git'
" Bundle 'https://github.com/michalliu/sourceeautify.vim.git'
" Bundle 'https://github.com/milkypostman/vim-togglelist.git'
" Bundle 'https://github.com/othree/vim-autocomplpop.git'
" Bundle 'https://github.com/reedes/vim-wordy.git'
" Bundle 'https://github.com/rking/ag.vim.git'
" Bundle 'https://github.com/rking/vim-detailed.git'
" Bundle 'https://github.com/scrooloose/syntastic.git'
" Bundle 'https://github.com/skammer/vim-css-color.git'
" Bundle 'https://github.com/skammer/vim-css-color.git'
" Bundle 'https://github.com/skroll/vim-taghighlight.git'
" Bundle 'https://github.com/tacahiroy/ctrlp-funky.git'
" Bundle 'https://github.com/taiansu/nerdtree-ag.git'
" Bundle 'https://github.com/timcharper/wordnet.vim.git'
" Bundle 'https://github.com/tommcdo/vim-lion.git'
" Bundle 'https://github.com/tomtom/tcomment_vim.git'
" Bundle 'https://github.com/tpope/vim-git.git'
" Bundle 'https://github.com/tpope/vim-markdown.git'
" Bundle 'https://github.com/vim-scripts/CSApprox.git'
" Bundle 'https://github.com/vim-scripts/Marks-Browser.git'
" Bundle 'https://github.com/vim-scripts/Xoria256m.git'
" Bundle 'https://github.com/vim-scripts/colorsupport.vim.git' 
" Bundle 'https://github.com/vim-scripts/csv.vim.git'
" Bundle 'https://github.com/vim-scripts/dbext.vim.git'
" Bundle 'https://github.com/vim-scripts/tComment.git'
" Bundle 'https://github.com/vim-scripts/taglist.vim.git'
" Bundle 'https://github.com/w0ng/vim-hybrid.git'
" Bundle 'https://github.com/xolox/vim-session.git'
" Bundle 'https://github.com/xuhdev/SingleCompile.git'
" Bundle 'https://github.com/yuratomo/gmail.vim.git'
" Various vim plugins that did not work the way that I wanted them to, discarding for now

" " Configuration for the Tabularize program to work on the = and : for tabularization
" if exists(":Tabularize")
"     nmap <Leader>a= :Tabularize /=<CR>
"     vmap <Leader>a= :Tabularize /=<CR>
"     nmap <Leader>a: :Tabularize /:\zs<CR>
"     vmap <Leader>a: :Tabularize /:\zs<CR>
" endif

" Configuration for the Autoformat program that will make HMTL, CSS, many others format correctly
" nmap <Leader>f :Autoformat<CR><CR>

" We want to use special tab completion for the plugins that are available for LaTeX. Tested and works very well.
" autocmd FileType tex let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" autocmd FileType todo let g:SuperTabDefaultCompletionType = "<c-n>"

" do not prompt to save for the session management each time
" let g:session_autosave = 'no'
" to use the sessions program, you need to uncomment this line and change it to something in your home account
" let g:session_directory = '/home/gkapfham/.vim/sessions'
" database connections for work with SchemaAnalyst and different database applications (e.g., TweetComplete) 

" " This is the extra line of code that the Tagbar needs to get LaTeX outlines to work correctly. Also. code in .ctags!
" let g:tagbar_type_tex = {
"             \ 'ctagstype' : 'latex',
"             \ 'kinds'     : [
"             \ 's:sections',
"             \ 'g:graphics:0:0',
"             \ 'l:labels',
"             \ 'r:refs:1:0',
"             \ 'p:pagerefs:1:0'
"             \ ],
"             \ 'sort'    : 0
"             \ }

" Set the syntax for the markdown files so that the file highlighting is correct
" au BufRead,BufNewFile *.md set filetype=liquid

" Latex Box Plugin that is useful for editing LaTeX in Vim; note that the first line is the one that 
" enables the using of forward and inverse skimming with Vim and Evince (you must use synctex)
" let g:LatexBox_latexmk_options="-pvc -pdf -pdflatex='pdflatex -file-line-error -synctex=1'"
" let g:LatexBox_output_type="pdf"
" let g:Tex_MultipleCompileFormats = 'pdf'
" " let g:Tex_CompileRule_pdf = 'latexmk -pdf $*'
" let g:Tex_DefaultTargetFormat='pdf'
" let Tex_FoldedSections=""
" let Tex_FoldedEnvironments=""
" let Tex_FoldedMisc=""
" let g:LatexBox_autojump=1
" let g:LatexBox_show_warnings=0 " don't show all of the warnings in latex compilation, great for the issta paper
" let g:LatexBox_latexmk_async=1 " handles the weird screen flashing issue with compilation and other errors

" nnoremap <leader>t :w<CR>:!rubber --pdf --warn all %<CR>

" LaTeX needs to have a chained completion function for both LaTeX Box to handle cites and refs and to get all of the
" other types of insertions (buffer, dictionary, etc) with the other types of completion -- WORKS SORTA WELL
            " \   call SuperTabSetDefaultCompletionType("<c-x><c-o>") |
            "
 " autocmd FileType tex
 "             \ if &omnifunc != '' |
 "             \   call SuperTabChain(&omnifunc, "<c-n>") |
             " \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
             " \ endif

" set hlsearch      " highlight search terms

" turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>

