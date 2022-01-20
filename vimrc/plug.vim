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
