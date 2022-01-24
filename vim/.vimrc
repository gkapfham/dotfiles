" vim:fdm=marker:fdl=1:

set encoding=utf-8
scriptencoding utf-8

" Baseline --> {{{

" Add Plugins
runtime rc/plug.vim

" Color Scheme
runtime rc/colortheme.vim

" System Configuration
runtime rc/system.vim

" Neovim Configuration
runtime rc/neovim.vim

" Display Improvements
runtime rc/displaynice.vim

" Keyboard Movement
runtime rc/movement.vim

" Text Manipulation
runtime rc/texmanipulation.vim

" Completion
runtime rc/completion.vim

" Search Highlighting
runtime rc/searchhighlight.vim

" Fold Format
runtime rc/folding.vim

" Tag Management
runtime rc/tagmanagement.vim

" File System
runtime rc/filesystem.vim

" Manual Pages
runtime rc/manualpages.vim

" --> Baseline }}}

" Plugins --> {{{

" Treesitter
runtime rc/treesitter.vim

" Language Server
runtime rc/languageserver.vim

" Nvim-lint
runtime rc/nvimlintplugin.vim

" Completion plugins: UltiSnips, Coq.nvim, and Wilder.nvim
runtime rc/completionplugin.vim

" Lualine.nvim
runtime rc/lualineplugin.vim

" Version control: Fugitive, Diffview.nvim, and Neogit
runtime rc/versioncontrolplugin.vim

" Telescope.nvim
runtime rc/telescopeplugin.vim

" Lightspeed.nvim
runtime rc/lightspeedplugin.vim

" Fzf
runtime rc/fzfplugin.vim

" Marks.nvim
runtime rc/marksplugin.vim

" Autopairs.nvim
runtime rc/autopairsplugin.vim

" WhichKey.nvim
runtime rc/whichkeyplugin.vim

" Wiki.vim
runtime rc/wikiplugin.vim

" Sandwich
runtime rc/sandwhichplugin.vim

" Snipmate snippets
runtime rc/snipmateplugin.vim

" Vimtex
runtime rc/vimtexplugin.vim

" --> Plugins }}}

" Configuration --> {{{

" Programming languages mega-configuration
runtime rc/programmingconfig.vim

" Markdown
runtime rc/markdownconfig.vim

" --> Configuration }}}

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
