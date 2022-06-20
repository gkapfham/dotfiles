" lualine.nvim {{{

lua << EOF
 -- Define the color scheme for the lualine
local colors = {
  color2   = "#87afd7",
  color7   = "#e06c75",
  color10  = "#afaf5f",
  color6   = "#626262",
  color3   = "#875f87",
  color1   = "#262626",
  color0   = "#bcbcbc",
}
local vitaminonec = {
  normal = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color2 , gui = "bold", },
    c = { fg = colors.color0, bg = colors.color1 },
  },
  visual = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color3 , gui = "bold", },
  },
  inactive = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color0, bg = colors.color1 , gui = "none", },
    c = { fg = colors.color6, bg = colors.color1 },
  },
  replace = {
   jb = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color7 , gui = "bold", },
  },
  insert = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color1, bg = colors.color10 , gui = "bold", },
  },
}

-- Setup the lualine plugin.
-- Use the theme that was previously
-- specified directly above.
-- Display components in all four
-- corners of the Neovim status lines.
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = vitaminonec,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  -- Bottom section of status line
  sections = {
    -- Bottom left display
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'StatuslineReadonly', {'filename', path=1}},
    -- Bottom right display
    lualine_x = {'lsp_progress', 'encoding', {'fileformat', symbols = {
                    unix = 'unix',
                    dos = 'docs',
                    mac = 'mac',
                }}, },
    lualine_y = {'progress', 'location'},
    lualine_z = {'filesize', {'filetype', colored=false}}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      {'buffers',
        show_modified_status = true,
        symbols = {
          modified = ' ●',
          alternate_file = ' ',
          directory =  '',
        },
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {{'diagnostics', symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}}},
    lualine_y = {'StatuslinePythonEnvironment', 'StatuslineGutentags', 'StatuslineSpell'},
    lualine_z = {}
  },
  extensions = {'quickfix', 'toggleterm'},
}
EOF

" }}}

" Support Functions for Lualine {{{

" Display a diagnostic message when gutentags updates;
" this is specifically useful because tag generation is a
" long-running process for large files. As such it is
" useful to know that the long-running process is operating.
function! StatuslineGutentags()
  return gutentags#statusline() !=# '' ? ' Tags ' : 'Tags '
endfunction

" Display a diagnostic message when running Python in a virtual environment
function! StatuslinePythonEnvironment()
  " Extract only the name of the virtual environment from the
  " VIRTUAL_ENV variable; note that it also includes the full
  " directory to the virtual environment that is not suitable
  " for including in a section of a status line.
  let l:venv = $VIRTUAL_ENV
  return l:venv !=# '' ? ' '.split(l:venv, '/')[-1] : ''
endfunction

" Display a lock symbol if the file is read-only (e.g., help files)
function! StatuslineReadonly()
  return &readonly ? '' : ''
endfunction

" Display symbols, not dictionaries, to indicate that spell-checking is running
function! StatuslineSpell()
  " Use a different configuration to show whether
  " or not spell checking is currently running
  return &spell ? 'A-Z ' : 'A-Z '
endfunction

" }}}
