set encoding=utf-8
scriptencoding utf-8

" Plug {{{

" Tell plug to look into a non-standard
" directory to find all of the plugins
call plug#begin('~/.vim/bundle')

" Load plugins for Vim8 and Neovim
Plug 'airblade/vim-rooter'
Plug 'andymass/vim-matchup'
Plug 'bkad/CamelCaseMotion'
Plug 'bronson/vim-visual-star-search'
Plug 'cespare/vim-toml'
Plug 'Chiel92/vim-autoformat'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'ColinKennedy/vim-textobj-block-party'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'easymotion/vim-easymotion'
Plug 'fgrsnau/ncm2-otherbuf', {'branch': 'master'}
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'filipekiss/ncm2-look.vim'
Plug 'folke/which-key.nvim'
Plug 'garbas/vim-snipmate'
Plug 'gkapfham/vim-vitamin-onec'
Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': 'markdown'}
Plug 'itchyny/lightline.vim'
Plug 'jalvesaq/Nvim-R', {'for': 'r'}
Plug 'janko-m/vim-test', {'for': 'python'}
Plug 'jeetsukumaran/vim-pythonsense', {'for': 'python'}
Plug 'jgdavey/tslime.vim'
" Plug 'jiangmiao/auto-pairs'
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
Plug 'kana/vim-textobj-user'
Plug 'KeitaNakamura/highlighter.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'kevinhwang91/nvim-bqf', { 'branch': 'main' }
Plug 'Konfekt/vim-sentence-chopper'
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'kshenoy/vim-signature'
" Plug 'kyazdani42/nvim-web-devicons'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'lervag/wiki.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lifepillar/vim-colortemplate'
Plug 'liuchengxu/vista.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'mgee/lightline-bufferline'
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'ncm2/float-preview.nvim'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-html-subscope'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-syntax'
Plug 'ncm2/ncm2-tagprefix'
Plug 'ncm2/ncm2-ultisnips'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}
Plug 'pgdouyon/vim-evanesco'
Plug 'Pocco81/AutoSave.nvim'
Plug 'Quramy/vim-js-pretty-template', {'for': 'javascript.jsx'}
Plug 'rhysd/git-messenger.vim'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neco-syntax'
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
Plug 'SirVer/ultisnips'
Plug 'skywind3000/asyncrun.vim'
Plug 'sudormrfbin/cheatsheet.nvim'
Plug 'tfnico/vim-gradle'
Plug 'TimUntersberger/neogit'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tweekmonster/braceless.vim'
Plug 'tweekmonster/spellrotate.vim'
Plug 'Valloric/ListToggle'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/python_match.vim'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wellle/tmux-complete.vim'
Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['html', 'md', 'liquid']}
Plug 'windwp/nvim-autopairs'
Plug 'xolox/vim-misc'
Plug 'sindrets/diffview.nvim'
Plug 'lervag/lists.vim'

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

" Source the vimrc file with Reload
command! Reload :source $MYVIMRC

" Define a mapping to easy use of Reload
nnoremap <leader>rr :Reload<CR>

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
" Setting also influences how quickly the
" WhichKey menu will appear with hints
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

" Display the sign column for version control
set signcolumn=yes

" Configure how quickly interface updates
set updatetime=200

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
nmap <Space>ff :Limelight!! <CR>

" Display the signature of a function in the footer of the screen
noremap <Space>s :PreviewSignature! <CR>

" Display special characters as sign column marks
let g:SignatureIncludeMarkers = '▶︎⏺@#$%ˆ&*('

" Do not display the match of an offscreen delimiter
let g:matchup_matchparen_status_offscreen = 0

" Enable the Lua-based color highlighter for all filetypes
lua require'colorizer'.setup()

" Do not show empty registers when previewing the
" registers that are available upon pressing, for
" instance, the " key when in normal mode
let g:registers_show_empty_registers = 0

" Briefly highlight the yanked region using the background color for visual highlights
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=150}
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
      \             [ 'fugitive', 'readonly', 'filename', 'python', 'gitsigns', 'context', 'modified' ] ],
      \   'right': [ ['lineinfo'], ['percent'], ['linter_warnings', 'linter_errors', 'linter_ok', 'fileformat', 'fileencoding', 'filetype'], ['gutentags'] ]
      \ },
      \ 'component_function': {
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'spell': 'LightlineSpell',
      \   'filetype': 'LightlineFiletype',
      \   'fileformat': 'LightlineFileformat',
      \   'filename': 'LightlineFilename',
      \   'gitsigns': 'LightlineGitsigns',
      \   'gutentags': 'LightlineGutentags',
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK',
      \   'context': 'NearestMethodOrFunction',
      \   'python': 'LightlinePythonEnvironment'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
\ }

