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

" Configure the git-conflict.nvim plugin

lua << EOF
require('git-conflict').setup {
  default_mappings = true,
  disable_diagnostics = false,
  highlights = {
    incoming = 'DiffAdd',
    current = 'DiffAdd',
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
  watch_gitdir = {
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
