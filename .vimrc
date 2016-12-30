set nocompatible

call plug#begin('~/.vim/bundle')

" Plugins cannot be used until a bug is fixed in Neovim {{{

" Plug 'haya14busa/incsearch-easymotion.vim'
" Plug 'haya14busa/incsearch-fuzzy.vim'
" Plug 'haya14busa/incsearch.vim'

" " define a function that will run EasyMotion after running the incsearch
" function! s:incsearch_config(...) abort
"   return incsearch#util#deepextend(deepcopy({
"   \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
"   \   'keymap': {
"   \     "\<CR>": '<Over>(easymotion)'
"   \   },
"   \   'is_expr': 0
"   \ }), get(a:, 1, {}))
" endfunction

" " incsearch.vim combined with the fuzzy search plugin and the EasyMotion plugin
" function! s:config_easyfuzzymotion(...) abort
"   return extend(copy({
"   \   'converters': [incsearch#config#fuzzy#converter()],
"   \   'modules': [incsearch#config#easymotion#module()],
"   \   'keymap': {"\<CR>": '<Over>(easymotion)'},
"   \   'is_expr': 0,
"   \   'is_stay': 1
"   \ }), get(a:, 1, {}))
" endfunction

" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)
"
" " change the color of the highlighting for the incsearch plugin
" let g:incsearch#highlight = {
"         \   'match' : {
"         \     'group' : 'Type',
"         \     'priority' : '10'
"         \   }
"         \ }

" }}}

" Plugins that are no longer being used by may be used in the future {{{

" Plug 'Raimondi/delimitMate'
" nmap <leader>tp :DelimitMateSwitch<CR>
" let delimitMateSmartMatchpairs = 1

" }}}

" Plugins that require no configuration {{{

Plug 'AndrewRadev/splitjoin.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Valloric/ListToggle'
Plug 'Valloric/MatchTagAlways'
Plug 'airblade/vim-rooter'
Plug 'jez/vim-superman'

" }}}

" Plugins that require configuration {{{

" vim-easymotion {{{

Plug 'easymotion/vim-easymotion'
nmap f <Plug>(easymotion-s)
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  ? <Plug>(easymotion-sn)
omap ? <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" }}}

" auto-pairs {{{

Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = '<leader>apt'

" }}}

" ultisnips {{{

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsListSnippets = "<C-l>"
let g:UltiSnipsJumpBackwardTrigger='<C-s-k>'
let g:UltiSnipsJumpBackwardTrigger=""

" }}}

" YouCompleteMe {{{

Plug 'Valloric/YouCompleteMe'

let g:ycm_server_python_interpreter = '/usr/bin/python3'
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

" make YCM compatible with the vimtex package
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
  endif
let g:ycm_semantic_triggers.tex = [
        \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
        \ ]

" }}}


" vim-gitgutter {{{

Plug 'airblade/vim-gitgutter'
let g:gitgutter_async = 1
let g:gitgutter_eager = 1
let g:gitgutter_realtime = 1
let g:gitgutter_sign_column_always = 1
let g:gitgutter_signs = 1
let g:gitgutter_sign_added = '➕'
let g:gitgutter_sign_modified = '▲'
let g:gitgutter_sign_removed = '✘'
let g:gitgutter_sign_removed_first_line = '⏫'
let g:gitgutter_sign_modified_removed = '✱'

" }}}

Plug 'artur-shaik/vim-javacomplete2'
Plug 'bkad/CamelCaseMotion'
Plug 'bronson/vim-visual-star-search'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'christoomey/vim-sort-motion'
Plug 'davidhalter/jedi-vim'
Plug 'freitass/todo.txt-vim'
Plug 'garbas/vim-snipmate'
Plug 'gilligan/textobj-gitgutter'
Plug 'gorodinskiy/vim-coloresque'
Plug 'haya14busa/vim-operator-flashy'
Plug 'henrik/vim-qargs'
Plug 'honza/vim-snippets'
Plug 'int3/vim-extradite'
Plug 'jalvesaq/Nvim-R'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'jgdavey/tslime.vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-textobj-user'
Plug 'kshenoy/vim-signature'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'lfv89/vim-interestingwords'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mattn/emmet-vim', {'for': 'html'}
" Plug 'neomake/neomake'
Plug 'rbonvall/vim-textobj-latex', {'for': 'latex'}
Plug 'shime/vim-livedown', {'for': 'markdown'}
Plug 'sjl/gundo.vim', {'on': 'GundoToggle'}
Plug 'spacewander/vim-coloresque'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tweekmonster/spellrotate.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/HTML-AutoCloseTag', {'for': 'html'}
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'wellle/targets.vim'

