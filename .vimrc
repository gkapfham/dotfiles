set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'SirVer/ultisnips'
Plug 'Valloric/ListToggle'
Plug 'Valloric/MatchTagAlways'
Plug 'Valloric/YouCompleteMe'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'alfredodeza/pytest.vim'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'benmills/vimux'
Plug 'bkad/CamelCaseMotion'
Plug 'bronson/vim-visual-star-search'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'christoomey/vim-sort-motion'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'garbas/vim-snipmate'
Plug 'gilligan/textobj-gitgutter'
Plug 'gorodinskiy/vim-coloresque'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/vim-operator-flashy'
Plug 'henrik/vim-qargs'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent'
Plug 'jalvesaq/Nvim-R'
Plug 'janko-m/vim-test'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'jgdavey/tslime.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-textobj-user'
Plug 'kshenoy/vim-signature'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'rbonvall/vim-textobj-latex', {'for': 'latex'}
Plug 'shime/vim-livedown', {'for': 'markdown'}
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
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
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wellle/tmux-complete.vim'
Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'

" Always load special fonts last
Plug 'ryanoasis/vim-devicons'

call plug#end()

" System {{{

"Enable spell checking
syntax spell toplevel

" Make changes automatically saved during Qdo
set autowrite

" Enable spell checking
set spell spelllang=en_us,en_gb
set mousemodel=popup

" Disable spell checking in source code
au BufNewFile,BufRead,BufEnter *.c      set nospell
au BufNewFile,BufRead,BufEnter *.h      set nospell
au BufNewFile,BufRead,BufEnter *.cpp    set nospell
au BufNewFile,BufRead,BufEnter *.hpp    set nospell
au BufNewFile,BufRead,BufEnter *.java   set nospell
au BufNewFile,BufRead,BufEnter *.sh     set nospell
au BufNewFile,BufRead,BufEnter *.xml    set nospell
au BufNewFile,BufRead,BufEnter *.sql    set nospell
au BufNewFile,BufRead,BufEnter *.bib    set nospell