" Display file context using Vista (e.g., function definition)
function! NearestMethodOrFunction() abort
  let l:nearestmethod = get(b:, 'vista_nearest_method_or_function', '')
  return l:nearestmethod !=# '' ?  ' '.get(b:, 'vista_nearest_method_or_function', '') : ''
endfunction

" Display a diagnostic message when gutentags updates
function! LightlineGitsigns()
  let l:gitstatus = get(b:,'gitsigns_status','')
  return l:gitstatus !=# '' ?  ' '.get(b:,'gitsigns_status','') : ''
endfunction

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

" Display a diagnostic message when running Python in a virtual environment
function! LightlinePythonEnvironment()
  let l:venv = $VIRTUAL_ENV
  return l:venv !=# '' ? ' '.split(l:venv, '/')[-1] : ''
endfunction

" Display a lock symbol if the file is read-only (e.g., help files)
function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

" Display symbols, not dictionaries, to indicate that spell-checking runs
function! LightlineSpell()
  return &spell ? 'A-Z ' : ''
endfunction

" Display file name with symbol or '*' for 'No Name'
function! LightlineFilename()
  return '' !=# expand('%:t') ? ' '.expand('%:t') : ' *'
endfunction

" Display the name of the branch with a specialize symbol
function! LightlineFugitive()
  if exists('*FugitiveHead')
    let l:branch = FugitiveHead()
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

" Configure the display symbol in lightline buffer listing for
" file types that do not have a default display symbol
" --> Default
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''
" --> Dictionary
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
" --> BibTeX
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['bib'] = ''
" --> LaTeX
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tex'] = ''
" --> Markdown
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['markdown'] = ''
" --> Shell
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sh'] = ''

" }}}

" Version Control {{{

lua <<EOF
local cb = require'diffview.config'.diffview_callback
require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  file_panel = {
    width = 35,
    use_icons = false
  },
  key_bindings = {
    disable_defaults = false,                   -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]     = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]   = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["<leader>e"] = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"] = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),         -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),       -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),          -- Stage all entries.
      ["U"]             = cb("unstage_all"),        -- Unstage all entries.
      ["R"]             = cb("refresh_files"),      -- Update stats and entries in the file list.
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    }
  }
}
EOF

" Define a command to load magit in full-screen mode
nmap <Space>gg :Neogit <CR>

lua <<EOF
require('gitsigns').setup {
  signs = {
    add          = {hl = 'DiffAdd'   , text = '+', numhl='None', linehl='None'},
    change       = {hl = 'DiffChange', text = '~', numhl='None', linehl='None'},
    delete       = {hl = 'DiffDelete', text = '-', numhl='None', linehl='None'},
    topdelete    = {hl = 'DiffDelete', text = '^', numhl='None', linehl='None'},
    changedelete = {hl = 'DiffChange', text = '~', numhl='None', linehl='None'},
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},
    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
  },
  watch_index = {
    interval = 500
  },
  attach_to_untracked = false,
  current_line_blame = false,
  sign_priority = 1,
  update_debounce = 50,
  status_formatter = nil,
  use_decoration_api = false,
  use_internal_diff = true,
}
EOF

lua <<EOF
local neogit = require("neogit")
neogit.setup {
  disable_signs = false,
  disable_context_highlighting = true,
  disable_commit_confirmation = true,
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    diffview = true
  },
}
EOF

" Define a command to load magit in full-screen mode
nmap <Space>gg :Neogit <CR>

" Special configuration for neogit buffers
augroup neogitconfiguration
  autocmd!
  " Disable spell checking for the magit buffers
  autocmd FileType NeogitStatus setlocal nospell
augroup END

" Configure the git-messenger
augroup gitmessenger
" Define a mapping to navigate the git-messenger pop-up
function! SetupGitMessengerPopup() abort
    " Go into the git-messenger pop-up to navigate
    nmap <Leader>gg <Plug>(git-messenger-into-popup)
    " Go to an older commit with CTRL-o
    nmap <buffer><C-o> o
    " Go to a newer commit with CTRL-i
    nmap <buffer><C-i> O
