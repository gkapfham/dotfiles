set nocompatible

call plug#begin('~/.vim/bundle')

" These are all of the Plugs that we use to enhance the behavior of Vim

" Plug 'FelikZ/ctrlp-py-matcher'
" Plug 'https://github.com/Valloric/MatchTagAlways.git', {'for': 'html'}
" Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
" Plug 'https://github.com/dterei/VimBookmarking.git'
" Plug 'https://github.com/ervandew/ag.git'
" Plug 'https://github.com/jalvesaq/VimCom.git'
" Plug 'https://github.com/junegunn/gv.vim.git'
" Plug 'https://github.com/kablamo/vim-git-log.git'
" Plug 'https://github.com/majutsushi/tagbar'
" Plug 'https://github.com/nathanaelkane/vim-indent-guides'
" Plug 'https://github.com/nelstrom/vim-visual-star-search.git'
" Plug 'https://github.com/scrooloose/syntastic.git'
" Plug 'https://github.com/sgur/ctrlp-extensions.vim.git'
" Plug 'https://github.com/terryma/vim-multiple-cursors.git'
" Plug 'https://github.com/tpope/vim-ragtag.git', {'for': 'html'}
" Plug 'https://github.com/vim-scripts/AutoTag.git', {'for': 'html'}
Plug 'AndrewRadev/splitjoin.vim'
Plug 'gilligan/textobj-gitgutter'
Plug 'https://github.com/Lokaltog/vim-easymotion.git'
Plug 'https://github.com/MarcWeber/vim-addon-mw-utils'
Plug 'https://github.com/Raimondi/delimitMate.git'
Plug 'https://github.com/SirVer/ultisnips.git'
Plug 'https://github.com/Valloric/ListToggle.git'
Plug 'https://github.com/Valloric/YouCompleteMe.git'
Plug 'https://github.com/Z1MM32M4N/vim-superman.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/airblade/vim-rooter.git'
Plug 'https://github.com/artur-shaik/vim-javacomplete2.git'
Plug 'https://github.com/bkad/CamelCaseMotion.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/chrisbra/csv.vim.git', {'for': 'csv'}
Plug 'https://github.com/freitass/todo.txt-vim.git'
Plug 'https://github.com/garbas/vim-snipmate'
Plug 'https://github.com/godlygeek/tabular.git'
Plug 'https://github.com/gorodinskiy/vim-coloresque.git'
Plug 'https://github.com/henrik/vim-qargs.git'
Plug 'https://github.com/honza/vim-snippets'
Plug 'https://github.com/int3/vim-extradite.git'
Plug 'https://github.com/jalvesaq/Nvim-R.git'
Plug 'https://github.com/jdelkins/vim-correction.git', {'for': ['csv', 'gitcommit', 'html', 'markdown', 'tex']}
Plug 'https://github.com/jeetsukumaran/vim-filebeagle.git'
Plug 'https://github.com/jgdavey/tslime.vim.git'
Plug 'https://github.com/joeytwiddle/sexy_scroller.vim.git'
Plug 'https://github.com/kshenoy/vim-signature.git'
Plug 'https://github.com/lervag/vimtex.git', {'for': 'tex'}
Plug 'https://github.com/ludovicchabant/vim-gutentags.git'
Plug 'https://github.com/mattn/emmet-vim.git', {'for': 'html'}
Plug 'https://github.com/neomake/neomake.git'
Plug 'https://github.com/shime/vim-livedown.git'
Plug 'https://github.com/sjl/gundo.vim.git', {'on': 'GundoToggle'}
Plug 'https://github.com/tmux-plugins/vim-tmux-focus-events.git'
Plug 'https://github.com/tomtom/tlib_vim'
Plug 'https://github.com/tpope/vim-abolish.git'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-liquid.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/tpope/vim-unimpaired.git'
Plug 'https://github.com/vim-scripts/HTML-AutoCloseTag.git', {'for': 'html'}
Plug 'https://github.com/vim-scripts/SyntaxAttr.vim.git'
Plug 'https://github.com/wellle/tmux-complete.vim.git'
Plug 'https://github.com/xolox/vim-easytags.git'
Plug 'https://github.com/xolox/vim-misc.git'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user'
Plug 'rbonvall/vim-textobj-latex'
Plug 'vim-airline/vim-airline-themes'
Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'

