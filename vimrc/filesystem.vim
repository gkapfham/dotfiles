" File System {{{

" " Configure the nvim-tree.lua plugin
" lua << EOF
" require'nvim-tree'.setup {
"   disable_netrw       = true,
"   hijack_netrw        = true,
"   open_on_setup       = false,
"   ignore_ft_on_setup  = {},
"   open_on_tab         = false,
"   hijack_cursor       = false,
"   update_cwd          = true,
"   renderer = {
"    icons = {
"       glyphs = {
"           default = '',
"         }
"      }
"   },
"   diagnostics = {
"     enable = false,
"     icons = {
"       hint = "",
"       info = "",
"       warning = "",
"       error = "",
"     }
"   },
"   update_focused_file = {
"     enable      = true,
"     update_cwd  = true,
"     ignore_list = {}
"   },
"   system_open = {
"     cmd  = nil,
"     args = {}
"   },
"   filters = {
"     dotfiles = false,
"     custom = {}
"   },
"   git = {
"     enable = true,
"     ignore = true,
"     timeout = 500,
"   },
"   view = {
"     width = "22%",
"     -- height = "100%",
"     hide_root_folder = false,
"     side = 'right',
"     -- auto_resize = true,
"     mappings = {
"       custom_only = false,
"       list = {}
"     },
"     number = false,
"     relativenumber = false,
"     signcolumn = "yes"
"   },
"   trash = {
"     cmd = "trash",
"     require_confirm = true
"   },
"   actions = {
"     change_dir = {
"       global = false,
"     },
"     open_file = {
"       quit_on_open = false,
"     }
"   },
" }
" EOF

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

" Configure the neo-tree plugin
lua << EOF
require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = false,
        sort_function = nil,
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 1,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = nil,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            default = "*",
            highlight = "NeoTreeFileIcon"
          },
          modified = {
            symbol = "",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = false,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added     = "",
              modified  = "",
              deleted   = "",
              renamed   = "",
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "",
              staged    = "",
              conflict  = "",
            }
          },
        },
        window = {
          position = "right",
          width = "20%",
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
                "toggle_node",
                nowait = false,
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = false } },
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              config = {
                show_path = "none" -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
          }
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true,
            hide_by_name = {
            },
            hide_by_pattern = {
            },
            always_show = {
            },
            never_show = {
            },
            never_show_by_pattern = {
            },
          },
          follow_current_file = false,
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                                                  -- in whatever position is specified in window.position
                                -- "open_current",  -- netrw disabled, opening a directory opens within the
                                                  -- window like netrw would, regardless of window.position
                                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
                                          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["-"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
            }
          }
        },
        buffers = {
          follow_current_file = true, -- This will find and focus the file in the active buffer every
                                       -- time the current file is changed while the tree is open.
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            }
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            }
          }
        }
      })
EOF

" Define a mapping for toggling the nvim-tree
" nnoremap <Space>0 :NvimTreeToggle<CR>
nnoremap <Space>0 :NeoTreeShowToggle<CR>

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
