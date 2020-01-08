set nocompatible

" Plug {{{

call plug#begin('~/.vim/bundle')

" Load plugins for Vim8 and Neovim
Plug 'Chiel92/vim-autoformat'
Plug 'ColinKennedy/vim-textobj-block-party'
Plug 'KeitaNakamura/highlighter.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Quramy/vim-js-pretty-template', {'for': 'javascript.jsx'}
Plug 'RRethy/vim-hexokinase'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neco-syntax'
Plug 'SirVer/ultisnips'
Plug 'Valloric/ListToggle'
Plug 'airblade/vim-rooter'
Plug 'andymass/vim-matchup'
Plug 'bkad/CamelCaseMotion'
Plug 'bronson/vim-visual-star-search'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'chrisbra/unicode.vim'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'easymotion/vim-easymotion'
Plug 'fgrsnau/ncm2-otherbuf', {'branch': 'master'}
Plug 'filipekiss/ncm2-look.vim'
Plug 'garbas/vim-snipmate'
Plug 'gkapfham/vim-vitamin-onec'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': 'markdown'}
Plug 'itchyny/lightline.vim'
Plug 'jalvesaq/Nvim-R', {'for': 'r'}
Plug 'janko-m/vim-test', {'for': 'python'}
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'jez/vim-github-hub'
Plug 'jgdavey/tslime.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-dirvish'
Plug 'kana/vim-textobj-user'
Plug 'kshenoy/vim-signature'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'lifepillar/vim-colortemplate'
Plug 'liuchengxu/vista.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'mgee/lightline-bufferline'
Plug 'mhinz/vim-signify'
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'ncm2/float-preview.nvim'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-syntax'
Plug 'ncm2/ncm2-tagprefix'
Plug 'ncm2/ncm2-ultisnips'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}
Plug 'pgdouyon/vim-evanesco'
Plug 'rbonvall/vim-textobj-latex', {'for': 'tex'}
Plug 'rhysd/git-messenger.vim'
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
Plug 'skywind3000/asyncrun.vim'
Plug 'tfnico/vim-gradle'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tweekmonster/braceless.vim'
Plug 'tweekmonster/spellrotate.vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'vim-scripts/python_match.vim'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wellle/tmux-complete.vim'
Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['html', 'md', 'liquid']}
Plug 'xolox/vim-misc'

" Conditionally load ncm2 for Vim8 and Neovim
"
" Running Neovim, so a connector is not needed
if has('nvim')
  Plug 'ncm2/ncm2'
  Plug 'roxma/nvim-yarp'
" Running Vim8, so a connector is needed
else
  Plug 'ncm2/ncm2'
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

" Correct spelling mistakes from insert mode
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

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

" Color Scheme {{{

" Use true-color in the terminal
set termguicolors

" Use customized colorscheme
colorscheme vitaminonec

" Set color for concealment with limelight
" NOTE: In this file because there are no
" highlight groups to move to color scheme
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = '#585858'

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
" WARNING: may crash Neovim 0.4.0-dev
" set copyindent
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

" Enable for all filetypes
let g:Hexokinase_ftAutoload = ['colortemplate', 'conf', 'css', 'html', 'markdown']

" Increase size of display of all registers through the peekaboo plugin
let g:peekaboo_window = 'vert bo 40new'

" Special configuration for peekaboo buffers
augroup peekabooconfiguration
  autocmd!
  " Disable spell checking for the peekaboo buffers
  autocmd FileType peekaboo setlocal nospell
augroup END

" }}}

" Lightline for Status Line and Buffer Line {{{

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

