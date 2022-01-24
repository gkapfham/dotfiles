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

" --> Plugins }}}

" Configuration --> {{{

" Programming languages mega-configuration
runtime rc/programmingconfig.vim

" Markdown
runtime rc/markdownconfig.vim

" --> Configuration }}}

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