" tmux-complete.vim {{{

Plug 'wellle/tmux-complete.vim'
let g:tmuxcomplete#trigger = 'omnifunc'

" }}}

Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'w0rp/ale'

" always load the special font after all of the other plugins to ensure fonts render correctly
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Automatically identify the filetype for the plugins and always use syntax highlighting
filetype indent plugin on | syn on

" Set the completion function for a variety of different file types
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType tex set omnifunc=vimtex#complete#omnifunc
autocmd FileType java setlocal omnifunc=javacomplete#Complete
set completefunc=autoprogramming#complete
"
" let g:JavaComplete_ShowExternalCommandsOutput = 1
" let g:JavaComplete_JavaviDebug = 0
" let g:JavaComplete_JavaviLogfileDirectory = '~/.javavi'

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
colorscheme orangehybrid

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

" Ignore these directories in all programs like ctrlp
set wildignore+=*/build/**
set wildignore+=*/.git/*
set wildignore+=*.class
set wildignore+=*/tmp/*

" change the mapleader from \ to , -- this makes it easier to perform compilation in LaTeX
let maplocalleader=","
let mapleader=","

" Adding in the conceal option for latex. Trying this out to see if I like the rendering of mathematics
set cole=2
let g:tex_conceal= 'adgms'
hi Conceal ctermbg=234 ctermfg=143

" Starting to use vim-latex and it needs several configurations to work correctly
let g:vimtex_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -shell-escape -interaction=nonstopmode -synctex=1'"
let g:vimtex_fold_enabled = 0
let g:vimtex_quickfix_mode = 2
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_toc_resize = 0
let g:vimtex_toc_hide_help = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_latexmk_enabled = 1
let g:vimtex_latexmk_continuous = 1
let g:vimtex_latexmk_callback = 1
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_view_method = 'mupdf'
let g:vimtex_view_mupdf_options = '-r 288'

" Configure nvim so that it uses the nvr program to support a server (helps
" with the use of vimtex, which needs a server to communicate with programs)
if has("nvim")
  let g:vimtex_latexmk_progname = 'nvr'
endif

" Configure nvim so that you can leave the terminal in the same as as you
" leave insert mode (otherwise, must use the ESC key, which is not consistent)
if has("nvim")
  tnoremap jk <C-\><C-n>
endif

" Configure nvim so that it uses the inccommand
if has("nvim")
  set inccommand=split
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


" let g:mta_use_matchparen_group = 0
" let g:mta_set_default_matchtag_color = 0

" let g:mta_filetypes = {
"     \ 'html' : 0,
"     \ 'xhtml' : 1,
"     \ 'xml' : 1,
"     \ 'jinja' : 1,
"     \ 'liquid' : 1,
"     \}

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
" set showmatch                                  " set show matching parenthesis
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

" Configure NeoVim so that it can use different cursor shapes when run in
" recent terminal windows
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" This is a configuration that should stop NeoVim from highlighting searching results
set nohlsearch

" Do not display the welcome message / splash screen when opening gvim or vim
" with no specified file
set shortmess=I

" Configure the airline status bar replacement that provides some delightful context
set laststatus=2
let g:airline_theme='tomorrow'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long', 'mixed-indent-file' ]
let g:airline#extensions#branch#enabled = 0
" let g:airline#extensions#hunks#non_zero_only = 0
" let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

set nosmd " turn off the status line that shows the silly word insert, airline is much better!


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

" Configuring the EasyTags and Ctrl-P plugins to better support tag creation and browsing and good syntax highlighting
set tags=./tags;/,tags;/
let g:easytags_ignored_filetypes = ''
let g:easytags_dynamic_files = 1
let g:easytags_updatetime_warn = 0
let g:easytags_always_enabled = 1
let g:easytags_async = 1

" Define a function that allows you to determine what syntax group is being used
map <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F5> :call SyntaxAttr()<CR>


" Automatically save changes before switching buffer with some
" commands, like :cnfile. Very useful when running Qdo on a QuickFix list
set autowrite

" Configure the syntax highlighting for the Java programming language
let java_highlight_all=1
let java_highlight_functions=1
let java_highlight_functions=1
let java_highlight_java_lang_ids=1
let java_space_errors=1
let java_comment_strings=1

" Configure the makeprg and the errorformat to support using Ant build systems for Java
autocmd Filetype java set makeprg=cd\ %:h\ &&\ ant\ -emacs\ -q\ -find\ build.xml
autocmd Filetype java set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

" " Configure Neomake to run on the save of every buffer
" autocmd! BufWritePost * Neomake

" Configure the signs that are used in Neomake displays
let g:neomake_error_sign = {
      \ 'text': '!',
      \ 'texthl': 'WarningMsg',
      \ }
let g:neomake_warning_sign = {
      \ 'text': '>',
      \ 'texthl': 'WarningMsg',
      \ }

" Configure a Neomake for running rlint
let g:neomake_r_rlint_maker = {
        \ 'exe': 'rlint',
        \ 'errorformat' :
        \ '%W%f:%l:%c: style: %m,' .
        \ '%W%f:%l:%c: warning: %m,' .
        \ '%E%f:%l:%c: error: %m,'
        \ }
let g:neomake_r_enabled_makers = ['rlint']

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
let R_openpdf = 0

" Add in a command that will allow me to remove the trailing white space
nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" Load matchit.vim, but only if the user hasn't installed a newer version.
" if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  " runtime! macros/matchit.vim
" endif

" Remove the feature that performs folding inside of Markdown files
let g:pandoc#modules#disabled = ["folding"]

" " Set up the CamelCaseMotion plugin so that it allows for movements with
" " variables in programs written in Java and R, for instance
call camelcasemotion#CreateMotionMappings('<leader>')

" Configure up and down line movement for virtual movement when there is no
" count used. But, when there is a count, move by physical lines instead
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

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
\  'options': '-m -x +s --no-bold',
\  'down':    '40%'})

" Define a custom command for loading hidden files as well as regular with FZF
command! FZFHidden call fzf#run({
\  'source':  'ag --hidden --ignore .git -l -g ""',
\  'sink':    'e',
\  'options': '-m -x +s --no-bold',
\  'down':    '40%'})

" Define a custom command for loading hidden files as well as regular with FZF
command! FZFMine call fzf#run({
\  'source':  'ag --ignore .git -l -g ""',
\  'sink':    'e',
\  'options': '-m -x +s --no-bold',
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
nmap <C-p> :FZFMine<CR>
" nmap <C-p> :FZF -m<CR>
nmap <C-h> :FZFHidden<CR>

" " Customize fzf colors to match your color scheme
" let g:fzf_colors =
" \ { 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'Normal'],
"   \ 'hl':      ['fg', 'Comment'],
"   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"   \ 'hl+':     ['fg', 'Statement'],
"   \ 'info':    ['fg', 'PreProc'],
"   \ 'prompt':  ['fg', 'Conditional'],
"   \ 'pointer': ['fg', 'Exception'],
"   \ 'marker':  ['fg', 'Keyword'],
"   \ 'spinner': ['fg', 'Label'],
"   \ 'header':  ['fg', 'Comment'] }

" " Configure the colors for fzf so that they fit my overall theme
" let g:fzf_colors =
" \ { 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'Normal'],
"   \ 'hl':      ['fg', 'Comment'],
"   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"   \ 'bg+':     ['bg', 'Normal', 'Normal'],
"   \ 'hl+':     ['fg', 'Statement'],
"   \ 'info':    ['fg', 'PreProc'],
"   \ 'prompt':  ['fg', 'Conditional'],
"   \ 'pointer': ['fg', 'Exception'],
"   \ 'marker':  ['fg', 'Keyword'],
"   \ 'spinner': ['fg', 'Label'],
"   \ 'header':  ['fg', 'Comment'] }

" Add in a format string for controlling how FZF will color-code when running
" a commands that shows the Git logs (Note that the blue is black by default)
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(blue)%C(bold)%cr"'

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=110 ctermbg=235
  highlight fzf2 ctermfg=110 ctermbg=235
  highlight fzf3 ctermfg=110 ctermbg=235
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Setup mappings that allow for the rotation of misspelled words to
" correctly-spelled words, using a plugin
nmap <silent> zn <Plug>(SpellRotateForward)
nmap <silent> zp <Plug>(SpellRotateBackward)
vmap <silent> zn <Plug>(SpellRotateForwardV)
vmap <silent> zp <Plug>(SpellRotateBackwardV)

let g:lt_location_list_toggle_map = '<leader>c'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Highlight the region that you have just yanked
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$
highlight default Flashy term=bold ctermbg=237 guibg=#13354A
let g:operator#flashy#flash_time = get(g:, 'operator#flashy#flash_time', 200)

let g:interestingWordsTermColors = ['143', '110', '173', '237', '110']
nnoremap <silent> <leader>z :call InterestingWords('n')<cr>
nnoremap <silent> <leader>u :call UncolorAllWords()<cr>
nnoremap <silent> <leader>n :call WordNavigation('forward')<cr>
nnoremap <silent> <leader>b :call WordNavigation('backward')<cr>

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
