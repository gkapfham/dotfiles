set nocompatible

" Plug {{{

call plug#begin('~/.vim/bundle')

" Load plugins for Vim8 and Neovim
Plug 'Chiel92/vim-autoformat'
Plug 'KeitaNakamura/highlighter.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Quramy/vim-js-pretty-template', {'for': 'javascript.jsx'}
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neco-syntax'
Plug 'SirVer/ultisnips'
Plug 'Valloric/ListToggle'
Plug 'airblade/vim-rooter'
Plug 'andymass/vim-matchup'
Plug 'artur-shaik/vim-javacomplete2', {'for': 'java'}
Plug 'bkad/CamelCaseMotion'
Plug 'bps/vim-textobj-python', {'for': 'python'}
Plug 'bronson/vim-visual-star-search'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'chrisbra/unicode.vim'
Plug 'christoomey/vim-sort-motion'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'easymotion/vim-easymotion'
Plug 'fszymanski/deoplete-emoji'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'itchyny/lightline.vim'
Plug 'jalvesaq/Nvim-R', {'for': 'r'}
Plug 'janko-m/vim-test', {'for': 'python'}
Plug 'jgdavey/tslime.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
Plug 'kana/vim-textobj-user'
Plug 'kshenoy/vim-signature'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'mgee/lightline-bufferline'
Plug 'mhinz/vim-signify'
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}
Plug 'pgdouyon/vim-evanesco'
Plug 'rbonvall/vim-textobj-latex', {'for': 'tex'}
Plug 'rhysd/github-complete.vim'
Plug 'shime/vim-livedown', {'for': 'markdown'}
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/vim-preview'
Plug 'spacewander/vim-coloresque'
Plug 'tfnico/vim-gradle'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tweekmonster/braceless.vim'
Plug 'tweekmonster/spellrotate.vim'
Plug 'ujihisa/neco-look'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'vim-scripts/python_match.vim'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wellle/tmux-complete.vim'
Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['html', 'md', 'liquid']}
Plug 'xolox/vim-misc'
Plug 'zchee/deoplete-jedi', {'for': 'python'}

" Conditionally load deoplete for Vim8 and Neovim
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Always load special fonts last
Plug 'ryanoasis/vim-devicons'

call plug#end()

" }}}

" System {{{

" Enable spell checking
syntax spell toplevel

" Configure the spelling files
set spellfile+=~/.config/nvim/spell/en.utf-8.add
set spellfile+=.extra.utf-8.add

" Make changes automatically saved during Qdo
set autowrite

" Enable spell checking with two dictionaries
set spell spelllang=en_us,en_gb
set mousemodel=popup

" Disable spell checking in source code
au BufNewFile,BufRead,BufEnter *.c    set nospell
au BufNewFile,BufRead,BufEnter *.h    set nospell
au BufNewFile,BufRead,BufEnter *.cpp  set nospell
au BufNewFile,BufRead,BufEnter *.hpp  set nospell
au BufNewFile,BufRead,BufEnter *.java set nospell
au BufNewFile,BufRead,BufEnter *.sh   set nospell
au BufNewFile,BufRead,BufEnter *.xml  set nospell
au BufNewFile,BufRead,BufEnter *.sql  set nospell
au BufNewFile,BufRead,BufEnter *.bib  set nospell

" Disable spell checking in quickfix
augroup quickfix
  autocmd!
  autocmd FileType qf setlocal nospell
augroup END

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

" Do not display messages
set shortmess=FIWacto
set confirm

" Display customized colorscheme
colorscheme orangehybrid

" Display line wraps
command! Wrap set textwidth=120
command! NoWrap set textwidth=0
command! StandardWrap set textwidth=80
set wrap linebreak nolist

" Display of line numbers
set number
set relativenumber

" Display screen redraws faster
set nocursorcolumn
set nocursorline
set ttyfast

" Disable these commands to improve
" screen performance in Neovim
set noshowcmd noruler

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
set timeoutlen=500
set ttimeoutlen=10

" Display indentation
set autoindent
set copyindent
set shiftwidth=2
set smartindent

" Display goes to the next line
set whichwrap+=<,>,h,l,[,]

" Do not display spaces at end of line
set nojoinspaces

" Display the location list and quickfix window
let g:lt_location_list_toggle_map = '<leader>c'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Do not display the standard status line
set noshowmode

" Always display the tabline so that lightline buffers can override
set showtabline=2