" Configure the lightline according to documentation and examples from statico/dotfiles
let g:lightline = {
      \ 'colorscheme': 'vitaminonec',
      \ 'active': {
      \   'left': [ [ 'mode', 'spell', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'context', 'modified' ] ],
      \   'right': [['lineinfo'], ['percent'], ['linter_warnings', 'linter_errors', 'linter_ok', 'fileformat', 'fileencoding', 'filetype'], ['gutentags']]
      \ },
      \ 'component_function': {
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'spell': 'LightlineSpell',
      \   'filetype': 'LightlineFiletype',
      \   'fileformat': 'LightlineFileformat',
      \   'filename': 'LightlineFilename',
      \   'gutentags': 'LightlineGutentags',
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK',
      \   'context': 'NearestMethodOrFunction'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
\ }

" Ensure that the lightline status bar updates
augroup GutentagsStatusLineRefresher
  autocmd!
  autocmd User GutentagsUpdating call lightline#update()
  autocmd User GutentagsUpdated call lightline#update()
augroup END

" Display a diagnostic message when gutentags updates
function! LightlineGutentags()
  return gutentags#statusline() !=# '' ? '  Tags ' : 'Tags '
endfunction

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

" }}}

" Version Control {{{

" Only allow signify to manage Git repos
" This allows signify to perform faster
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

" Define text objects for the changed hunks
" This adds support for:
" --> "vic" : visual selection of entire-changed hunk
" --> "vac" : visual selection of no-blank-line changed hunk
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)

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

" Configure the git-messenger
augroup gitmessenger
" Define a mapping to navigate the git-messenger pop-up
function! SetupGitMessengerPopup() abort
    " Go into the git-messenger pop-up to navigate
    nmap <Leader>gg <Plug>(git-messenger-into-popup)
    " Go to an older commit
    nmap <buffer><C-o> o
    " Go to a newer commit
    nmap <buffer><C-i> O
endfunction
autocmd FileType gitmessengerpopup call SetupGitMessengerPopup()
augroup END

" }}}

" Folding {{{

function! FancyFoldText()
  let l:line = getline(v:foldstart)
  let l:nucolwidth = &foldcolumn + &number * &numberwidth
  let l:windowwidth = winwidth(0) - l:nucolwidth - 3
  let l:foldedlinecount = v:foldend - v:foldstart
  let l:onetab = strpart('          ', 0, &tabstop)
  let l:line = substitute(l:line, '\t', l:onetab, 'g')
  let l:line = strpart(l:line, 0, l:windowwidth - 2 -len(l:foldedlinecount))
  let l:fillcharcount = l:windowwidth - len(l:line) - len(l:foldedlinecount)
  return l:line . ' ' . repeat(' ',l:fillcharcount-8) . l:foldedlinecount . ' lines ' . ' '
endfunction
set foldtext=FancyFoldText()

" }}}

" Tags {{{

" Specify where the tags are stored
set tags=./tags;/,tags;/

" Perform highlighting asynchronously when file is loaded or saved
let g:highlighter#auto_update = 2

" Perform tag generation in existence of a '.maketags' marker file
let g:gutentags_project_root = ['.maketags']

" Use Vista to determine the context (e.g., function definition)
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

" Always run the function to capture the context
" Note that using an augroup does not seem to work correctly
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" Define a command to support the toggle of Vista's display of tags
nnoremap <Space>v :Vista!!<cr>

" Enable the display of icons in the Vista interface
let g:vista#renderer#enable_icon = 1

" Configure how Vista shows a location when navigating its interface
let g:vista_echo_cursor_strategy = 'echo'

" Allow Vista to create data for display in the lightline
let g:vista_disable_statusline = 0

" Define icon mappings for the cases when the defaults do not match
" Note that Vista defines "class" and "method" but not the plural
" Summary of the icon definitions:
" --> Java: classes, methods
" --> LaTeX: labels, sections, subsections, subsubsections
" --> VimScript: autocommand groups, commands, maps
" --> Default: use a box with a circle instead of question mark
let g:vista#renderer#icons = {
\   'S': "\uf7fd",
\   'c': "\uf7fd",
\   's': "\uf7fd",
\   'autocommand groups': "\uf136",
\   'classes': "\uf0e8",
\   'commands': "\uf8a3",
\   'labels': "\uf71b",
\   'maps': "\uf8a3",
\   'methods': "\uf6a6",
\   'sections': "\uf7fd",
\   'subsections': "\uf7fd",
\   'subsubsections': "\uf7fd",
\   'default': "\uf7fd",
\  }

