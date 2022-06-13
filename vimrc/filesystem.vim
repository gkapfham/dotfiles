" File System {{{

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
  renderer = {
   icons = {
      glyphs = {
          default = '',
        }
     }
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
    -- auto_resize = true,
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

" Configure the toggleterm plugin
lua << EOF
require("toggleterm").setup{
  start_in_insert = false,
}
EOF

" Define a special configuration for man buffers
augroup toggletermconfiguration
  autocmd!
  " Disable spell checking for the term buffers
  au TermOpen * setlocal nospell
augroup END

" }}}