" Display icons in lightline buffer at screen top
let g:lightline#bufferline#enable_devicons = 1

" Do not shorten the path of a buffer
let g:lightline#bufferline#shorten_path = 1

" Do not show the buffer, as :b num nav not needed
let g:lightline#bufferline#show_number = 0

" Define a name of 'No Name' buffer
let g:lightline#bufferline#unnamed = '*'

" Remap arrow keys for navigating the lightline buffers
nnoremap <Space>j :bnext<CR>
nnoremap <Space>k :bprev<CR>

" Configure the lightline according to documentation and examples from statico/dotfiles
let g:lightline = {
      \ 'colorscheme': 'Orange_Hybrid',
      \ 'active': {
      \   'left': [ [ 'mode', 'spell', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
      \   'right': [['lineinfo'], ['percent'], ['linter_warnings', 'linter_errors', 'linter_ok', 'fileformat', 'fileencoding', 'filetype']]
      \ },
      \ 'component_function': {
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'spell': 'LightlineSpell',
      \   'filetype': 'LightlineFiletype',
      \   'fileformat': 'LightlineFileformat',
      \   'filename': 'LightlineFilename',
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
\ }

" Display a lock symbol if the file is read-only (e.g., help files)
function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

" Display symbols, not dictionaries, to indicate that spell-checking runs
function! LightlineSpell()
  return &spell ? 'A-Z✔ ' : ''
endfunction

" Display file name with symbol or '*' for 'No Name'
function! LightlineFilename()
  return '' !=# expand('%:t') ? ' '.expand('%:t') : ' *'
endfunction

" Display the name of the branch with a specialize symbol
function! LightlineFugitive()
  if exists('*fugitive#head')
    let l:branch = fugitive#head()
    return l:branch !=# '' ? ' שׂ '.l:branch : ''
  endif
  return ''
endfunction

" Detect and display the file type, using a dev-icon
function! LightlineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() . ' ' : 'no ft ') : ''
endfunction

" Detect and display the file format, using a dev-icon
function! LightLineFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) . ' ' : ''
endfunction

" Collect, count, and display the linter warnings from ale
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ', l:all_non_errors)
endfunction

" Collect, count, and display the linter errors from ale
function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ', l:all_errors)
endfunction

" Since there are no warnings or errors, display a zero count
function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '0   0 ' : ''
endfunction

" Update and show lightline but only if it's visible
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" Update the lightline linting errors if it is enabled
augroup alecallconfiguration
  autocmd User ALELint call s:MaybeUpdateLightline()
augroup END

" Configure the lightline buffer listing at top of the screen
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['bufnum']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

" Display the sign column for version control
set signcolumn=yes

" Configure how quickly interface updates
set updatetime=1000

" Configure the display of parentheses matching
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
map <F5> :call SyntaxAttr() <CR>

" Display the current block of text/code in a highlighting limelight
nmap <Space>f :Limelight!! <CR>

" Display the signature of a function in the footer of the screen
noremap <Space>s :PreviewSignature! <CR>

" Display special characters as sign column marks
let g:SignatureIncludeMarkers = '▶︎⏺@#$%ˆ&*('

" Do not display the match of an offscreen delimiter
let g:matchup_matchparen_status_offscreen = 0

" }}}

" Version Control {{{

" Only allow signify to manage Git repos
let g:signify_vcs_list = ['git']

" Configure signify to update rapidly
let g:signify_realtime              = 1
let g:signify_update_on_focusgained = 1
let g:signify_cursorhold_insert     = 0

" Define new display symbols for signify
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '^'
let g:signify_sign_change            = '~'
let g:signify_sign_changedelete      = g:signify_sign_change

" Configure magit to display in a minimal fashion
let g:magit_default_sections = ['commit', 'staged', 'unstaged']
let g:magit_default_fold_level = 1

" Define a command to load magit in full-screen mode
nmap <Space>g :MagitOnly <CR>

" Special configuration for magit buffers
augroup magitconfiguration
  autocmd!
  " Disable spell checking for the magit buffers
  autocmd FileType magit setlocal nospell

  " Do not display trailing spaces in magit
  autocmd FileType magit setlocal listchars=tab:▸▹,extends:#,precedes:#,nbsp:⌻
augroup END

" }}}

" Folding {{{

function! FancyFoldText()
  let line = getline(v:foldstart)
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')
  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return line . ' ' . repeat(" ",fillcharcount-8) . foldedlinecount . ' lines ' . ' '
endfunction
set foldtext=FancyFoldText()

" }}}

" Tags {{{

" Specify where the tags are stored
set tags=./tags;/,tags;/

" Perform highlighting asynchronously when file is loaded or saved
let g:highlighter#auto_update = 2

" }}}

" Programming Languages {{{

" Automatically identify the filetype
" Always use syntax highlighting
filetype indent plugin on | syn on

" Configure settings for different file types
augroup configurationgroupforfiletypes
  autocmd!
  " Set the completion function for different file types
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType tex set omnifunc=vimtex#complete#omnifunc
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType gitcommit setlocal omnifunc=github_complete#complete

  " Enable spellcheck for the git commit messages
  autocmd FileType gitcommit setlocal spell

  " Disable gutentags when editing a commit message
  au FileType gitcommit,gitrebase let g:gutentags_enabled=0

  " Configuration for Java programming filetype
  autocmd Filetype java compiler gradle

  " Configuration for Python programming language
  autocmd Filetype python setlocal softtabstop=4
  autocmd Filetype python setlocal shiftwidth=4
  autocmd FileType python BracelessEnable

  " Force hard wrapping for configuration files
  autocmd FileType conf set formatoptions+=t

  " Configuration for Mail that does soft wrapping
  autocmd Filetype mail call SetMailWrappingOptions()
  function! SetMailWrappingOptions()
    setlocal formatoptions=jtcqln
    setlocal wrap linebreak textwidth=0
    setlocal splitright
  endfunction

  " Create an invisible right-side buffer for wrapping
  autocmd Filetype mail call CreateInvisibleEmailBuffer()
  function! CreateInvisibleEmailBuffer()
    highlight EndOfBuffer ctermfg=bg
    " Note that trailing slash is by design
    setlocal fillchars+=vert:\
    75vnew
    setlocal nonumber norelativenumber
    wincmd w
    command! Quit :wqa
  endfunction
  command! Email call CreateInvisibleEmailBuffer()

  " When linting is costly in Java, only perform it in normal mode
  autocmd Filetype java call SetJavaLintingOptions()
  function! SetJavaLintingOptions()
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_delay = 500
    let g:ale_lint_on_enter = 0
  endfunction

  " When linting is costly in LaTeX, only perform it in normal mode
  autocmd Filetype tex call SetLatexLintingOptions()
  function! SetLatexLintingOptions()
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_delay = 500
    let g:ale_lint_on_enter = 0
  endfunction
augroup END

" Syntax highlighting for JavaScript and JSX
let g:jsx_ext_required = 0

" Syntax highlighting for Java
let java_highlight_all=1
let java_highlight_functions=1
let java_highlight_functions=1
let java_highlight_java_lang_ids=1
let java_space_errors=1
let java_comment_strings=1

" Plugin configuration for R
let R_assign = 2
let R_openpdf = 0
let R_show_args = 1

" Force Jedi to use version 3
let g:jedi#force_py_version = 3

" Run the black formatter on current Python file
command! Black cexpr system('black ' . shellescape(expand('%')))<bar>:checktime

" Run the black formatter on all of the Python files
command! Blacken cexpr system('black **/*.py')<bar>:checktime

" If using yapf, format Python code according to PEP8
let g:formatter_yapf_style = 'pep8'

" Set the hosts programs for Python and Python3
" That this improves performance when loading deoplete
let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Turn on the EchoDoc plugin for languages like Python
let g:echodoc#enable_at_startup = 1

" Indenting for HTML
au BufRead,BufNewFile *.html set filetype=html
let g:html_indent_inctags = 'html,body,head,tbody,div'

" Do not perform folding inside of Markdown
let g:pandoc#modules#disabled = ['folding']

" Preview the Markdown
let g:livedown_autorun = 0
let g:livedown_open = 0
let g:livedown_port = 4200

" Autodetect CSV
autocmd BufRead,BufNewFile *.csv,*.dat set filetype=csv

" Define linting for email
let g:ale_linter_aliases = {'mail': 'tex', 'liquid': 'markdown'}

" Use eslint for JavaScript
" Use htmlhint for HTML
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'html': ['htmlhint'],
      \}