endfunction
autocmd FileType gitmessengerpopup call SetupGitMessengerPopup()
augroup END

" }}}

" Treesitter {{{

" Use the treesitter for all of the possible languages available
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers),
  -- or a list of languages
  ensure_installed = "maintained",
  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- true gives more syntax information
    -- false (sometimes) gives better highlighting in LaTeX
    additional_vim_regex_highlighting = false,
  },
  indent = {
    -- false disables because Python Treesitter is buggy right now
    enable = true
  }
}
EOF

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

" Manual Pages {{{

" Special configuration for man buffers
augroup manconfiguration
  autocmd!
  " Disable spell checking for the man buffers
  autocmd FileType man setlocal nospell
augroup END

" }}}

" Tags {{{

" Specify where the tags are stored
set tags=./tags;/,tags;/

" Perform highlighting asynchronously when file is loaded or saved
let g:highlighter#auto_update = 2

" Perform tag generation in existence of a '.maketags' marker file
let g:gutentags_project_root = ['.maketags']

" Only allow Gutentags to generate a tag file that indexes the files
" that are returned by a tool like ripgrep, which is already configured
" to ignore those files that are inside of the .gitignore file
let g:gutentags_file_list_command = 'rg --files'

" Always run the function to capture the context
" Note that using an augroup does not seem to work correctly
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" Define a command to support the toggle of Vista's display of tags
" NOTE: There is a defect, most likely in Vista, that causes the
" lightline display to disappear after using this command.
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

" WhichKey {{{

