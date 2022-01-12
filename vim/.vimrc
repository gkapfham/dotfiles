" vim:fdm=marker:fdl=0:
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
Plug 'chentau/marks.nvim'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'ColinKennedy/vim-textobj-block-party'
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'folke/which-key.nvim'
Plug 'garbas/vim-snipmate'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ggandor/lightspeed.nvim'
Plug 'gkapfham/vim-vitamin-onec'
Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': 'markdown'}
Plug 'jalvesaq/Nvim-R', {'for': 'r'}
Plug 'janko-m/vim-test', {'for': 'python'}
Plug 'jgdavey/tslime.vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
Plug 'kana/vim-textobj-user'
Plug 'KeitaNakamura/highlighter.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'kevinhwang91/nvim-bqf', {'branch': 'main'}
Plug 'Konfekt/vim-sentence-chopper'
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'lervag/lists.vim'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'lervag/wiki.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lewis6991/impatient.nvim'
Plug 'lifepillar/vim-colortemplate'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'MarcWeber/vim-addon-mw-utils'
" Plug 'mgee/lightline-bufferline'
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'nathom/filetype.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}
Plug 'pgdouyon/vim-evanesco'
Plug 'prabirshrestha/async.vim'
Plug 'Quramy/vim-js-pretty-template', {'for': 'javascript.jsx'}
Plug 'rhysd/git-messenger.vim'
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
Plug 'sindrets/diffview.nvim'
Plug 'SirVer/ultisnips'
Plug 'skywind3000/asyncrun.vim'
Plug 'tfnico/vim-gradle'
Plug 'TimUntersberger/neogit'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tweekmonster/braceless.vim'
Plug 'tweekmonster/spellrotate.vim'
Plug 'tweekmonster/startuptime.vim'
Plug 'Valloric/ListToggle'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/python_match.vim'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['html', 'md', 'liquid']}
Plug 'williamboman/nvim-lsp-installer'
Plug 'windwp/nvim-autopairs'
Plug 'xolox/vim-misc'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'mfussenegger/nvim-lint'
Plug 'nvim-lualine/lualine.nvim'

" Always load special fonts last
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Use the impatient plugin to speed
" the loading of all Lua components;
" must be done in advance of all the
" other plugins that use Lua
lua << EOF
require('impatient')
EOF

" }}}

" System {{{

" Enable spell checking
syntax spell toplevel

" Configure the spelling files
set spellfile+=~/.config/nvim/spell/en.utf-8.add
set spellfile+=.extra.utf-8.add

" Correct spelling mistakes from insert mode when typing
" Reference:
" https://stackoverflow.com/questions/5312235/how-do-i-correct-vim-spelling-mistakes-quicker
" Note that this mapping does not seem to work for all filetypes
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

" Define a mapping for the easy use of Reload
nnoremap <leader>rr :Reload<CR>

" }}}

" Color Scheme {{{

" Use true-color in the terminal
set termguicolors

" Use customized colorscheme
colorscheme vitaminonec

" }}}

" Neovim Configuration {{{

" Note that this entire configuration is specialized to
" neovim and will not, in fact, run without error on Vim.
" With that said, these are Neovim-specific customizations.

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
"
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

" Do not display the match of an offscreen delimiter
let g:matchup_matchparen_status_offscreen = 0

" Configure the matchup plugin to override defaults in vimtex
let g:matchup_override_vimtex = 1

" Enable the Lua-based color highlighter for all filetypes
lua require'colorizer'.setup()

" Briefly highlight the yanked region using the background color for visual highlights
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=150}
augroup END

" }}}

" Marks.nvim {{{