let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign WarningMsg

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

" Deoplete is compatible with UltiSnips
let g:UltiSnipsExpandTrigger='<C-k>'
let g:UltiSnipsJumpForwardTrigger='<C-k>'
let g:UltiSnipsJumpBackwardTrigger='<C-j>'

" Completion compatible with the tmux-complete
let g:tmuxcomplete#trigger = 'omnifunc'

" Do not echo messages (nor will searches)
set noshowmode

" Infer the case when doing completion
set infercase

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
let maplocalleader=','
let mapleader=','

" Move through CamelCase text
call camelcasemotion#CreateMotionMappings('<leader>')

" Navigate through wrapped text
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Navigate to the next linting warning/error
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Quickly switch between two recent buffers
function! SwitchBuffer()
  b#
endfunction
nmap <C-u> :call SwitchBuffer()<CR>

" }}}

" Advanced Search Highlighting {{{

" Incrementally highlight the search matches
set incsearch

" Support the highlighting of words
nnoremap <silent><expr> <Leader>i (&hls && v:hlsearch ? ':set nohlsearch' : ':set hlsearch')."\n"

" Carefully ignore the case of words when searching
set ignorecase
set smartcase

" }}}

" Advanced Keyboard Movement with easymotion {{{

" Make f and s movements use easymotion
nmap f <Plug>(easymotion-s)
nmap s <Plug>(easymotion-s2)
nmap <leader>e <Plug>(easymotion-next)
nmap <leader>E <Plug>(easymotion-prev)

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

