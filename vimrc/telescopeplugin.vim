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
-- require('telescope').load_extension('ultisnips')
require('telescope').load_extension('luasnip')

-- load and configure the refactoring telescope extension
-- note that refactoring requires section of code in visual mode
require("telescope").load_extension("refactoring")
vim.api.nvim_set_keymap(
    "v",
    "<space>rr",
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true }
)
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
nmap <Space>rf :Telescope current_buffer_fuzzy_find <CR>
nmap <Space>m :Telescope marks <CR>

" --> Tags in buffer or all tags across the project directory
" define mappings for both Telescope and FZF since tag-based
" navigation with Telescope fails with error, especially for:
"  -- LaTeX
"  -- Markdown
" Note that <Space> always uses Telescope and
" <Leader> always uses fzf
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
nnoremap <Space>si :Telescope luasnip <CR>

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