lua << EOF
require'marks'.setup {
  -- do not use the default keybindings
  default_mappings = false,
  -- make movements cycle back to the beginning/end of buffer
  cyclic = true,
  -- do not save the marks into the shada file
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 150,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- define mappings that are different than the default
  mappings = {
    next = "]m",
    prev = "[m",
    delete = "dm",
    delete_line = "dm-",
    delete_buf = "dm<space>",
    preview = "m;",
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
call camelcasemotion#CreateMotionMappings('<space><space>')

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

" Define <leader<leader> to create a colon in both
" normal mode and visual mode, thereby avoiding
" the need to frequently type the shift key
nnoremap <leader><leader> :
vnoremap <leader><leader> :

" }}}

" Tags {{{

" Specify where the tags are stored
set tags=./tags;/,tags;/

" Perform highlighting asynchronously when file is loaded or saved
let g:highlighter#auto_update = 2

" Configure gutentags plugin
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 1

" Only allow Gutentags to generate a tag file that indexes the files
" that are returned by a tool like ripgrep, which is already configured
" to ignore those files that are inside of the .gitignore file
let g:gutentags_file_list_command = 'rg --files'

" }}}

" File System {{{

" Configure the dirvish plugin
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

" Manual Pages {{{

" Define a special configuration for man buffers
augroup manconfiguration
  autocmd!
  " Disable spell checking for the man buffers
  autocmd FileType man setlocal nospell
augroup END

" Fuzzy search through the man pages with Fzf and then
" display the selected man page inside of Vim
command! -nargs=? Superman call fzf#run(fzf#wrap({'source': 'man -k -s 1 '.shellescape(<q-args>).' | cut -d " " -f 1', 'sink': 'tab Man', 'options': ['--preview', 'MANPAGER=cat MANWIDTH='.(&columns/2-4).' man {}']}))

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

" Configure the autopairs.nvim plugin
lua << EOF
local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

npairs.setup({ map_bs = false, map_cr = false })
vim.g.coq_settings = { keymap = { recommended = false } }

-- skip it, if you use another global object
_G.MUtils= {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return npairs.esc('<c-y>')
    else
      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
EOF

" Configure the matchup plugin to display diagnostics about location
nnoremap <c-k> :<c-u>MatchupWhereAmI<CR>

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

" Lualine {{{

lua << EOF
 -- Define the color scheme for the lualine
local colors = {
  color2   = "#87afd7",
  color7   = "#e06c75",
  color10  = "#afaf5f",
  color6   = "#626262",
  color3   = "#875f87",
  color1   = "#262626",
  color0   = "#bcbcbc",
}
local vitaminonec = {
  normal = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color2 , gui = "bold", },
    c = { fg = colors.color0, bg = colors.color1 },
  },
  visual = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color3 , gui = "bold", },
  },
  inactive = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color0, bg = colors.color1 , gui = "none", },
    c = { fg = colors.color6, bg = colors.color1 },
  },
  replace = {
   jb = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color7 , gui = "bold", },
  },
  insert = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color10 , gui = "bold", },
  },
}

-- Setup the lualine plugin.
-- Use the theme that was previously
-- specified directly above.
-- Display components in all four
-- corners of the Neovim status lines.
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = vitaminonec,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  -- Bottom section of status line
  sections = {
    -- Bottom left display
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'StatuslineReadonly', {'filename', path=1}},
    -- Bottom right display
    lualine_x = {'encoding', {'fileformat', symbols = {
                    unix = 'unix',
                    dos = 'docs',
                    mac = 'mac',
                }}, {'filetype', colored=false}},
    lualine_y = {'filesize', 'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {{'buffers', show_modified_status = true}},
    lualine_b = {''},
    lualine_c = {''},
    lualine_x = {{'diagnostics', symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}}},
    lualine_y = {'StatuslinePythonEnvironment', 'StatuslineGutentags'},
    lualine_z = {'StatuslineSpell'}
  },
  extensions = {'quickfix'}
}
EOF

" }}}

" Support Functions for Lualine {{{

" Display a diagnostic message when gutentags updates;
" this is specifically useful because tag generation is a
" long-running process for large files. As such it is
" useful to know that the long-running process is operating.
function! StatuslineGutentags()
  return gutentags#statusline() !=# '' ? '  Tags  ' : 'Tags  '
endfunction

" Display a diagnostic message when running Python in a virtual environment
function! StatuslinePythonEnvironment()
  " Extract only the name of the virtual environment from the
  " VIRTUAL_ENV variable; note that it also includes the full
  " directory to the virtual environment that is not suitable
  " for including in a section of a status line.
  let l:venv = $VIRTUAL_ENV
  return l:venv !=# '' ? ' '.split(l:venv, '/')[-1] : ''
endfunction

" Display a lock symbol if the file is read-only (e.g., help files)
function! StatuslineReadonly()
  return &readonly ? '' : ''