" }}}

" Text Manipulation {{{

" Insert a blank line at end of line
nmap oo Ojk

" Insert a blank line at cursor
nnoremap oO i<CR><ESC>

" Support the backspace key in insert mode
set backspace=indent,eol,start

" Interactive EasyAlign in visual mode (e.g., 'vipga')
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g., gaip)
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

" File System {{{

augroup dirvishconfiguration
  autocmd!
  " Disable spell checking for the Dirvish buffers
  autocmd FileType dirvish setlocal nospell

  " Enable :Gstatus and friends
  autocmd FileType dirvish call fugitive#detect(@%)

  " Map `gr` to reload the Dirvish buffer
  autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

  " Map `gh` to hide dot-prefixed files
  " To toggle this, press `R` to reload
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
augroup END

" }}}

" Fugitive {{

" Run Fugitive commands asynchronously using AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" }}}

" FZF {{

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
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '25%')}

" Load hidden files
command! FZFHidden call fzf#run({
      \  'source':  'ag --hidden --ignore .git -l -g ""',
      \  'sink':    'e',
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '25%'})

" Load non-hidden files
command! FZFMine call fzf#run({
      \  'source':  'ag --ignore .git -l -g ""',
      \  'sink':    'e',
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '25%'})

" Define key combinations
nmap <C-h> :FZFHidden<CR>
nmap <C-p> :FZFMine<CR>
nmap <Space>y :Tags <CR>
nmap <Space>t :BTags <CR>
nmap <Space>b :BLines <CR>
nmap <Space>r :Lines <CR>
nnoremap <Tab> :Buffers<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

" Add in a format string for controlling how FZF git logs
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(blue)%C(bold)%cr"'

" Configure the fzf statusline in Neovim
function! s:fzf_statusline()
  " Define colors for the statusline
  highlight fzf1 ctermfg=235 ctermbg=110 cterm=bold
  highlight fzf2 ctermfg=235 ctermbg=110 cterm=bold
  highlight fzf3 ctermfg=110 ctermbg=235
  setlocal statusline=%#fzf1#\ \ %#fzf2#FZF\ \ \ \%#fzf3#
endfunction

" Display a customized statusline when invoking fzf
" Note that this will not always trigger if in an augroup
autocmd! User FzfStatusLine call <SID>fzf_statusline()

" }}}

" Tmux {{{

" Send commands to tmux pages
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars
let g:tslime_always_current_session = 1

" }}}

" Testing {{{

" Run all/part of a test suite
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>

" Run the test suite async and display in quickfix
let test#strategy = "tslime"

" }}}

" Neovim Configuration {{{

" Do not use a different cursor shape
if has("nvim")
  set guicursor=
endif

" Use nvr for remove communication
if has("nvim")
  let g:vimtex_latexmk_progname = 'nvr'
endif

" Leave using a different command than ESC
if has("nvim")
  inoremap <ESC> <C-\><C-n>
  tnoremap jk <C-\><C-n>
  nmap oo O<ESC>
endif

" Use the new inccommand
if has("nvim")
  set inccommand=split
endif