" }}}

" Programming Languages {{{

" Automatically identify the filetype
" Always use syntax highlighting
filetype indent plugin on | syn on

" Always continue a comment in code to
" the next line when pressing "return"
set formatoptions+=r

" Define a color scheme for Python source code highlighting
augroup semshiconfiguration
  let g:semshi#error_sign = v:false
augroup END

" Configure settings for different file types
augroup configurationgroupforfiletypes
  autocmd!
  " Set the completion function for different file types
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType tex set omnifunc=vimtex#complete#omnifunc
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

  " Configuration for Mail that does hard wrapping
  " Assume user will perform soft wrapping with vipJ
  " Multiple approaches with soft wrapping slowed
  " completion the completion engine; try new method
  autocmd Filetype mail call SetMailWrappingOptions()
  function! SetMailWrappingOptions()
    setlocal formatoptions=jtcqn
    setlocal wrap linebreak textwidth=80
  endfunction

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
" NOTE: this is not the standard method, but
" I adopted it because Black did not work well
" with virtual environments created by Pipenv
command! Black cexpr system('black ' . shellescape(expand('%')))<bar>:checktime

" Run the black formatter on all of the Python files
command! Blacken cexpr system('black **/*.py')<bar>:checktime

" If using yapf, format Python code according to PEP8
" Note that I should standardly use :Black and :Blacken
let g:formatter_yapf_style = 'pep8'

" Set the hosts programs for Python and Python3
" This improves performance when loading plugins using Python
let g:python_host_prog  = '/usr/bin/python'
if filereadable('/usr/local/bin/python3')
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python3_host_prog = '/usr/bin/python3'
endif

" Turn on the EchoDoc plugin for languages like Python
let g:echodoc#enable_at_startup = 1

" Indenting for HTML
au BufRead,BufNewFile *.html set filetype=html
let g:html_indent_inctags = 'html,body,head,tbody,div'

" Do not perform folding inside of Markdown
let g:pandoc#modules#disabled = ['folding']

" Preview for Markdown
let g:mkdp_browser = '/usr/bin/firefox'
let g:mkdp_page_title = '${name}'
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_echo_preview_url = 1

" Autodetect CSV
autocmd BufRead,BufNewFile *.csv,*.dat set filetype=csv

" Define linting for email
let g:ale_linter_aliases = {'mail': 'tex', 'liquid': 'markdown'}

" Configure the linters run by ALE
" JavaScript: eslint
" HTML: htmlhint
" Python: flake8, pylint, pydocstyle
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'html': ['htmlhint'],
      \   'python': ['flake8', 'pylint', 'pydocstyle'],
      \}

" Configure the symbols for linting warnings and errors
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'

" }}}

" Markdown {{{

" First command: Make a list item in markdown a task
" Second command: Mark a task in markdown as done
" These two commands work for normal mode and visual mode
nnoremap <silent> <Space>w :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[<space>]<space>/<CR>0f]h
nnoremap <silent> <Space>d :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[X]<space>/<CR>0f]h
vnoremap <silent> <Space>w :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[<space>]<space>/<CR>0f]h
vnoremap <silent> <Space>d :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[X]<space>/<CR>0f]h

" Convert the checkmark symbol, which is not on the keyboard, to a dash.
" This command enables suitable display of GatorGrader results in markdown files.
command! -range=% Checkmark <line1>,<line2> :s/✔ /-/g

" Convert the single quote symbol, to a backtick, aiding conversion to markdown
" This command also enables suitable display of GatorGrader results in markdown files.
command! -range=% Backtick <line1>,<line2> :s/'/`/g

" }}}

" LaTeX {{{

" Configure vimtex
let g:vimtex_fold_enabled = 0
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_show_help = 0
let g:vimtex_view_method = 'mupdf'
let g:vimtex_view_mupdf_options = '-r 288'
let g:vimtex_compiler_progname = 'nvr'

" Set keymap for viewing the table of contents
nnoremap <leader>lt :VimtexTocToggle<cr>