endfunction

" Display symbols, not dictionaries, to indicate that spell-checking is running
function! StatuslineSpell()
  " Use a different configuration to show whether
  " or not spell checking is currently running
  return &spell ? 'A-Z ' : 'A-Z '
endfunction

" }}}

" Fugitive {{{

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

" Specialized Version Control Plugins {{{

" Configure the diffview.nvim plugin

lua << EOF
local cb = require'diffview.config'.diffview_callback
require'diffview'.setup {
  diff_binaries = false,
  use_icons = false,
  file_panel = {
    width = 35,
  },
  key_bindings = {
    disable_defaults = false
  }
}
EOF

" Configure the gitsigns.nvim plugin

lua << EOF
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
  diff_opts = {
    internal = true
  },
  attach_to_untracked = false,
  current_line_blame = false,
  sign_priority = 1,
  update_debounce = 50,
  status_formatter = nil,
  -- use_decoration_api = false,
  -- use_internal_diff = true,
}
EOF

" Configure the neogit plugin

lua <<EOF
local neogit = require("neogit")
neogit.setup {
  disable_signs = false,
  disable_context_highlighting = true,
  disable_commit_confirmation = true,
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

" Define a command to load neogit in full-screen mode
nmap <Space>gg :Neogit <CR>

" Special configuration for neogit buffers
augroup neogitconfiguration
  autocmd!
  " Disable spell checking for the neogit buffers
  autocmd FileType NeogitStatus setlocal nospell
augroup END

" Configure the git-messenger
augroup gitmessenger
" Define a mapping to navigate the git-messenger pop-up
function! SetupGitMessengerPopup() abort
    " Go into the git-messenger pop-up to navigate
    nmap <Leader>gg :GitMessenger <CR>
    " After going into the pop-up with another
    " use of the <Leader>gg mapping, then:
    " --> Go to an older commit with CTRL-j
    nmap <buffer><C-j> o
    " --> Go to a newer commit with CTRL-k
    nmap <buffer><C-k> O
endfunction
autocmd FileType gitmessengerpopup call SetupGitMessengerPopup()
augroup END

" }}}

" Treesitter {{{

" Use the treesitter for all of the possible languages available
" Include the configuration for all plugins that use treesitter

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers),
  -- or a list of languages
  ensure_installed = "maintained",
  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- true gives more syntax information
    -- false (sometimes) gives better highlighting in LaTeX
    additional_vim_regex_highlighting = true,
  },
  indent = {
    -- false disables because Python Treesitter is buggy right now
    enable = false
  },
  -- enable treesitter for the matchup plugin that enhances matches
  -- highlighting and movements using the % symbol
  matchup = {
    enable = true,
  },
}
EOF

" }}}

" Language Servers {{{

lua << EOF
local lsp_installer = require'nvim-lsp-installer'
function common_on_attach(client, bufnr)
  -- do stuff
  print("契Starting Language Server");
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  opts = {silent = true, noremap = true}
  buf_set_keymap('n', 'K', '<cmd> lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', '<space>e', '<cmd> lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd> lua vim.diagnostic.open_float(0, {scope="line"})<CR>', opts)
  buf_set_keymap('n', '<space>k', '<cmd> lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>c', '<cmd> lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
end
local installed_servers = lsp_installer.get_installed_servers()
for _, server in pairs(installed_servers) do
    opts = {
        on_attach = common_on_attach,
    }
    server:setup(opts)
end
EOF

" }}}

" Linting with nvim-lint {{{

lua << EOF
-- load and configure the linting plugin
-- pick specific linters for specific file types
require('lint').linters_by_ft = {
  mail = {'proselint'},
  markdown = {'markdownlint', 'proselint'},
  python = {'flake8', 'pydocstyle', 'pylint'},
  tex = {'chktex'},
  vim = {'vint'},
  zsh = {'shellcheck'},
}
EOF

" Always run the linters whenever a file is saved
au BufWritePost * :lua require('lint').try_lint()

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

" Set the completion approach for the engine
set completeopt=menuone,noselect

" Completion engine is compatible with UltiSnips
let g:UltiSnipsExpandTrigger='<C-s>'
let g:UltiSnipsJumpForwardTrigger='<C-s>'
let g:UltiSnipsJumpBackwardTrigger='<C-j>'

" Do not echo messages (nor will searches)
set noshowmode

" Infer the case when doing completion
set infercase

" Always start coq.nvim when entering buffer
autocmd VimEnter * COQnow --shut-up

" Disable the default coq.nvim keybindings
let g:coq_settings = { 'keymap.recommended': v:false }

" Specify customized coq.nvim settings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

" Additional coq.nvim settings
let g:coq_settings = {"display.pum.source_context" : ["  ", " "], "display.pum.kind_context" : [" ", " "], 'auto_start': 'shut-up'}

" Basic configuration for the wilder.nvim plugin
" that makes searching in the wildmenu possible
call wilder#setup({'modes': [':', '/', '?']})

" Configure the wilder.nvim so that it supports
" the theme from the lightline and renders in it;
" this means that the completion items render in
" the lightline at the bottom of the screen. Nice!
call wilder#set_option('renderer', wilder#wildmenu_renderer(
      \ wilder#wildmenu_lightline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': ' · ',
      \ })))

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