" always load the special font after all of the other plugins to ensure fonts render correctly
Plug 'https://github.com/ryanoasis/vim-devicons.git'

call plug#end()

" Automatically identify the filetype for the plugins and always use syntax highlighting
filetype indent plugin on | syn on

autocmd! BufWritePost * Neomake

let g:neomake_error_sign = {
      \ 'text': '◼ ',
      \ 'texthl': 'ErrorMsg',
      \ }

let g:neomake_warning_sign = {
      \ 'text': '● ',
      \ 'texthl': 'WarningMsg',
      \ }

" let g:neomake_open_list = 2

" Set the completion function for a variety of different file types
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType tex set omnifunc=vimtex#complete#omnifunc
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" Allow syntastic to populate a list of problems for a given file
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['java'] }

" Disable the arrow keys so that I keep my fingers on home row during programming
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap jk <ESC>
inoremap <ESC> <NOP>

" Set the completion function in general if there is not a specific type
set omnifunc=syntaxcomplete#Complete

" Set the syntax for the todo file so that the file highlighting is correct
autocmd FileType todo set syntax=todo

" Set it so that the todo mode is always run when editing the file called todo.txt or Todo.txt
autocmd BufNewFile,BufRead [Tt]odo.txt set filetype=todo

" Setup the Livedown plugin that supports the preview of Markdown files
let g:livedown_autorun = 0
let g:livedown_open = 0
let g:livedown_port = 1337
nmap gmd :LivedownPreview<CR>

" Set indenting to work correctly for the HTML file type (may not be need now)
au BufRead,BufNewFile *.html set filetype=html
let g:html_indent_inctags = "html,body,head,tbody,div"

" Set it so that the CSV mode is always run when editing this type of file (does not autodetect?)
autocmd BufRead,BufNewFile *.csv,*.dat set filetype=csv

" Set up a dictionary so that I can do word completion by looking up words!
set dictionary-=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english

" Set the encoding to UTF 8, the most common encoding used for text
set encoding=utf-8

