" Indicate that vim should run our plugins and always use syntax highlighting for all identified file types
set nocompatible | filetype indent plugin on | syn on

" set the completion function for a variety of different file types
set omnifunc=syntaxcomplete#Complete
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

" Set the encoding to utf 8, the most common encoding used for text
set encoding=utf-8

" set the hybrid color scheme for vim running in the terminal window
" let g:hybrid_use_Xresources = 1
colorscheme hybrid

" define some commands for wrapping and not wrapping a line or paragraph
command Wrap set textwidth=120
command NoWrap set textwidth=0

" Make sure that you can load the dot files when you are searching the file system
let g:ctrlp_show_hidden = 1

" Ignore these directories in all programs like ctrlp
set wildignore+=*/build/**
set wildignore+=*/.git/*
set wildignore+=*.class
set wildignore+=*/tmp/*

" change the mapleader from \ to , -- this makes it easier to perform compilation in LaTeX 
let maplocalleader=","

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
Bundle 'https://github.com/Valloric/MatchTagAlways.git'
Bundle 'https://github.com/altercation/vim-colors-solarized.git'
Bundle 'https://github.com/bling/vim-airline.git'
Bundle 'https://github.com/dterei/VimBookmarking.git'
Bundle 'https://github.com/ervandew/supertab.git'
Bundle 'https://github.com/garbas/vim-snipmate'
Bundle 'https://github.com/gregsexton/gitv.git'
Bundle 'https://github.com/int3/vim-extradite.git'
Bundle 'https://github.com/joeytwiddle/sexy_scroller.vim.git'
Bundle 'https://github.com/justinmk/vim-sneak.git'
Bundle 'https://github.com/kablamo/vim-git-log.git'
Bundle 'https://github.com/kien/ctrlp.vim.git'
Bundle 'https://github.com/kshenoy/vim-signature.git'
Bundle 'https://github.com/majutsushi/tagbar'
Bundle 'https://github.com/onza/vim-snippets'
Bundle 'https://github.com/scrooloose/nerdtree.git'
Bundle 'https://github.com/scrooloose/nerdtree.git'
Bundle 'https://github.com/scrooloose/syntastic.git'
Bundle 'https://github.com/terryma/vim-multiple-cursors.git'
Bundle 'https://github.com/tommcdo/vim-lion.git'
Bundle 'https://github.com/tomtom/tlib_vim'
Bundle 'https://github.com/tpope/vim-abolish.git'
Bundle 'https://github.com/tpope/vim-abolish.git'
Bundle 'https://github.com/tpope/vim-fugitive.git'
Bundle 'https://github.com/tpope/vim-surround.git'
Bundle 'https://github.com/vim-scripts/AutoTag.git'
Bundle 'https://github.com/vim-scripts/CSApprox.git'
Bundle 'https://github.com/vim-scripts/HTML-AutoCloseTag.git'
Bundle 'https://github.com/vim-scripts/Marks-Browser.git'
Bundle 'https://github.com/vim-scripts/SQLComplete.vim.git'
Bundle 'https://github.com/vim-scripts/TeX-9.git'
Bundle 'https://github.com/vim-scripts/Xoria256m.git'
Bundle 'https://github.com/vim-scripts/csv.vim.git'
Bundle 'https://github.com/vim-scripts/dbext.vim.git'
Bundle 'https://github.com/vim-scripts/tComment.git'
Bundle 'https://github.com/xolox/vim-easytags.git'
Bundle 'https://github.com/xolox/vim-misc.git'
Bundle 'https://github.com/xolox/vim-session.git'
Bundle 'https://github.com/yuratomo/gmail.vim.git'

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

" Latex Box Plugin that is useful for editing LaTeX in Vim; note that the first line is the one that 
" enables the using of forward and inverse skimming with Vim and Evince (you must use synctex)
let g:LatexBox_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -synctex=1'"
let g:LatexBox_output_type="pdf"
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_CompileRule_pdf = 'latexmk -pdf -pvc $*'
let g:Tex_DefaultTargetFormat='pdf'
let Tex_FoldedSections=""
let Tex_FoldedEnvironments=""
let Tex_FoldedMisc=""
let g:LatexBox_autojump=1

" Recommended for xelatex users who wants SyncTeX support
let g:tex_nine_config = {
        \'compiler': 'latexmk',
        \'synctex': 1
\}

" Commands that allow for the invocation of the SyncTex support
noremap <buffer><silent> <C-LeftMouse> :call tex_nine#ForwardSearch()<CR>
noremap <buffer><silent> <C-l> :call tex_nine#ForwardSearch()<CR>

" Configure SuperTab so that it detects the context for tab completion, if it
" cannot do so, then use standard auto-completion with words in the buffer
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-p>"

" We want to use special tab completion for the plugins that are available for LaTeX. Tested and works very well.
autocmd FileType tex let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
autocmd FileType tex let g:SuperTabContextDefaultCompletionType = "<c-p>"

" It turns out that Java tab completion works correctly without using something special, so this is not needed
" autocmd FileType java let g:SuperTabDefaultCompletionType = "<c-x><c-u>"

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
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set history=1000  " remember more commands and search history
set undolevels=1000 " use many muchos levels of undo
set pastetoggle=<F2> " allow vim to paste a large amount of source code or tex
set timeout timeoutlen=1000 ttimeoutlen=10 " make the escape key function faster in the terminal window
set whichwrap+=<,>,h,l,[,] " wrap when you get to the end of a line and you are using the arrow keys

" do not prompt to save for the session management each time
let g:session_autosave = 'no'

" to use the sessions program, you need to uncomment this line and change it to something in your home account
" let g:session_directory = '/home/gkapfham/.vim/sessions'

" database connections for work with SchemaAnalyst and different database
" applications (e.g., TweetComplete) 

" SQLite
let g:dbext_default_profile_sqlite_customer = 'type=SQLITE:dbname=/home/gkapfham/working/databases/customer.db'
let g:dbext_default_profile_sqlite_tweetcomplete_testing = 'type=SQLITE:dbname=/home/gkapfham/working/software/TweetComplete/databases/tweetcomplete-testing.db'
let g:dbext_default_profile_sqlite_tweetcomplete = 'type=SQLITE:dbname=/home/gkapfham/working/software/TweetComplete/databases/tweetcomplete.db'

" turn on spell checking so that I can do this for Latex documents
set spell spelllang=en_us
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

" Set up a dictionary so that I can do word completion by looking up words!
set dictionary+=/usr/share/dict/american-english

" Note that this help for tab completion breaks the abolish plugin because it remaps space, needed to remove it!
" This does not seem to break the setup for the use of tab completion in either latex or Java source code.
" inoremap <expr> <Space> pumvisible() ? "\<C-y>" : " "

" Set up the enter key to ensure that after completing words a return is not pressed
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Configure the airline status bar replacement that provides some delightful context 
set laststatus=2
let g:airline_theme='base16'
let g:airline_powerline_fonts = 1
let g:airline_detect_whitespace=0
set nosmd " turn of the status line that shows the silly word insert, airline is much better!

" Configure the way that colors are displayed for the sneak feature of
" searching in the text, seems to work very nicely
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
let g:ctrlp_extensions = ['tag', 'buffertag']
nmap <C-t> :!ctags -R<CR>

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

