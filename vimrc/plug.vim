" Plug {{{

" Tell plug to look into a non-standard
" directory to find all of the plugins
call plug#begin('~/.vim/bundle')

" Use the impatient plugin to speed
" the loading of all Lua components;
" must be done in advance of all the
" other plugins that use Lua
Plug 'lewis6991/impatient.nvim'

call plug#end()

lua << EOF
require('impatient')
EOF

call plug#begin('~/.vim/bundle')

" Load plugins for Vim8 and Neovim
Plug 'ColinKennedy/vim-textobj-block-party'
Plug 'KeitaNakamura/highlighter.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'Konfekt/vim-sentence-chopper'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Quramy/vim-js-pretty-template', {'for': 'javascript.jsx'}
Plug 'SirVer/ultisnips'
Plug 'TimUntersberger/neogit'
Plug 'Valloric/ListToggle'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'airblade/vim-rooter'
Plug 'akinsho/toggleterm.nvim'
Plug 'andersevenrud/cmp-tmux'
Plug 'andymass/vim-matchup'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'arkav/lualine-lsp-progress'
Plug 'bkad/CamelCaseMotion'
Plug 'bronson/vim-visual-star-search'
Plug 'cespare/vim-toml'
Plug 'chentoast/marks.nvim'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'folke/which-key.nvim'
Plug 'garbas/vim-snipmate'
Plug 'ggandor/lightspeed.nvim'
Plug 'gkapfham/vim-vitamin-onec'
Plug 'honza/vim-snippets'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-omni'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': 'markdown'}
Plug 'jalvesaq/Nvim-R', {'for': 'r'}
Plug 'jgdavey/tslime.vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'kevinhwang91/nvim-bqf', {'branch': 'main'}
Plug 'klen/nvim-test'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lervag/lists.vim'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'lervag/wiki.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lifepillar/vim-colortemplate'
Plug 'liuchengxu/vista.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'mfussenegger/nvim-lint'
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'nathom/filetype.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'neovim/nvim-lspconfig'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}
Plug 'pgdouyon/vim-evanesco'
Plug 'prabirshrestha/async.vim'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'ray-x/cmp-treesitter'
Plug 'rhysd/git-messenger.vim'
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
Plug 'sindrets/diffview.nvim'
Plug 'skywind3000/asyncrun.vim'
Plug 'tfnico/vim-gradle'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tweekmonster/braceless.vim'
Plug 'tweekmonster/spellrotate.vim'
Plug 'tweekmonster/startuptime.vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'vim-scripts/python_match.vim'
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['html', 'md', 'liquid']}
Plug 'williamboman/nvim-lsp-installer'
Plug 'windwp/nvim-autopairs'
Plug 'xolox/vim-misc'

" Always load special fonts last
Plug 'ryanoasis/vim-devicons'

call plug#end()

" NOTE: This runtime call does not work if it is
" called directly from the sandwhichplugin.vim
" file and from location of the vimrc file.

" Do not use the default mappings to preserve
" the use of "s" from the lightspeed plugin;
" instead use the default bindings of surround
" while gaining the benefits of sandwich
runtime macros/sandwich/keymap/surround.vim

" }}}