" Advanced Keyboard Movement with Lightspeed.nvim {{{

lua << EOF
require'lightspeed'.setup {
  --[[ jump_to_first_match = false, ]]
  jump_on_partial_input_safety_timeout = 400,
  -- This can get _really_ slow if the window has a lot of content,
  -- turn it on only if your machine can always cope with it.
  highlight_unique_chars = false,
  grey_out_search_area = false,
  match_only_the_start_of_same_char_seqs = true,
  limit_ft_matches = 5,
  --[[ full_inclusive_prefix_key = '<c-x>', ]]
  -- By default, the values of these will be decided at runtime,
  -- based on `jump_to_first_match`.
  labels = nil,
  cycle_group_fwd_key = '<Tab>',
  cycle_group_bwd_key = '<S-Tab>',
}
EOF

" Use the ; key to repeat a specific use of an invocation using,
" for instance, an f or an s. This means that if you have previously
" typed "f c" then you can you a ";" and it will jump to the next
" matching letter c in the file. This also works for "s cr" as well.
let g:lightspeed_last_motion = ''
augroup lightspeed_last_motion
autocmd!
autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
augroup end
map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"

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
    path_display = {
      "absolute",
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
-- require('telescope').load_extension('fzf')
require('telescope').load_extension('ultisnips')
EOF

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
nmap <Space>m :Telescope marks <CR>

" --> Tags in buffer or all tags across the project directory
" define mappings for both Telescope and FZF since tag-based
" navigation with Telescope fails with error, especially for:
"  -- LaTeX
"  -- Markdown
nmap <Space>tt :Telescope tags <CR>
nmap <Leader>tt :Tags <CR>
nmap <Space>tb :Telescope current_buffer_tags <CR>
nmap <Leader>tb :BTags <CR>

" --> Code components search using Treesitter
" (does not display anything if there is no treesitter
" for a specific language, like with the .vimrc file)
nnoremap <Space>ts :Telescope treesitter <CR>

" --> All matches in non-hidden files for word under cursor
" (only works for the specific word under the cursor, meaning
" that this is not a :Telescope live_grep)
nnoremap <Space>gs :Telescope grep_string <CR>
nnoremap <Leader>gs :Rg <C-R><C-W><CR>

" --> All matches in non-hidden files for input word
nnoremap <Space>ga :Telescope live_grep <CR>
nnoremap <Leader>ga :Rg <CR>

" --> Names of open buffers
" nnoremap <Tab> :Telescope buffers <CR>
nnoremap <Space>i :Telescope buffers <CR>

" --> Ultisnips-based snippets available for buffer
nnoremap <Space>us :Telescope ultisnips <CR>

" --> Spelling suggestion and correction
nnoremap <Space>ss :Telescope spell_suggest <CR>

" --> Recently run commands
nnoremap <Space>h :Telescope command_history <CR>

" --> Spelling fix suggestions for word under cursor
nnoremap <Space>z :Telescope spell_suggest <CR>

" --> Run the previous telescope command
nnoremap <Space>gp :Telescope resume <CR>

" --> Language server mappings
" -- Navigation
nnoremap <Space>gd :Telescope lsp_definitions <CR>
nnoremap <Space>gr :Telescope lsp_references <CR>

" -- Symbols
nnoremap <Space>ds :Telescope lsp_document_symbols <CR>
nnoremap <Space>ws :Telescope lsp_workspace_symbols <CR>

" -- Diagnostics
nnoremap <Space>dd :Telescope diagnostics bufnr=0 <CR>
nnoremap <Space>wd :Telescope diagnostics <CR>

" }}}

" FZF {{{

" NOTE: FZF is used in conjunction with telescope.nvim because
" plugins like wiki.vim are integrated with FZF. Moreover,
" although all FZF commands are no longer directly integrated into
" the workflow with nnoremap's, they are still available if needed.

" NOTE: There are alternate FZF-based commands for the use of,
" for instance, tags and grepping because Telescope's variants
" do not work correctly or do not work efficiently enough.
"
" The Telescope-based commands are prefixed with <Space>
" and the FZF-based commands are prefixed with <Leader>

" Define the layout of FZF's window so that it matches the height
" and width of the Telescope window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.85 } }

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

" Sandwich {{{

" Do not use the default mappings to preserve
" the use of the sentence object in technical writing
" let g:textobj_sandwich_no_default_key_mappings = 1

" Do not use the default mappings to preserve
" the use of "s" from the lightspeed plugin;
" instead use the default bindings of surround
" while gaining the benefits of sandwich
runtime macros/sandwich/keymap/surround.vim

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
        operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = false, -- default bindings on <c-w>
        nav = false, -- misc bindings to work with windows
        z = false, -- bindings for folds, spelling and others prefixed with z
        g = false, -- bindings for prefixed with g
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
    triggers = "", -- automatically setup triggers
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

" Support the manual triggering of WhichKey
nnoremap <Space>wk :WhichKey <CR>

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

  " Always set the file type to mail when reading a temporary file
  " that was created by the mutt mail user agent
  autocmd BufNewFile,BufRead ~/.mutt/tmp/mutt* set filetype=mail

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

" Run the black formatter on current Python file
" NOTE: this is not the standard method, but
" I adopted it because Black did not work well
" with virtual environments created by tools like Pipenv
command! Black cexpr system('black ' . shellescape(expand('%')))<bar>:checktime

" Run the black formatter on all of the Python files
command! Blacken cexpr system('black **/*.py')<bar>:checktime

" Set the hosts programs for Python and Python3
" This improves performance when loading plugins using Python
" Note that /usr/bin/python defaults to Python3
let g:python_host_prog  = '/usr/bin/python2'
if filereadable('/usr/local/bin/python3')
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python3_host_prog = '/usr/bin/python'
endif

" Indenting for HTML
au BufRead,BufNewFile *.html set filetype=html
let g:html_indent_inctags = 'html,body,head,tbody,div'

" Do not perform folding inside of Markdown
let g:pandoc#modules#disabled = ['folding']

" Preview for Markdown
let g:mkdp_browser = '/usr/sbin/firefox'
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

" Use the lists.vim plugin for markdown and wiki filetypes
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

" Note about error in vimtex workflow:
" - Open LaTeX main document in nvim
" - Start to compile the document with ,ll
" - Zathura opens the document correctly
" - Make a single change to the document
" - Error: Zathura closes the document
" - Start the preview of document with ,lv
" - Zathura opens document correctly
" - All remaining edits now work correctly
" - Same error is evident if running latexmk separately

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

" Configure the latexmk compiler; especially
" turning off the callback as this seems to
" generate error messages when compiling
" and using the zathura program.
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 0,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

" Define mapping to generate and view the table of contents
nnoremap <leader>lt :VimtexTocToggle<cr>

" Define mapping to run a "single-shot" compilation
" Note that this is especially useful when the LaTeX
" document requires a long background compilation
" that is so expensive to always run that if limits
" the ability to use the text editor interactively
nnoremap <Space>ll :VimtexCompileSS<cr>

" Disable syntax highlighting provided by vimtex plugin
let g:vimtex_syntax_enabled = 0

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

" Use the comment.nvim plugin
lua << EOF
require('Comment').setup()
EOF

" Insert a comment symbol on the current line at cursor location
nmap <Space>cc :execute "normal! i" . split(&commentstring, '%s')[0]<CR>

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
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>

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
