" Indicate that vim should run our plugins and always use syntax highlighting for all identified file types
set nocompatible | filetype indent plugin on | syn on

" Set the completion function for a variety of different file types
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType tex set omnifunc=LatexBox_Complete
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

" Set the completion function in general if there is not a specific type
set omnifunc=syntaxcomplete#Complete

" Set the syntax for the todo file so that the file highlighting is correct
autocmd FileType todo set syntax=todo

" Set it so that the todo mode is always run when editing the file called todo.txt or Todo.txt
autocmd BufNewFile,BufRead [Tt]odo.txt set filetype=todo

" Set up a dictionary so that I can do word completion by looking up words!
set dictionary-=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english

" Set the encoding to utf 8, the most common encoding used for text
set encoding=utf-8

" set the hybrid color scheme for vim running in the terminal window
" let g:hybrid_use_Xresources = 1
colorscheme hybrid

" define some commands for wrapping and not wrapping a line or paragraph
command Wrap set textwidth=130
command NoWrap set textwidth=0
command StandardWrap set textwidth=80

" Make sure that you can load the dot files when you are searching the file system
let g:ctrlp_show_hidden = 1

" Ignore these directories in all programs like ctrlp
set wildignore+=*/build/**
set wildignore+=*/.git/*
set wildignore+=*.class
set wildignore+=*/tmp/*

" change the mapleader from \ to , -- this makes it easier to perform compilation in LaTeX 
let maplocalleader=","
let mapleader=","

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
Bundle 'https://github.com/LaTeX-Box-Team/LaTeX-Box.git'
Bundle 'https://github.com/MarcWeber/vim-addon-mw-utils'
Bundle 'https://github.com/Valloric/ListToggle.git'
Bundle 'https://github.com/Valloric/MatchTagAlways.git'
Bundle 'https://github.com/altercation/vim-colors-solarized.git'
Bundle 'https://github.com/bling/vim-airline.git'
Bundle 'https://github.com/dterei/VimBookmarking.git'
Bundle 'https://github.com/ervandew/supertab.git'
Bundle 'https://github.com/flazz/vim-colorschemes.git'
Bundle 'https://github.com/freitass/todo.txt-vim.git'
Bundle 'https://github.com/garbas/vim-snipmate'
Bundle 'https://github.com/godlygeek/tabular.git'
Bundle 'https://github.com/gregsexton/gitv.git'
Bundle 'https://github.com/honza/vim-snippets'
Bundle 'https://github.com/int3/vim-extradite.git'
Bundle 'https://github.com/itchyny/calendar.vim.git'
Bundle 'https://github.com/joeytwiddle/sexy_scroller.vim.git'
Bundle 'https://github.com/junegunn/vim-easy-align.git'
Bundle 'https://github.com/justinmk/vim-sneak.git'
Bundle 'https://github.com/kablamo/vim-git-log.git'
Bundle 'https://github.com/kien/ctrlp.vim.git'
Bundle 'https://github.com/kshenoy/vim-signature.git'
Bundle 'https://github.com/majutsushi/tagbar'
Bundle 'https://github.com/scrooloose/nerdtree.git'
Bundle 'https://github.com/scrooloose/syntastic.git'
Bundle 'https://github.com/terryma/vim-multiple-cursors.git'
Bundle 'https://github.com/tommcdo/vim-lion.git'
Bundle 'https://github.com/tomtom/tlib_vim'
Bundle 'https://github.com/tpope/vim-abolish.git'
Bundle 'https://github.com/tpope/vim-fugitive.git'
Bundle 'https://github.com/tpope/vim-surround.git'
Bundle 'https://github.com/tsaleh/vim-matchit.git'
Bundle 'https://github.com/vim-scripts/AutoTag.git'
" Bundle 'https://github.com/vim-scripts/CSApprox.git'
Bundle 'https://github.com/vim-scripts/HTML-AutoCloseTag.git'
Bundle 'https://github.com/vim-scripts/Marks-Browser.git'
Bundle 'https://github.com/vim-scripts/SQLComplete.vim.git'
Bundle 'https://github.com/vim-scripts/TeX-9.git'
Bundle 'https://github.com/vim-scripts/Xoria256m.git'
Bundle 'https://github.com/vim-scripts/csv.vim.git'
Bundle 'https://github.com/vim-scripts/dbext.vim.git'
Bundle 'https://github.com/vim-scripts/tComment.git'
Bundle 'https://github.com/xolox/vim-misc.git'
Bundle 'https://github.com/xolox/vim-easytags.git'
Bundle 'https://github.com/xolox/vim-session.git'
Bundle 'https://github.com/yuratomo/gmail.vim.git'
" Bundle 'https://github.com/w0ng/vim-hybrid.git'
" Bundle 'https://github.com/skroll/vim-taghighlight.git'
Bundle 'https://github.com/gorodinskiy/vim-coloresque.git'
Bundle 'https://github.com/vim-scripts/SyntaxAttr.vim.git' 
Bundle 'https://github.com/Yggdroot/indentLine.git'
Bundle 'https://github.com/nathanaelkane/vim-indent-guides'
Bundle 'https://github.com/Raimondi/delimitMate.git'

if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"

    echo ""
    :BundleInstall
endif

" Various vim plugins that did not work the way that I wanted them to, discarding for now
" Bundle 'https://github.com/Keithbsmiley/investigate.vim.git'
" Bundle 'https://github.com/Lokaltog/vim-easymotion'
" Bundle 'https://github.com/SirVer/ultisnips.git'
" Bundle 'https://github.com/Townk/vim-autoclose.git'
" Bundle 'https://github.com/airblade/vim-gitgutter.git'
" Bundle 'https://github.com/gcmt/tag-surfer.git'
" Bundle 'https://github.com/gerw/vim-latex-suite.git'
" Bundle 'https://github.com/goldfeld/vim-seek.git'
" Bundle 'https://github.com/hlissner/vim-multiedit.git'
" Bundle 'https://github.com/jcf/vim-latex.git'
" Bundle 'https://github.com/mhinz/vim-startify.git'
" Bundle 'https://github.com/othree/vim-autocomplpop.git'
" Bundle 'https://github.com/rking/vim-detailed.git'
" Bundle 'https://github.com/vim-scripts/colorsupport.vim.git' 
" Bundle 'https://github.com/vim-scripts/taglist.vim.git'
" Bundle 'https://github.com/mhinz/vim-signify.git'
" Bundle 'https://github.com/milkypostman/vim-togglelist.git'
 " Bundle 'https://github.com/aaronbieber/quicktask.git'

" " Latex Box Plugin that is useful for editing LaTeX in Vim; note that the first line is the one that 
" " enables the using of forward and inverse skimming with Vim and Evince (you must use synctex)
let g:LatexBox_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -synctex=1'"
let g:LatexBox_output_type="pdf"
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_CompileRule_pdf = 'latexmk -pdf -pvc $*'
let g:Tex_DefaultTargetFormat='pdf'
let Tex_FoldedSections=""
let Tex_FoldedEnvironments=""
let Tex_FoldedMisc=""
let g:LatexBox_autojump=1
let g:LatexBox_show_warnings=0 " don't show all of the warnings in latex compilation, great for the issta paper

" Recommended for xelatex users who wants SyncTeX support, using the Tex-9 plugin for forward and reverse searching
let g:tex_nine_config = {
        \'compiler': 'latexmk',
        \'synctex': 1
\}

" Turn on smart indentation with the LaTeX-Box plugin, nice and very helpful
set smartindent

" " Commands that allow for the invocation of the SyncTex support
" noremap <buffer><silent> <C-LeftMouse> :call tex_nine#ForwardSearch()<CR>
" noremap <buffer><silent> <C-l> :call tex_nine#ForwardSearch()<CR>

" Commands that allow for the invocation of the SyncTex support
nmap <C-LeftMouse> :call tex_nine#ForwardSearch()<CR>
nmap <C-l> :call tex_nine#ForwardSearch()<CR>

" Configure completion (and thus SuperTab so that it include the dictionary in the p and n completion type)
" set complete=.,b,u,]
set complete-=k complete+=k
set complete+=kspell

" This is the default context completion that will be used if there is not a separate autocommand configuration
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabLongestEnhanced = 1

" LatexBox_Complete

" LaTeX needs to have a chained completion function for both LaTeX Box to handle cites and refs and to get all of the
" other types of insertions (buffer, dictionary, etc) with the other types of completion -- WORKS WELL
autocmd FileType tex
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-n>") |
    \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
    \ endif

" HTML needs to have a chained completion function for both LaTeX Box to handle cites and refs and to get all of the
" other types of insertions (buffer, dictionary, etc) with the other types of completion -- WORKS WELL
autocmd FileType html
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-n>") |
    \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
    \ endif

" Java autocompletion must use the completefunc (ctrl-x ctrl-u) to work correctly, so set it separately 
autocmd FileType java let g:SuperTabDefaultCompletionType = "context"
autocmd FileType java let g:SuperTabContextDefaultCompletionType = "<c-n>"
autocmd FileType java let g:SuperTabContextTextOmniPrecedence = ['&completefunc', '&omnifunc']

" We want to use special tab completion for the plugins that are available for LaTeX. Tested and works very well.
" autocmd FileType tex let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" autocmd FileType todo let g:SuperTabDefaultCompletionType = "<c-n>"

" note that menu provides a substantially better configuration for viewing
" the autocompletion output that is available in gvim
set cot=menu
set completeopt=longest,menuone

" set up some commands for adding, removing, and navigating bookmarks inside of vim; very useful
map <silent> bb :ToggleBookmark<CR>
map <silent> bn :NextBookmark<CR>
map <silent> bp :PreviousBookmark<CR>

" Adding in a bunch of additional commands from: 
" http://nvie.com/posts/how-i-boosted-my-vim/  

set nowrap        " don't wrap lines
set wrap          " go ahead and allow the wrapping of long lines to take place 
set linebreak     " make sure that you break the lines in a way that preserves words
set showbreak=━━  " set an ellipse character so that you can tell when lines are wrapped
set tabstop=4     " a tab is four spaces
 set expandtab
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
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set history=1000  " remember more commands and search history
set undolevels=1000 " use many muchos levels of undo
set pastetoggle=<F2> " allow vim to paste a large amount of source code or tex
set timeout timeoutlen=1000 ttimeoutlen=10 " make the escape key function faster in the terminal window
set whichwrap+=<,>,h,l,[,] " wrap when you get to the end of a line and you are using the arrow keys

" autocmd FileType tex set formatoptions=t " ALL automatically reformat paragraphs when going beyond textwidth; good but not perfect 
" autocmd FileType mail set formatoptions=t " TEXT automatically reformat paragraphs when going beyond textwidth; good but not perfect 
" autocmd FileType java set formatoptions=c " COMM automatically reformat paragraphs when going beyond textwidth; good but not perfect 

" do not prompt to save for the session management each time
let g:session_autosave = 'no'

" to use the sessions program, you need to uncomment this line and change it to something in your home account
" let g:session_directory = '/home/gkapfham/.vim/sessions'

" database connections for work with SchemaAnalyst and different database applications (e.g., TweetComplete) 

" SQLite
let g:dbext_default_profile_sqlite_customer = 'type=SQLITE:dbname=/home/gkapfham/working/databases/customer.db'
let g:dbext_default_profile_sqlite_tweetcomplete_testing = 'type=SQLITE:dbname=/home/gkapfham/working/software/TweetComplete/databases/tweetcomplete-testing.db'
let g:dbext_default_profile_sqlite_tweetcomplete = 'type=SQLITE:dbname=/home/gkapfham/working/software/TweetComplete/databases/tweetcomplete.db'

" turn on spell checking so that I can do this for Latex documents
set spell spelllang=en_us,en_gb
set mousemodel=popup

" turn of spell checking for some types of buffers, mostly Java and other
" programming languages
au BufNewFile,BufRead,BufEnter *.c      set nospell
au BufNewFile,BufRead,BufEnter *.h      set nospell
au BufNewFile,BufRead,BufEnter *.cpp    set nospell
au BufNewFile,BufRead,BufEnter *.hpp    set nospell
au BufNewFile,BufRead,BufEnter *.java   set nospell
au BufNewFile,BufRead,BufEnter *.sh     set nospell
au BufNewFile,BufRead,BufEnter *.xml    set nospell
au BufNewFile,BufRead,BufEnter *.sql    set nospell

" Give a special key for turning on and off the Tagbar, a great feature for browsing source code, such as Java programs
nmap <F12> :TagbarToggle<CR>

" Give a special key for turning on and off the NERDTree, a great feature for browsing the entire file system
nmap <F11> :NERDTreeToggle<CR>

" Set up the NERDTree so that it does not display the silly help message at the top, this is not minimal enough.
let NERDTreeMinimalUI=1

" This is the extra line of code that the Tagbar needs to get LaTeX outlines to work correctly. Also. code in .ctags!
let g:tagbar_type_tex = {
            \ 'ctagstype' : 'latex',
            \ 'kinds'     : [
                \ 's:sections',
                \ 'g:graphics:0:0',
                \ 'l:labels',
                \ 'r:refs:1:0',
                \ 'p:pagerefs:1:0'
            \ ],
            \ 'sort'    : 0
        \ }

" Stop vim from redrawing the screen during complex operations, supposed to make the user interface much smoother, let's try!
set nocursorcolumn
set nocursorline
" syntax sync minlines=256
" set lazyredraw

" Make the source code history browsing feature open windows horizontally, as this supports better browsing
let g:Gitv_OpenHorizontal=1

" Do not display the welcome message / splash screen when opening gvim or vim
" with no specified file
set shortmess=I

" Set up the enter key to ensure that after completing words a return is not pressed
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" inoremap <expr> <tab> pumvisible() ? '<tab>' :
"   \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Configure the airline status bar replacement that provides some delightful context 
set laststatus=2
let g:airline_theme='base16'
let g:airline_powerline_fonts = 1
let g:airline_detect_whitespace=0
set nosmd " turn of the status line that shows the silly word insert, airline is much better!

" Configure the way that colors are displayed for the sneak feature of searching in the text, seems to work very nicely
hi link SneakPluginTarget Type 
hi link SneakPluginScope Visual

" Configure scrolling in the window; breaks with the mouse flick but fine with the keyboard
let g:SexyScroller_MaxTime = 500
let g:SexyScroller_EasingStyle = 1

" Configuring the EasyTags and Ctrl-P plugins to better support tag creation and browsing
set tags=./tags;
let g:easytags_ignored_filetypes = ''
let g:easytags_dynamic_files = 1
let g:easytags_updatetime_warn = 0
let g:easytags_always_enabled = 1
let g:ctrlp_extensions = ['tag', 'buffertag']
nmap <C-t> :!ctags -R<CR>

" Configure the Calendar plugin so that it can access the Google calendar, nice for viewing your schedule
let g:calendar_google_calendar = 1

" Start interactive EasyAlign in visual mode
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
nmap <Leader>a <Plug>(EasyAlign)

" Define a function that will insert the correct kind of quotation marks, but only in LaTeX documents
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

map <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F5> :call SyntaxAttr()<CR>

" if you write function declarations that are always indented by either
" a tab, 8 spaces or 2 spaces you may want to set >

" let java_highlight_functions="indent"
let delimitMate_expand_cr = 2

" However, if you follow the Java guidelines about how functions and classes are
" supposed to be named (with respect to upper and lowercase), use >
 let java_highlight_functions="style"

" let g:indentLine_color_term = 239
" let g:indentLine_color_gui = '#FFFFFF'
 let g:indentLine_char = '│'
" 
" let @b = 'vap:s/\./\.^V^M/^M:noh^I^M'  
" map gqb @b

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