" Conceal option
set conceallevel=1
let g:tex_conceal='abdmgs'

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
set wildmenu
set wildmode=longest:full,full

" Set the completion approach for the engine
set completeopt=noinsert,menuone,noselect

" Completion engine is compatible with UltiSnips
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

" Make :grep use ripgrep and use -uu to not ignore files
" This is an alternative to :Rg or :Ag which ignore some files
set grepprg=rg\ --vimgrep\ -uu\ --no-heading\ --smart-case

" }}}

" Advanced Keyboard Movement with easymotion {{{

" Make f (single-character search) and
" <leader>f (two-character search) with easymotion.
" Using <leader>f instead of s avoids a conflict
" with the vim-sandwich plugin that uses "s" for sandwich-ing
nmap f <Plug>(easymotion-s)
nmap <leader>f <Plug>(easymotion-s2)
nmap <leader>e <Plug>(easymotion-next)
nmap <leader>E <Plug>(easymotion-prev)

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

" Configure AutoPairs for several programming languages
augroup autopairsconfiguration
  " Add correct comments for HTML
  au FileType html let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'}, [])
  " Add correct comments for Markdown
  au FileType markdown let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'}, [])
  " Add correct comments for Liquid
  au FileType liquid let b:AutoPairs = AutoPairsDefine({'{% comment %}' : '{% comment %}'}, [])
  " Disable single-quote pairing for LaTeX
  " Perform two steps to ensure that a reload or a new load does not error
  " 1. Add all of the potential tags for LaTeX
  au FileType tex let b:AutoPairs = AutoPairsDefine({'(':')', '[':']', '{':'}','"':'"', '`':'`', "'":"'"}, [])
  " 2. Remove the single quote matching with causes problems
  au FileType tex let b:AutoPairs = AutoPairsDefine({'(':')', '[':']', '{':'}','"':'"', '`':'`'}, ["'"])
augroup END

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

" Sandwich {{

" Do not use the default mappings to preserve
" the use of the sentence object in technical writing
let g:textobj_sandwich_no_default_key_mappings = 1

" Remap the auto-mode sandwich operators
" to the same mappings used by default
" Usage example: file_name after saiw" --> "file_name"
xmap ib <Plug>(textobj-sandwich-auto-i)
omap ib <Plug>(textobj-sandwich-auto-i)
xmap ab <Plug>(textobj-sandwich-auto-a)
omap ab <Plug>(textobj-sandwich-auto-a)

" Remap the query-mode sandwich operators
" that work for dynamically detected regions.
" Note that this uses, for instance, 'iq'
" instead of 'is' to avoid conflict with sentence.
" The intuition is that these 'query' for a
" delimiter and then dynamically match a region.
xmap iq <Plug>(textobj-sandwich-query-i)
omap iq <Plug>(textobj-sandwich-query-i)
xmap aq <Plug>(textobj-sandwich-query-a)
omap aq <Plug>(textobj-sandwich-query-a)

" Disable the s command for deleting characters
" Reference: https://github.com/machakann/vim-sandwich/issues/62
map <silent> s <nop>
map <silent> S <nop>

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
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '25%')}

" Load hidden files
command! FZFHidden call fzf#run({
      \  'source':  'rg --hidden --ignore .git -l -g ""',
      \  'sink':    'e',
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '25%'})

" Load non-hidden files
command! FZFMine call fzf#run({
      \  'source':  'rg --ignore .git -l -g ""',
      \  'sink':    'e',
      \  'options': '-m -x +s --no-bold --cycle',
      \  'down':    '25%'})

" Define key combinations
nmap <C-h> :FZFHidden <CR>
nmap <C-p> :FZFMine <CR>
nmap <Space>b :BLines <CR>
nmap <Space>r :Lines <CR>
nmap <Space>m :Marks <CR>
nmap <Space>t :BTags <CR>
nmap <Space>y :Tags <CR>
nnoremap <Tab> :Buffers <CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" Add in a format string for controlling how FZF displays the git log
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(blue)%C(bold)%cr"'