" Set the symbols that are required to display italics in the terminal window
" when running vim (works correctly without extra configuration in new
" terminals for Gnome)
set t_ZH=[3m
set t_ZR=[23m
"
" set the hybrid color scheme for vim running in the terminal window
" let g:hybrid_use_Xresources = 1
colorscheme hybrid

" define some commands for wrapping and not wrapping a line or paragraph
command! Wrap set textwidth=120
command! NoWrap set textwidth=0
command! StandardWrap set textwidth=80
set wrap linebreak nolist

" set up vim so that it displays line numbers in a hybrid fashion
set relativenumber
set number

" tmux configuration
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

" Make sure that you can load the dot files when you are searching the file system
" let g:ctrlp_show_hidden = 1

" Configure ctrlp so that it uses a faster matcher
" let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Ignore these directories in all programs like ctrlp
set wildignore+=*/build/**
set wildignore+=*/.git/*
set wildignore+=*.class
set wildignore+=*/tmp/*

" change the mapleader from \ to , -- this makes it easier to perform compilation in LaTeX
let maplocalleader=","
let mapleader=","

" " Setting up SyncTex and compilation support for Tex-9
" let g:tex_nine_config = {
"             \'compiler': "latexmk",
"             \'synctex': 1
"             \}

" Adding in the conceal option for latex. Trying this out to see if I like the rendering of mathematics
set cole=2
let g:tex_conceal= 'adgms'
hi Conceal ctermbg=234 ctermfg=143

" Starting to use vim-latex and it needs several configurations to work correctly
let g:vimtex_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -shell-escape -synctex=1'"
let g:vimtex_fold_enabled = 0
let g:vimtex_quickfix_mode = 2
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_toc_resize = 0
let g:vimtex_toc_hide_help = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_latexmk_enabled = 1
let g:vimtex_latexmk_callback = 1
let g:vimtex_complete_recursive_bib = 0

let g:vimtex_view_method = 'mupdf'
let g:vimtex_view_mupdf_options = '-r 288'

if has("nvim")
  let g:vimtex_latexmk_progname = 'nvr'
endif

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

" Make sure that the full latex mode is always run to get the benefits of plugins
let g:tex_flavor = 'tex'

" Turn on smart indentation with the Latex plugins, nice and very helpful
" set smartindent

" Configure completion so that it includes the dictionary
set complete-=k complete+=k
set complete+=kspell
set complete+=]

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
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsListSnippets = "<C-l>"
let g:UltiSnipsJumpBackwardTrigger='<C-s-k>'
let g:UltiSnipsJumpBackwardTrigger=""

" make YCM compatible with the tmux-complete
let g:tmuxcomplete#trigger = 'omnifunc'

" make YCM compatible with the vimtex package
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
  endif
let g:ycm_semantic_triggers.tex = [
        \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
        \ ]

" allow CTRLP to show fifteen total matches, helping in cases where there are
" many matches that we still want to display and consider
" let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:15'
" let g:ctrlp_extensions = ['tag', 'quickfix']

" note that menu provides a substantially better configuration for viewing the autocompletion output that is available in gvim
set cot=menu
set completeopt=longest,menuone

" start using the wildmenu to complete different commands in command-mode
set wildmenu
set wildmode=longest:full,full

" Adding in a bunch of additional commands from:
" http://nvie.com/posts/how-i-boosted-my-vim/

set linebreak                                  " make sure that you break the lines in a way that preserves words
set showbreak=━━                               " set an ellipse character so that you can tell when lines are wrapped
set breakindent                                " indent after linebreaks occur and there are wraps (only Vim 7.4 later patches)
set tabstop=4                                  " a tab is four spaces
set expandtab                                  " insert spaces whenever the tab key is pressed, helps with formatting Java code
set backspace=indent,eol,start                 " allow backspacing over everything in insert mode
set autoindent                                 " always set autoindenting on
set copyindent                                 " copy the previous indentation on autoindenting
set shiftwidth=2                               " number of spaces to use for autoindenting
set shiftround                                 " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                                  " set show matching parenthesis
set ignorecase                                 " ignore case when searching
set infercase                                  " predict the case that is needed when doing auto completion
set smartcase                                  " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab                                   " insert tabs on the start of a line according to shiftwidth, not tabstop
set incsearch                                  " show search matches as you type
set history=1000                               " remember more commands and search history
set undolevels=1000                            " use many many levels of undo
set pastetoggle=<F2>                           " allow vim to paste a large amount of source code or tex
set timeout timeoutlen=1000 ttimeoutlen=10     " make the escape key function faster in the terminal window
set whichwrap+=<,>,h,l,[,]                     " wrap when you get to the end of a line and you are using the arrow keys
set listchars=tab:▸▹,trail:•,extends:#,precedes:#,nbsp:⌻ " highlight problematic whitespace
set list                                       " also required to ensure that problematic whitespace is highlighted correctly
set hidden                                     " this option is required for the vimtex plugin to work correctly

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

" Turn on spell checking for Git commits
autocmd FileType gitcommit setlocal spell

" Allow spelling to be easily toggled on and off
nmap <silent> <leader>s :set spell!<CR>
syntax spell toplevel

let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_vertical = 15

" Configure the Tagbar so that it can handle the Markdown language
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3',
        \ 'k:Heading_L4'
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

" These are some configurations that seem to make vim screen redraws faster
set nocursorcolumn
set nocursorline
set ttyfast

" This is a configuration that should stop NeoVim from highlighting searching results
set nohlsearch

" Make the source code history browsing feature open windows horizontally, as this supports better browsing
" let g:Gitv_OpenHorizontal=1

" Do not display the welcome message / splash screen when opening gvim or vim
" with no specified file
set shortmess=I

" Configure the airline status bar replacement that provides some delightful context
set laststatus=2
let g:airline_theme='tomorrow'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
set nosmd " turn off the status line that shows the silly word insert, airline is much better!

" Configure the EasyMotion plugin for the main keys
nmap f <Plug>(easymotion-s)
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)

" map <Leader> <Plug>(easymotion-prefix)
nmap t <Plug>(easymotion-t2)
" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)

function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

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
set tags=./tags;/,tags;/
let g:easytags_ignored_filetypes = ''
let g:easytags_dynamic_files = 1
let g:easytags_updatetime_warn = 0
let g:easytags_always_enabled = 1
let g:easytags_async = 1

" " Configuring the ctrlp plugin to work faster for searching
" let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
" let g:ctrlp_use_caching = 0
" let g:ctrlp_z_nerdtree = 1

" Define a function that allows you to determine what syntax group is being used
map <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F5> :call SyntaxAttr()<CR>

" Configure the GitGutter plugin so that it display signs in the sign column
let g:gitgutter_signs = 1
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_sign_column_always = 1

" Set all of the symbols for the GitGutter
let g:gitgutter_sign_added = '➕ '
let g:gitgutter_sign_modified = '▲ '
let g:gitgutter_sign_removed = '✘ '
let g:gitgutter_sign_removed_first_line = '⏫ '
let g:gitgutter_sign_modified_removed = '✱ '

" Automatically save changes before switching buffer with some
" commands, like :cnfile. Very useful when running Qdo on a QuickFix list
set autowrite

" However, if you follow the Java guidelines about how functions and classes are
" supposed to be named (with respect to upper and lowercase), use >
" Basically, make the syntax highlighting for method declarations a lot better
" let java_highlight_functions="indent"
let java_highlight_functions="style"

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Create a mapping that allows for the insertion of a blank line without
" having to enter insert mode and then leave it. Works nicely, but only in GVim
nmap <S-Enter> O<Esc>
nmap oo Ojk

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
map <Leader>mf :call RenameFile()<cr>

" Allow the Vim-R-Plugin to create the R assignment, but only with two
" underscore presses when writing code in Vim
let R_assign = 2
let R_tmux_split = 1
let R_vsplit = 0

" Add in a command that will allow me to remove the trailing white space
nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Remove the feature that performs folding inside of Markdown files
let g:pandoc#modules#disabled = ["folding"]

" " Set up the CamelCaseMotion plugin so that it allows for movements with
" " variables in programs written in Java and R, for instance
call camelcasemotion#CreateMotionMappings('<leader>')

" Configure up and down line movement so that I can handle paragraphs that are
" "virtually" formatted without specific line breaks
nmap j gj
nmap k gk

" Configure a key combination that allows me to stop using pair matching
nmap <leader>tp :DelimitMateSwitch<CR>
let delimitMateSmartMatchpairs = 1

" Mapping selecting mappings --- lets you see the mappings that are configured
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion for words, paths, files, and lines in the buffer
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Define a custom command for loading MRU files with FZF
command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})

" Define a custom command for loading hidden files as well as regular with FZF
command! FZFHidden call fzf#run({
\  'source':  'ag --hidden --ignore .git -l -g ""',
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})

" Setup special key for viewing the tabs in the buffer
nmap <C-t> :BTags <CR>

" Setup special key for viewing the Tags that match word highlighted
nmap <C-i> :Tags <C-R><C-W><CR>

" Allow for running an ag search on the word currently under the cursor
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

" This allows you to jump to the definition of a function using FZF
nnoremap <Tab> :Buffers<Cr>

" Run the FZF command as a file-finder in the same way that I use CTRL-P
" when it is displaying the most recent files
nmap <C-u> :FZFMru<CR>

" Run the FZF command as a file-finder in the same way that I use CTRL-P (but,
" no hidden files are indexed with FZF by default --- so, also use a separate
" command to display the hidden files along with the standard files)
nmap <C-p> :FZF -m<CR>
nmap <C-l> :FZFHidden<CR>

" Configure the colors for fzf so that they fit my overall theme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'Normal', 'Normal'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Add in a format string for controlling how FZF will color-code when running
" a commands that shows the Git logs (Note that the blue is black by default)
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(blue)%C(bold)%cr"'
