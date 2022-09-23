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
    width = "22%",
    -- height = "100%",
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

" lua << EOF
" function send_visual_selection_to_terminal()
"     -- Custom function to send visual selection to toggled terminal
"     local current_window = vim.api.nvim_get_current_win()
"
"     -- Get the start and the end of the visual selection
"     local b_line, b_col = unpack(vim.fn.getpos("'<"),2,3)
"     local e_line, e_col = unpack(vim.fn.getpos("'>"),2,3)
"     local lines = vim.api.nvim_buf_get_lines(0, b_line - 1, e_line, 0)
"     if #lines == 0 then return end
"
"     -- Send each line to the terminal
"     for _, v in ipairs(lines) do
"         -- Trim string from spaces
"         v = v:gsub("^%s+", ""):gsub("%s+$", "")
"         require("toggleterm").exec(v, 1)
"     end
"
"     -- Jump back with the cursor where we were at the beginning of the selection
"     vim.api.nvim_set_current_win(current_window)
"     vim.fn.cursor(b_line, b_col)
" end
" EOF
"
" command! -range ToggleTermSendCurrentVisual '<,'> lua send_visual_selection_to_terminal()<CR>

" Define a special configuration for terminal buffers
augroup toggletermconfiguration
  autocmd!
  " Disable spell checking for the term buffers
  au TermOpen * setlocal nospell
augroup END

" Designate interactive Python notebooks as Python files
" as this is useful for editing with jupytext and then
" an ipython running in a toggleterm
" au VimEnter,BufRead,BufNewFile *.ipynb set filetype=python

let g:jupytext_filetype_map = {'md': 'python'}

" Define a mapping to open and close the toggleterm
" A toggleterm can be used for quick access to a
" terminal window when one through tmux is not
" available or quick to access. Also, a toggleterm
" can be easily used to run test suites!
nnoremap <Space>te :ToggleTerm <CR>

" }}}
