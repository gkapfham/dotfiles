" File System {{{

" Set the default icon for the nvim-tree.lua
let g:nvim_tree_icons = {
    \ 'default': '',
\}

" Configure the nvim-tree.lua plugin
lua << EOF
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = true,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = "30%",
    height = "100%",
    hide_root_folder = false,
    side = 'right',
    auto_resize = true,
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
  actions = {
    change_dir = {
      global = false,
    },
    open_file = {
      quit_on_open = false,
    }
  },
}
EOF

" Make all of the icons in the nvim-tree.lua the same
" color as the text (ignores the default colors for
" the icons that are not a part of my color scheme)
lua << EOF
local nvim_web_devicons = require "nvim-web-devicons"
local current_icons = nvim_web_devicons.get_icons()
local new_icons = {}
for key, icon in pairs(current_icons) do
    icon.color = "#a8a8a8"
    new_icons[key] = icon
end
nvim_web_devicons.set_icon(new_icons)
nvim_web_devicons.set_default_icon('', '#a8a8a8')
EOF

" Define a mapping for toggling the nvim-tree
nnoremap <Space>0 :NvimTreeToggle<CR>

" " Configure the dirvish plugin
" augroup dirvishconfiguration
"   autocmd!
"   " Disable spell checking for the Dirvish buffers
"   autocmd FileType dirvish setlocal nospell

  " " Map `gr` to reload the Dirvish buffer
  " autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

"   " Map `gh` to hide dot-prefixed files
"   " To toggle this, press `gr` to reload
"   autocmd FileType dirvish nnoremap <silent><buffer>
"         \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
" augroup END

" " Define the symbols used to indicate the status of the
" " version control repository in a dirvish buffer
" let g:dirvish_git_indicators = {
" \ 'Modified'  : '!',
" \ 'Staged'    : '+',
" \ 'Untracked' : '?',
" \ 'Renamed'   : '➜',
" \ 'Unmerged'  : '═',
" \ 'Ignored'   : '',
" \ 'Unknown'   : ''
" \ }

" " Define the highlight color for version control details in dirvish
" let g:gitstatus = 'guifg=#d78700 ctermfg=172'

" " Define the color scheme to always be the same color;
" " this is acceptable because the symbols vary.
" silent exe 'hi default DirvishGitModified '.g:gitstatus
" silent exe 'hi default DirvishGitStaged '.g:gitstatus
" silent exe 'hi default DirvishGitRenamed '.g:gitstatus
" silent exe 'hi default DirvishGitUnmerged '.g:gitstatus
" silent exe 'hi default DirvishGitIgnored guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
" silent exe 'hi default DirvishGitUntracked guifg=NONE guibg=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE'
" silent exe 'hi default link DirvishGitUntrackedDir DirvishPathTail'

" }}}