lua << EOF
  require("which-key").setup {
  plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    icons = {
      breadcrumb = "", -- symbol used in the command line area that shows your active key combo
      separator = "", -- symbol used between a key and it's label
      group = " ", -- symbol prepended to a group
    },
    window = {
      border = "single", -- none, single, double, shadow position = "bottom", -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    },
    layout = {
      height = { min = 4, max = 50 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = false, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      -- most people should not need to change this
      i = { "j", "k" },
      v = { "j", "k" },
    },
  }
EOF

" }}}

" Snippets {{{

" Use the old version of the snipMate parser
" to support backwards compatibility of old snippets
let g:snipMate = { 'snippet_version' : 0 }

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
" NOTE: Documentation for these variables
" did not place them in an augroup
let java_highlight_all=1
let java_highlight_functions=1
let java_highlight_functions=1
let java_highlight_java_lang_ids=1
let java_space_errors=1
let java_comment_strings=1

" Plugin configuration for R
" NOTE: Documentation for these variables
" did not place them in an augroup
let R_assign = 2
let R_openpdf = 0
let R_show_args = 1

" Force Jedi to use version 3
let g:jedi#force_py_version = 3

" Run the black formatter on current Python file
" NOTE: this is not the standard method, but
" I adopted it because Black did not work well
" with virtual environments created by tools like Pipenv
command! Black cexpr system('black ' . shellescape(expand('%')))<bar>:checktime

" Run the black formatter on all of the Python files
command! Blacken cexpr system('black **/*.py')<bar>:checktime

" If using yapf, format Python code according to PEP8
" Note that I should standardly use :Black and :Blacken
let g:formatter_yapf_style = 'pep8'

" Set the hosts programs for Python and Python3
" This improves performance when loading plugins using Python
" Note that /usr/bin/python defaults to Python3
let g:python_host_prog  = '/usr/bin/python2'
if filereadable('/usr/local/bin/python3')
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python3_host_prog = '/usr/bin/python'
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

" Configure the fixers run by ALE
" All files: remove trailing lines and blank spaces
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" Configure the symbols for linting warnings and errors
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'

" }}}

" Markdown {{{

" First command: Make a list item in markdown a task
" Second command: Mark a task in markdown as done
" These two commands work for normal mode and visual mode
" nnoremap <silent> <Space>w :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[<space>]<space>/<CR>0f]h
" nnoremap <silent> <Space>d :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[X]<space>/<CR>0f]h
" vnoremap <silent> <Space>w :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[<space>]<space>/<CR>0f]h
" vnoremap <silent> <Space>d :s/^\s*\(-<space>\\|\*<space>\)\?\zs\(\[[^\]]*\]<space>\)\?\ze./[X]<space>/<CR>0f]h

let g:lists_filetypes = ['markdown', 'wiki']

" Convert the checkmark symbol, which is not on the keyboard, to a dash.
" This command enables suitable display of GatorGrader results in markdown files.
command! -range=% Checkmark <line1>,<line2> :s/✔ /-/g

" Convert the single quote symbol, to a backtick, aiding conversion to markdown
" This command also enables suitable display of GatorGrader results in markdown files.
command! -range=% Backtick <line1>,<line2> :s/'/`/g

" }}}

" Wiki {{{

" Set the root of the wiki
let g:wiki_root = '~/working/wiki'

" Use markdown filetype and syntax highlighting
" for the .wiki files used in the knowledge base
" NOTE: wiki.vim seems to use .wiki even when I
" set it to use .md as the main file type
augroup WikiFileType
  autocmd!
  au BufNewFile,BufRead,BufEnter *.wiki set syntax=markdown
  au BufNewFile,BufRead,BufEnter *.wiki set filetype=markdown
augroup END

" Define mappings that make it easy to search the pages
" and tags in the wiki using fuzzy search with Fzf
" --> pages in the Wiki in the form of File.wiki
nnoremap <Space>fp :WikiFzfPages <CR>
" --> tags in the form of :tagname:
nnoremap <Space>ft :WikiFzfTags <CR>
" --> the contents of a markdown file
nnoremap <Space>fc :WikiFzfToc <CR>

" }}}

" LaTeX {{{

" Configure vimtex
" --> Do not fold
let g:vimtex_fold_enabled = 0
" --> Do not open quickfix for warnings
let g:vimtex_quickfix_open_on_warning = 0
" --> Do not show the help message
" let g:vimtex_index_show_help = 0
" --> Use zathura for the PDF viewer
let g:vimtex_view_method = 'zathura'
" --> Use the nvr program (Neovim-remote)
"     to facilitate communication between
"     Neovim and the Zathura PDF viewer
let g:vimtex_compiler_progname = 'nvr'

" Define mapping to generate and view the table of contents
nnoremap <leader>lt :VimtexTocToggle<cr>

" Define mapping to run a "single-shot" compilation
" Note that this is especially useful when the LaTeX
" document requires a long background compilation
" that is so expensive to always run that if limits
" the ability to use the text editor interactively
nnoremap <Space>ll :VimtexCompileSS<cr>

" Conceal option
set conceallevel=1
let g:tex_conceal='abdmgs'

" Use tex over plaintex
let g:tex_flavor = 'tex'

" Required by the vimtex plugin
set hidden

" Use latexindent to break up paragraphs
" This yields commands like "grip" for formatting with latexindent
" It is still possible to use commands like "gwip" for paragraph formatting
nmap gr <plug>(ChopSentences)
xmap gr <plug>(ChopSentences)

" Pass options to latexindent
" Note that latexindent will reference the ~/.indentconfig.yaml
" file which will point to the ~/.chopsentences.yaml file
let g:latexindent_options = '-m -r'

" Do not use a space after the comment string symbol in LaTeX
augroup latexcomments
  autocmd!
  autocmd FileType tex setlocal commentstring=%%s
augroup END

" }}}

" Comments {{{

" Insert a comment symbol on the current line at cursor location
nmap <Space>cc :execute "normal! i" . split(&commentstring, '%s')[0]<CR>

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
call camelcasemotion#CreateMotionMappings('<space>')

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
" Use either control or space to activate
nmap <C-u> :call SwitchBuffer()<CR>
nmap <Space>u :call SwitchBuffer()<CR>

" Redefine the default mapping of <Leader><Leader> for
" the easymotion prefix, which I do not use frequently.
" Note that the default for this mapping conflicts with
" the following mapping created for the colon key
map <Leader><Space> <Plug>(easymotion-prefix)

" Define <leader<leader> to create a colon in both
" normal mode and visual mode, thereby avoiding
" the need to frequently type the shift key
nnoremap <leader><leader> :
vnoremap <leader><leader> :

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
set grepprg=rg\ -uu\ --vimgrep\ --no-heading\ --smart-case

" }}}

" Advanced Keyboard Movement with Easymotion {{{

" Make f (single-character search) and
" <leader>f (two-character search) with easymotion.
" Using <leader>f instead of "s" avoids a conflict
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

lua << EOF
require('nvim-autopairs').setup()
EOF

" " Toggle off the auto-completion of pairs
" let g:AutoPairsShortcutToggle = '<leader>apt'

" " Configure AutoPairs for several programming languages
" augroup autopairsconfiguration
"   " Add correct comments for HTML
"   au FileType html let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'}, [])
"   " Add correct comments for Markdown
"   au FileType markdown let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'}, [])
"   " Add correct comments for Liquid
"   au FileType liquid let b:AutoPairs = AutoPairsDefine({'{% comment %}' : '{% comment %}'}, [])
"   " Disable single-quote pairing for LaTeX
"   " Perform two steps to ensure that a reload or a new load does not error
"   " 1. Add all of the potential tags for LaTeX
"   " au FileType tex let b:AutoPairs = AutoPairsDefine({'(':')', '[':']', '{':'}','"':'"', '`':'`', "'":"'"}, [])
"   " 2. Remove the single quote matching with causes problems
"   " au FileType tex let b:AutoPairs = AutoPairsDefine({'(':')', '[':']', '{':'}','"':'"', '`':'`'}, ["'"])
" augroup END

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

  " Map `gr` to reload the Dirvish buffer
  autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

  " Map `gh` to hide dot-prefixed files
  " To toggle this, press `gr` to reload
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
augroup END

" Define the symbols used to indicate the status of the
" version control repository in a dirvish buffer
let g:dirvish_git_indicators = {
\ 'Modified'  : '!',
\ 'Staged'    : '+',
\ 'Untracked' : '?',
\ 'Renamed'   : '➜',
\ 'Unmerged'  : '═',
\ 'Ignored'   : '',
\ 'Unknown'   : ''
\ }

" Define the highlight color for version control details in dirvish
let g:gitstatus = 'guifg=#d78700 ctermfg=172'

" Define the color scheme to always be the same color;
" this is acceptable because the symbols vary.
silent exe 'hi default DirvishGitModified '.g:gitstatus
silent exe 'hi default DirvishGitStaged '.g:gitstatus
silent exe 'hi default DirvishGitRenamed '.g:gitstatus
silent exe 'hi default DirvishGitUnmerged '.g:gitstatus
silent exe 'hi default DirvishGitIgnored guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
silent exe 'hi default DirvishGitUntracked guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
silent exe 'hi default link DirvishGitUntrackedDir DirvishPathTail'

" }}}

" Man Pages {{

" Fuzzy search through the man pages with Fzf and then
" display the selected man page inside of Vim
command! -nargs=? Superman call fzf#run(fzf#wrap({'source': 'man -k -s 1 '.shellescape(<q-args>).' | cut -d " " -f 1', 'sink': 'tab Man', 'options': ['--preview', 'MANPAGER=cat MANWIDTH='.(&columns/2-4).' man {}']}))

" }}}

" Fugitive {{

" Run Fugitive commands asynchronously using AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Resolve a merge conflict with a three-pane vertical split
nnoremap <leader>gd :Gvdiffsplit!<CR>

" Merge the "head" into the current file
nnoremap gdh :diffget //2<CR>

" Merge the "branch" into the remote file
nnoremap gdb :diffget //3<CR>

" Perform a Gcommit for the current hunk with a mapping
nnoremap <leader>gcc :Git commit <CR>

" Perform a Gcommit for the current file with a mapping
nnoremap <leader>gcf :Git commit %<CR>

" Perform a Gcommit for all modified files with a mapping
nnoremap <leader>gca :Git commit -a<CR>

" Get the status of the repository
nnoremap <leader>gs :Git <CR>

" }}}

" Sandwich {{

" Do not use the default mappings to preserve
" the use of the sentence object in technical writing
let g:textobj_sandwich_no_default_key_mappings = 1

" Remap the auto-mode sandwich operators
" to the same mappings used by default
" - Usage example: file_name after saiw" --> "file_name"
" - Usage example: recent optimizations after
" saif" --> "recent optimizations"
" because the f" will search for quote mark
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
" Reference: https://github.com/machakann/Vim-sandwich/issues/62
map <silent> s <nop>
map <silent> S <nop>

" }}}

" AutoSave {{{

lua << EOF
local autosave = require("autosave")
autosave.setup(
    {
        enabled = true,
        execution_message = "Auto-saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 2500
    }
)
EOF

" }}}

" Telescope {{{

lua << EOF
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    mappings = {
    i = {
      ["<esc>"] = actions.close,
      },
    n = {
      ["<esc>"] = actions.close,
      ["<cr>"] = false,
      },
    },
    layout_config = {
      horizontal = {
        height = 0.8,
        width = 0.9
      }
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "closest",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = false,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
  pickers = {
    buffers = {
        sort_lastused = true,
      }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
-- load extensions after calling setup function
require('telescope').load_extension('fzf')
require('telescope').load_extension('ultisnips')
EOF

" Do not allow ncm2 to complete when in the TelescopePrompt
autocmd FileType TelescopePrompt call ncm2#disable_for_buffer()

" Command mappings for Telescope to find:
" (note that Ctrl-mappings are provided for some commands
" when those are ones for which there is a muscle memory)

" --> All files, including hidden files, but not
" those files stored in a .git directory
" (always respects the .gitignore file)
nmap <C-p> :Telescope find_files hidden=true <CR>
nmap <Space>p :Telescope find_files hidden=true <CR>

" --> All files, but not including hidden files
" (always respects the .gitignore file)
nmap <Space>o :Telescope find_files <CR>

" --> Lines or marks of the current buffer
nmap <Space>r :Telescope current_buffer_fuzzy_find <CR>
" nmap <C-m> :Telescope marks <CR>
nmap <Space>m :Telescope marks <CR>

" --> Tags in buffer or all tags across the project directory
nmap <Space>tt :Telescope tags <CR>
nmap <Space>tb :Telescope current_buffer_tags <CR>
nmap <Space>y :Telescope tags <CR>

" --> Code components search using Treesitter
" (does not display anything if there is no treesitter
" for a specific language, like with the .vimrc file)
nnoremap <Space>ts :Telescope treesitter <CR>

" --> All matches in non-hidden files for word under cursor
" (only works for the specific word under the cursor, meaning
" that this is not a :Telescope live_grep)
nnoremap <Space>gs :Telescope grep_string <CR>

" --> All matches in non-hidden files for input word
nnoremap <Space>ga :Telescope live_grep <CR>

" --> Names of open buffers
nnoremap <Tab> :Telescope buffers <CR>
nnoremap <Space>i :Telescope buffers <CR>

" --> Ultisnips-based snippets available for buffer
nnoremap <Space>s :Telescope ultisnips <CR>

" --> Recently run commands
nnoremap <Space>h :Telescope command_history <CR>

" --> Spelling fix suggestions for word under cursor
nnoremap <Space>z :Telescope spell_suggest <CR>

" }}}

" FZF {{{

" NOTE: FZF is used in conjunction with telescope.nvim because
" plugins like wiki.vim are integrated with FZF. Moreover,
" although FZF commands are no longer directly integrated into
" the workflow with nnoremap's, they are still available if needed.

" Define unique colors for FZF's display
" inside of Neovim (note that these colors
" match telescope.nvim and not FZF in terminal)
let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Normal'],
      \ 'fg+':     ['fg', 'String', 'Normal', 'Normal'],
      \ 'bg+':     ['bg', 'Normal', 'Normal'],
      \ 'hl+':     ['fg', 'Identifier'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Comment'],
      \ 'prompt':  ['fg', 'Identifier'],
      \ 'pointer': ['fg', 'Identifier'],
      \ 'marker':  ['fg', 'Identifier'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" Use rg by default
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!{node_modules/*,.git/*}"'
  set grepprg=rg\ --vimgrep
endif

" Re-define the Rg command so that it considers hidden files
"
" Note that the use of "-uu" includes the hidden files
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -uu --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" --> Files matching search terms with either Ag or Rg
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" Use FZF to search through the TOC of a LaTeX document
nnoremap <leader>lf :call vimtex#fzf#run('ctli')<cr>

" Show the mappings that are currently available
nmap <leader><tab> <plug>(fzf--n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

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
  let g:vimtex_compiler_progname = 'nvr'
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

" Completion Settings with ncm2 {{{

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

" Pressing <Enter> while the pop-up menu is visible will hide menu.
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
