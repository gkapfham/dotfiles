" vim:fdm=marker:fdl=1:

set encoding=utf-8
scriptencoding utf-8

" BASELINE --> {{{

" Add Plugins {{{

runtime rc/plug.vim

" }}}

" Color Scheme {{{

runtime rc/colortheme.vim

" }}}

" System Configuration {{{

runtime rc/system.vim

" }}}

" Neovim Configuration {{{

runtime rc/neovim.vim

" }}}

" Display Improvements {{{

runtime rc/displaynice.vim

" }}}

" Keyboard Movement {{{

runtime rc/movement.vim

" }}}

" Text Manipulation {{{

runtime rc/texmanipulation.vim

" }}}

" Completion {{{

runtime rc/completion.vim

" }}}

" Search Highlighting {{{

runtime rc/searchhighlight.vim

" }}}

" Fold Format {{{

runtime rc/folding.vim

" }}}

" Tag Management {{{

runtime rc/tagmanagement.vim

" }}}

" File System {{{

runtime rc/filesystem.vim

" }}}

" Manual Pages {{{

runtime rc/manualpages.vim

" }}}

" --> BASELINE }}}

" PLUGINS --> {{{

" Treesitter {{{

runtime rc/treesitter.vim

" }}}

" Language Server {{{

runtime rc/languageserver.vim

" }}}

" Nvim-lint {{{

runtime rc/nvimlintplugin.vim

" }}}

" Completion with UltiSnips, Coq.nvim, and Wilder.nvim {{{

runtime rc/completionplugin.vim

" }}}

" Lualine.nvim {{{

runtime rc/lualineplugin.vim

" }}}

" Version control: Fugitive, Diffview.nvim, and Neogit {{{

runtime rc/versioncontrolplugin.vim

" }}}

" Marks.nvim {{{

runtime rc/marksplugin.vim

" }}}

" Autopairs.nvim {{{

runtime rc/autopairsplugin.vim

" }}}

" --> PLUGINS }}}

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
nnoremap <Space>si :Telescope ultisnips <CR>

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
