" lualine.nvim {{{

lua << EOF
-- Define a function for displaying the current result number
-- out of total number of results when searching with / or ?
vim.o.shortmess = vim.o.shortmess .. "S"
local function search_count()
    if vim.api.nvim_get_vvar("hlsearch") == 1 then
        local res = vim.fn.searchcount({ maxcount = 999, timeout = 500 })
        if res.total > 0 then
            return string.format(" %d/%d %s", res.current, res.total, vim.fn.getreg('/'))
        end
    end
    return ""
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

local function encoding_prefix()
  return ""
end

local function location_prefix()
  return ""
end

 -- Define the color scheme for the lualine
local colors = {
  color2   = "#87afd7",
  color7   = "#e06c75",
  color10  = "#afaf5f",
  color6   = "#626262",
  color3   = "#875f87",
  color1   = "#262626",
  -- color0   = "#bcbcbc",
  color0   = "#A8A8AF",
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
  -- Define the global options for lualine
  options = {
    icons_enabled = true,
    theme = vitaminonec,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  -- Define how quickly the lualine must update
  refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
  },
  -- Bottom section of status line
  sections = {
    -- Bottom left display
    -- from left (far left corner) to right (middle): {a} {b} {c}
    lualine_a = {'mode'},
    lualine_b = {'branch', {'diff', source = diff_source}},
    lualine_c = {'StatuslineReadonly', 'FileTree', {'filename', path=1}, {"aerial", colored=false}, {search_count, type = "lua_expr"}},
    -- Bottom right display
    -- from left (middle) to right (far right corner): {x} {y} {z}
    lualine_x = {'lsp_progress', 'progress', 'location'},
    lualine_y = {{encoding_prefix, type="lua_expr"}, 'encoding', {'fileformat', symbols = {
                    unix = 'Unix - LF',
                    dos = 'Win - CRLF',
                    mac = 'Mac - CR',
                }}},
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
  -- do not use the winbar because it seems to cause
  -- other plugins to crash and produce incorrect output
  -- winbar = {
    -- lualine_a = {{"filename", path=1, color={fg = "#bcbcbc", bg="#262626"}}},
    -- lualine_b = {{"aerial", color={fg = "#bcbcbc", bg="#262626"}}},
    -- lualine_y = {{'diagnostics', symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}}},
  -- },
  tabline = {
    -- Top left display
    -- from left (far left corner) to right (middle): {a} {b} {c}
    -- Note that {b} and {c} are currently disabled because there
    -- are normally a significant number of buffers on display in {a}
    lualine_a = {
      {'buffers',
        show_modified_status = true,
        -- Define a custom label for the Aerial buffer;
        -- note that other plugins seem to do this automatically
        -- but unless it is done for Aerial it will show a "No Name"
        -- label whenever you change into the Aerial buffer
        filetype_names = {
          aerial="Aerial"
        },
        -- Define symbols attached to each file in the tabline
        symbols = {
          modified = ' ●',
          alternate_file = ' ',
          directory =  '',
        },
      }
    },
    lualine_b = {},
    lualine_c = {},
    -- Top right display
    -- from left (middle) to right (far right corner): {x} {y} {z}
    lualine_x = {{'diagnostics', symbols = {error = ' ', warn = 'ﱥ ', info = ' ', hint = ' '}}},
    lualine_y = {'StatuslinePythonEnvironment', 'StatuslineGutentags', 'StatuslineSpell'},
    lualine_z = {}
  },
  -- define the extensions which ensure that lualine
  -- makes better customized menus when they are used
  extensions = {'quickfix', 'toggleterm', 'aerial'},
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

" Display a file tree symbol
function! FileTree()
  return ''
endfunction

" }}}