" Ignore these directories
set wildignore+=*/build/**
set wildignore+=*/.git/*
set wildignore+=*.class
set wildignore+=*/tmp/*

" Set levels for history an undo
set history=1000
set undolevels=1000

" Set persistent undo
set undofile
set undodir=~/.vim/undo

" Source the vimrc file
command! Reload :source $MYVIMRC

" }}}

" Display Improvements {{{

" Display encoding to UTF-8
set encoding=utf-8

" Display italics in terminal
set t_ZH=[3m
set t_ZR=[23m

" Do not display search highlights
set nohlsearch

" Do not display the welcome message
set shortmess=Ic

" Display colorscheme
colorscheme orangehybrid

" Display line wraps
command! Wrap set textwidth=120
command! NoWrap set textwidth=0
command! StandardWrap set textwidth=80
set wrap linebreak nolist

" Display of line numbers
set relativenumber
set number

" Display screen redraws faster
set nocursorcolumn
set nocursorline
set ttyfast

" Display linebreaks and tabs
set linebreak
set showbreak=━━
set breakindent
set tabstop=4

" Insert spaces for tab
set expandtab
set smarttab
set shiftround

" Display problematic whitespace
set listchars=tab:▸▹,trail:•,extends:#,precedes:#,nbsp:⌻
set list

" Display with faster timeouts in the TUI
set timeoutlen=1000 ttimeoutlen=10

" Display matching parentheses
set showmatch

" Run the matchit macro for tag matching
runtime macros/matchit.vim

" Display indentation
set autoindent
set copyindent
set shiftwidth=2
set smartindent

" Display goes to the next line
set whichwrap+=<,>,h,l,[,]

" Do not display spaces at end of line
set nojoinspaces

" Highlight yanked region
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$
highlight default Flashy term=bold ctermbg=237 guibg=#13354A
let g:operator#flashy#flash_time = get(g:, 'operator#flashy#flash_time', 200)

" Display the location list and quickfix window
let g:lt_location_list_toggle_map = '<leader>c'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Display the airline statusline
set laststatus=2
let g:airline_theme='tomorrow'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long', 'mixed-indent-file' ]
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

" Do not display the standard status line
set noshowmode

" Display version control details in gutter
let g:gitgutter_async = 1
let g:gitgutter_eager = 1
let g:gitgutter_realtime = 1
let g:gitgutter_sign_column_always = 1
let g:gitgutter_signs = 1

" Use a different symbol in the gutter
let g:gitgutter_sign_removed_first_line = '^'

let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'liquid' : 1,
    \}

" Display the syntax group for the symbol under the cursor
map <F4> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F5> :call SyntaxAttr()<CR>

" }}}

" Tags {{{

set tags=./tags;/,tags;/
let g:easytags_ignored_filetypes = ''
let g:easytags_dynamic_files = 1
let g:easytags_updatetime_warn = 0
let g:easytags_always_enabled = 1
let g:easytags_async = 1

" }}}

" Programming Languages {{{

" Automatically identify the filetype for the plugins and always use syntax highlighting
filetype indent plugin on | syn on

" Set the completion function for a variety of different file types
augroup configurationgroupforfiletypes
  autocmd!
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType tex set omnifunc=vimtex#complete#omnifunc
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType gitcommit setlocal spell
  autocmd Filetype java set makeprg=cd\ %:h\ &&\ ant\ -emacs\ -q\ -find\ build.xml
  autocmd Filetype java set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
  autocmd Filetype python setlocal softtabstop=4
  autocmd Filetype python setlocal shiftwidth=4
augroup END

" Syntax highlighting for Java
let java_highlight_all=1
let java_highlight_functions=1
let java_highlight_functions=1
let java_highlight_java_lang_ids=1
let java_space_errors=1
let java_comment_strings=1

" Plugin configuration for R
let R_assign = 2
let R_tmux_split = 1
let R_openpdf = 0

" Indenting for HTML
au BufRead,BufNewFile *.html set filetype=html
let g:html_indent_inctags = 'html,body,head,tbody,div'

" Do not perform folding inside of Markdown
let g:pandoc#modules#disabled = ['folding']

" Preview the Markdown
let g:livedown_autorun = 0
let g:livedown_open = 0
let g:livedown_port = 4200
nmap <leader>gmd :LivedownPreview<CR>

" Autodetect CSV
autocmd BufRead,BufNewFile *.csv,*.dat set filetype=csv

" Define linting for email
let g:ale_linter_aliases = {'mail': 'tex'}

" }}}

" LaTeX {{{

" Configure vimtex

let g:vimtex_fold_enabled = 0
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_show_help = 0
let g:vimtex_view_method = 'mupdf'
let g:vimtex_view_mupdf_options = '-r 288'

" Conceal option
set conceallevel=2
let g:tex_conceal= 'adgms'
hi Conceal ctermbg=NONE ctermfg=172

" Use tex over plaintex
let g:tex_flavor = 'tex'

" Vimtex requires
set hidden

" }}}

" Completion {{{

" Define basic completion function
set omnifunc=syntaxcomplete#Complete

" Define the dictionaries
set dictionary-=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english

" Completion includes dictionaries
set complete-=k complete+=k
set complete+=kspell
set complete+=]

" Completion menus
set completeopt=longest,menuone
set wildmenu
set wildmode=longest:full,full

" YCM
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_filetype_blacklist = {
        \ 'qf' : 1,
        \ 'notes' : 1,
        \ 'unite' : 1,
        \ 'text' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \}

" YCM uses python (python3 is also an option)
let g:ycm_server_python_interpreter = '/usr/bin/python'

" YCM is compatible with UltiSnips
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsListSnippets = "<C-l>"
let g:UltiSnipsJumpBackwardTrigger='<C-s-k>'
let g:UltiSnipsJumpBackwardTrigger=""

" YCM is compatible with the tmux-complete
let g:tmuxcomplete#trigger = 'omnifunc'

" YCM is compatible with the vimtex

if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
      \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
      \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
      \ 're!\\hyperref\[[^]]*',
      \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
      \ 're!\\(include(only)?|input){[^}]*',
      \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
      \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\usepackage(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\documentclass(\s*\[[^]]*\])?\s*\{[^}]*',
      \ ]

" YCM will not echo messages (nor will searches)
set noshowmode

" }}}

" Basic Keyboard Movement {{{

" Disable the arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap jk <ESC>
inoremap <ESC> <NOP>

" Define the leaders
let maplocalleader=","
let mapleader=","

" Move through CamelCase text
call camelcasemotion#CreateMotionMappings('<leader>')

" Navigate through wrapped text
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Navigate to the next linting warning/error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Format a paragraph quickly
nmap fp gqip

" }}}

" Advanced Keyboard Movement with incsearch {{{

" Basic motions using incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-easymotion-/)
map g? <Plug>(incsearch-easymotion-?)
map <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

" Define a function for fuzzy searching
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

" Perform fuzzy searching
noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

" Support the highlighting of words
nnoremap <leader>* :set hlsearch<cr>*<c-o>
nnoremap <silent><expr> <Leader>i (&hls && v:hlsearch ? ':set nohlsearch' : ':set hlsearch')."\n"

" }}}

" Advanced Keyboard Movement with easymotion {{{

nmap f <Plug>(easymotion-s)
nmap s <Plug>(easymotion-s2)
" nmap t <Plug>(easymotion-t2)

" Change the color scheme
hi link EasyMotionTarget Type
hi link EasyMotionShade Comment
hi link EasyMotionIncSearch Type
hi link EasyMotionIncCursor Type
hi link EasyMotionMoveHL Type

" Do not create the shaded background
let g:EasyMotion_do_shade = 0

" Use uppercase letters
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;'

" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)
" map  ? <Plug>(easymotion-sn)
" omap ? <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)

" }}}

" Text Manipulation {{{

" Insert a blank line
nmap oo Ojk

" Support the backspace key in insert mode
set backspace=indent,eol,start

" Interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Toggle off the auto-completion of pairs
let g:AutoPairsShortcutToggle = '<leader>apt'

" Remove trailing whitespace
nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" Fix a misspelling with next-best word
nmap <silent> zn <Plug>(SpellRotateForward)
nmap <silent> zp <Plug>(SpellRotateBackward)
vmap <silent> zn <Plug>(SpellRotateForwardV)
vmap <silent> zp <Plug>(SpellRotateBackwardV)

" Toggle the display of spelling mistakes
nmap <silent> <leader>s :set spell!<CR>

" }}}

" FZF {{{

" Mapping selecting mappings
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
\  'down':    '25%')}

" Load hidden files
command! FZFHidden call fzf#run({
\  'source':  'ag --hidden --ignore .git -l -g ""',
\  'sink':    'e',
\  'options': '-m -x +s --no-bold',
\  'down':    '25%'})

" Load non-hidden files
command! FZFMine call fzf#run({
\  'source':  'ag --ignore .git -l -g ""',
\  'sink':    'e',
\  'options': '-m -x +s --no-bold',
\  'down':    '25%'})

" Define key combinations
nmap <C-h> :FZFHidden<CR>
nmap <C-p> :FZFMine<CR>
nmap <C-i> :Tags <C-R><C-W><CR>
nmap <C-t> :BTags <CR>
nmap <C-u> :FZFMru<CR>
nnoremap <Tab> :Buffers<Cr>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

" Add in a format string for controlling how FZF git logs
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(blue)%C(bold)%cr"'

" Configure the fzf statusline in Neovim
function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=110 ctermbg=235
  highlight fzf2 ctermfg=110 ctermbg=235
  highlight fzf3 ctermfg=110 ctermbg=235
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

augroup configurationgroupforfzf
  autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END

" }}}

" Tmux {{{

vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

" }}}

" Testing {{{

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
" nmap <silent> <leader>g :TestVisit<CR>

let test#strategy = "vimux"

" }}}

" Neovim Display and Configuration {{{

" Use a different cursor shape
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Use nvr for remove communication
if has("nvim")
  let g:vimtex_latexmk_progname = 'nvr'
endif

" Leave using a different command than ESC
if has("nvim")
  inoremap <ESC> <C-\><C-n>
  nmap oo O<ESC>
endif

" Use the new inccommand
if has("nvim")
  set inccommand=split
endif

" Highlight trailing spaces
if has("nvim")
  highlight ExtraWhitespace ctermfg=172
  match ExtraWhitespace /\s\+$\|\t/
endif

" Control FZF windows
if has("nvim")
command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s --no-bold',
\  'down':    '10%',
\  'window':  'enew'})
command! FZFHidden call fzf#run({
\  'source':  'ag --hidden --ignore .git -l -g ""',
\  'sink':    'e',
\  'options': '-m -x +s --no-bold',
\  'down':    '10%'})
command! -bang FZFMine call fzf#run({
\  'source':  'ag --ignore .git -l -g ""',
\  'sink':    'e',
\  'options': '-m -x +s --no-bold',
\  'down':    '100%',
\  'window':  'enew'})
let g:fzf_layout = { 'window': 'enew' }
endif

" }}}