" Set the clipboard to use xclip (not xsel)
if has("nvim")
  let g:clipboard = {
        \   'name': 'NeovimClipboard',
        \   'copy': {
        \      '+': 'xclip -i -selection clipboard',
        \      '*': 'xclip -i -selection clipboard',
        \    },
        \   'paste': {
        \      '+': 'xclip -o -selection clipboard',
        \      '*': 'xclip -o -selection clipboard',
        \   },
        \   'cache_enabled': 1,
        \ }
endif

" Highlight trailing spaces
if has("nvim")
  highlight ExtraWhitespace ctermfg=172 ctermbg=234
  match ExtraWhitespace /\s\+$\|\t/
  augroup extra_whitespace
    autocmd!
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
  augroup END
endif

" Ensure that Neovim exits quickly and gives no line numbers when using fzf
if has('nvim')
  aug fzf_setup
    au!
    au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
    au TermOpen term://*FZF setlocal nonumber nornu
  aug END
end

" }}}

" Advanced FZF and Deoplete Settings {{{

" Control FZF windows
command! FZFMru call fzf#run({
      \  'source':  v:oldfiles,
      \  'sink':    'e',
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '10%',
      \  'window':  'enew'})
command! FZFHidden call fzf#run({
      \  'source':  'ag --hidden --ignore .git -l -g ""',
      \  'sink':    'e',
      \  'options': '-m -x +s --no-bold --cycle',
      \  'window':  'enew'})
command! -bang FZFMine call fzf#run({
      \  'source':  'ag --ignore .git -l -g ""',
      \  'sink':    'e',
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '100%',
      \  'window':  'enew'})
let g:fzf_layout = { 'window': 'enew' }

" autocmd! FileType fzf
" autocmd  FileType fzf set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Configure deoplete
let g:deoplete#enable_at_startup = 0
autocmd InsertEnter * call deoplete#enable()

" Immediately trigger the deoplete completion
call deoplete#custom#option('auto_complete_delay', 0)

" Set the maximum width of the abbreviations
call deoplete#custom#source('_', 'max_abbr_width', 40)

" Configure deoplete to use Tab for forward and backward movement
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<s-TAB>"

" Define the cache limit for the tag files
let g:deoplete#tag#cache_limit_size = 500000

" Use the head matching algorithm for speed improvements
call deoplete#custom#source('_', 'matchers', ['matcher_head'])

" Set the refresh delay to be 25 ms
call deoplete#custom#option('auto_refresh_delay', '25')

" Since a dictionary is already sorted, no need to sort it again
call deoplete#custom#source(
      \ 'dictionary', 'sorters', [])
" Do not complete words that are too short
call deoplete#custom#source(
      \ 'dictionary', 'min_pattern_length', 4)

" Change the source rankings: higher value means higher priority
call deoplete#custom#source('around', 'rank', 600)
call deoplete#custom#source('buffer', 'rank', 600)
call deoplete#custom#source('member', 'rank', 600)
call deoplete#custom#source('ultisnips', 'rank', 400)
call deoplete#custom#source('look', 'rank', 300)
call deoplete#custom#source('tmux', 'rank', 200)
call deoplete#custom#source('tag', 'rank', 100)

" Define the emoji plugin as a source
call deoplete#custom#source('emoji', 'filetypes', ['markdown', 'gitcommit'])

" Register Java's completion function with deoplete
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.java = [
      \ 'javacomplete#Complete'
      \]

" Register a GitHub completion function with deoplete
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.gitcommit = [
      \ 'github_complete#complete'
      \]

" Define the input_patterns mapping so that it can be configured
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

" Configure deoplete to work with LaTeX and the vimtex plugin
let g:deoplete#omni#input_patterns.tex = '\\(?:'
      \ .  '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
      \ . '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
      \ . '|hyperref\s*\[[^]]*'
      \ . '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|(?:include(?:only)?|input)\s*\{[^}]*'
      \ . '|\w*(gls|Gls|GLS)(pl)?\w*(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|includepdf(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|includestandalone(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|usepackage(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|documentclass(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|\w*'
      \ .')'

" Configure deoplete to work with GitHub issue completion
let g:deoplete#omni#input_patterns.gitcommit = '#[0-9]*'

" Allow completion from different sources with a plugin
if !exists('g:context_filetype#same_filetypes')
  let g:context_filetype#same_filetypes = {}
endif

" In gitcommit buffers, completes from all buffers
let g:context_filetype#same_filetypes.gitcommit = '_'
" In default, completes from all buffers
let g:context_filetype#same_filetypes._ = '_'

" Disable jedi-vim's completion engine, use all features otherwise
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0

" }}}