" Configure the FZF statusline in Neovim
function! s:fzf_statusline()
  " Define colors for the statusline
  setlocal statusline=%#fzf1#\ \%#fzf2#\ \FIND\ \ %#fzf3#
endfunction

" Display a customized statusline when invoking fzf
" NOTE: this will not always trigger if in an augroup
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

" Always run pytest test suites so that:
" -x: stop testing as soon as test fails
" -s: display all standard output and standard error
let test#python#pytest#options = '-x -s'

" Find alternate files with alt: https://github.com/uptech/alt
" For instance, the alternate file for display.py is test_display.py
function! AltCommand(path, vim_command)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo 'Did not find alternate file for ' . a:path
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction

" Find the alternate file for the current path and then open it
nnoremap <Space>a :w<cr>:call AltCommand(expand('%'), ':e')<cr>

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

" Advanced FZF and Completion Settings {{{

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

" Use FZF to search through the TOC of a LaTeX document
nnoremap <leader>lf :call vimtex#fzf#run('ctli')<cr>

" Enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" Configure ncm2 so that it appears quickly
let ncm2#popup_delay = 1

" Show a preview of completion details
" For instance, useful to see Python function signature
" Do not display in a bottom-screen doc, instead near menu
let g:float_preview#docked = 0

" Configure the floating preview window for completions
augroup my_floating_window_configuration
function! DisableExtras()
  call nvim_win_set_option(g:float_preview#win, 'number', v:false)
  call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
  call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
  call nvim_win_set_option(g:float_preview#win, 'spell', v:false)
endfunction
autocmd User FloatPreviewWinOpen call DisableExtras()
augroup END

" Use a matcher and a sorter that work together
let g:ncm2#matcher = 'abbrfuzzy'
let g:ncm2#sorter = 'abbrfuzzy'

" Follow vimtex's documentation to configuration ncm2
" This ensures that labels and references complete correctly
augroup my_cm_setup
  autocmd!
  autocmd BufEnter * call ncm2#enable_for_buffer()
  autocmd Filetype tex call ncm2#register_source({
        \ 'name' : 'vimtex-cmds',
        \ 'priority': 8,
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'prefix', 'key': 'word'},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#cmds,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })
  autocmd Filetype tex call ncm2#register_source({
        \ 'name' : 'vimtex-labels',
        \ 'priority': 8,
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'combine',
        \             'matchers': [
        \               {'name': 'substr', 'key': 'word'},
        \               {'name': 'substr', 'key': 'menu'},
        \             ]},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#labels,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })
  autocmd Filetype tex call ncm2#register_source({
        \ 'name' : 'vimtex-files',
        \ 'priority': 8,
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'combine',
        \             'matchers': [
        \               {'name': 'abbrfuzzy', 'key': 'word'},
        \               {'name': 'abbrfuzzy', 'key': 'abbr'},
        \             ]},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#files,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })
  autocmd Filetype tex call ncm2#register_source({
        \ 'name' : 'bibtex',
        \ 'priority': 8,
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'combine',
        \             'matchers': [
        \               {'name': 'prefix', 'key': 'word'},
        \               {'name': 'abbrfuzzy', 'key': 'abbr'},
        \               {'name': 'abbrfuzzy', 'key': 'menu'},
        \             ]},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#bibtex,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })
augroup END

" CTRL-c doesn't trigger the InsertLeave autocmd, so map to <ESC> instead
inoremap <c-c> <ESC>

" Enable auto complete for `<backspace>`, `<c-w>` keys
augroup ImproveNcmTwoCompletion
  au TextChangedI * call ncm2#auto_trigger()
augroup END

" Pressing <Enter> while the pop-up menu is visible, hides the menu.
" Use this mapping to close the menu and also start a new line.
" This configures the completion engine to make it more useful.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Enable the ncm2 completion engine to use the "look" dictionary
let g:ncm2_look_enabled = 1

" Configure deoplete to use Tab for forward and backward movement
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<s-TAB>"

" Disable jedi-vim auto-completion and enable call-signatures options
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_command = ''
let g:jedi#completions_enabled = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = '1'
let g:jedi#smart_auto_mappings = 0

" }}}
