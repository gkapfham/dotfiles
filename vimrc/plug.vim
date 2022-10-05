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
" Plug 'TimUntersberger/neogit'
" Plug 'airblade/vim-rooter'
" Plug 'akinsho/git-conflict.nvim'
" Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
" Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': 'markdown'}
" Plug 'nvim-telescope/telescope-github.nvim'
" Plug 'pgdouyon/vim-evanesco'
" Plug 'tfnico/vim-gradle'
Plug 'ColinKennedy/vim-textobj-block-party'
Plug 'KeitaNakamura/highlighter.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'Konfekt/vim-sentence-chopper'
Plug 'L3MON4D3/LuaSnip'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Quramy/vim-js-pretty-template', {'for': 'javascript.jsx'}
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'Valloric/ListToggle'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'alvan/vim-closetag'
Plug 'andymass/vim-matchup'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'arkav/lualine-lsp-progress'
Plug 'benfowler/telescope-luasnip.nvim'
Plug 'bronson/vim-visual-star-search'
Plug 'cespare/vim-toml'
Plug 'chentoast/marks.nvim'
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'creativenull/efmls-configs-nvim'
Plug 'dmitmel/cmp-cmdline-history'
Plug 'ggandor/flit.nvim'
Plug 'ggandor/leap.nvim'
Plug 'gkapfham/vim-vitamin-onec'
Plug 'goerz/jupytext.vim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-omni'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
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
Plug 'lifepillar/vim-colortemplate', {'for': 'colortemplate'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'lukas-reineke/cmp-rg'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'mfussenegger/nvim-lint'
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'nathom/filetype.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}
Plug 'prabirshrestha/async.vim'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'rafamadriz/friendly-snippets'
Plug 'ray-x/cmp-treesitter'
Plug 'rhysd/git-messenger.vim'
Plug 'romainl/vim-cool'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
Plug 'skywind3000/asyncrun.vim'
Plug 'stevearc/aerial.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
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
