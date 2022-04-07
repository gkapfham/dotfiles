" Completion plugins: UltiSnips and nvim-cmp and plugins for nvim-cmp {{{

" Completion engine is compatible with UltiSnips
let g:UltiSnipsExpandTrigger='<C-s>'
let g:UltiSnipsJumpForwardTrigger='<C-s>'
let g:UltiSnipsJumpBackwardTrigger='<C-j>'

" Configure insertion mode completion
set completeopt=menuone,noselect

lua << EOF
-- Define symbols for the icons used by nvim-cmp
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

-- Setup nvim-cmp
local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- Specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  -- Use the custom view packaged by nvim-cmp
  view = {
        entries = "custom"
  },
  formatting = {
      format = function(entry, vim_item)
        -- Define the icons used for the completion labels
        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
        -- Define labels for the completion menu
        vim_item.menu = ({
          buffer = " Buffer",
          cmdline = " Command",
          nvim_lsp = " LSP",
          -- The only omnicompletion in use is vimtex
          -- Customize the display to include contextual details (e.g., bibtex entry)
          -- NOTE: this may display "nil" in cases when it is not available
          omni = " Omni " .. (vim.inspect(vim_item.menu):gsub("%'", ""):gsub('%"', "")),
          path = "פּ Path",
          tags = "笠Tags",
          treesitter = " Tree",
        })[entry.source.name]
        return vim_item
      end
    },
  -- Define mappings for the keyboard commands when using completion menu
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp.complete()
                    end
                end,
                i = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                    else
                        fallback()
                    end
                end
            }),
  },
  -- Define the sources for the completions
  sources = cmp.config.sources({
    { name = 'nvim_lsp', max_item_count = 10, priority = 10 },
    { name = 'omni', max_item_count = 10, priority = 10 },
    {
      name = 'buffer', max_item_count = 10, priority = 10,
        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end
        },
    },
    { name = 'treesitter', max_item_count = 5, priority = 2.5 },
    { name = 'tags', max_item_count = 5, priority = 5 },
    { name = 'ultisnips' },
  }, {
    { name = 'tmux', },
    { name = 'path' },
  })
})

-- Use completion sources when forward-searching with "/"
cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'buffer' }
  }, {
    { name = 'cmdline' }
  })
})

-- Use completion sources when backward-searching with "?"
cmp.setup.cmdline('?', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'buffer' }
  }, {
    { name = 'cmdline' }
  })
})

-- Use completion sources when running commands with ":"
require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})
EOF

# Disable completion
command! NoCompletion :lua require('cmp').setup.buffer { enabled = false }

# Enable completion
command! Completion :lua require('cmp').setup.buffer { enabled = true }

" Deprecated configuration for coq.nvim

" " Always start coq.nvim when entering buffer
" autocmd VimEnter * COQnow --shut-up

" " Disable the default coq.nvim keybindings
" let g:coq_settings = { 'keymap.recommended': v:false }

" " Specify customized coq.nvim settings
" ino <silent><expr> <Esc>   pumvisible() ? "\<C-e>" : "\<Esc>"
" ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
" ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
" ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
" ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

" " Additional coq.nvim settings
" let g:coq_settings = {"display.pum.source_context" : ["  ", " "], "display.pum.kind_context" : [" ", " "], 'auto_start': 'shut-up'}

" " Basic configuration for the wilder.nvim plugin
" " that makes searching in the wildmenu possible
" call wilder#setup({'modes': [':', '/', '?']})

" " Configure the wilder.nvim so that it supports
" " the theme from the lightline and renders in it;
" " this means that the completion items render in
" " the lightline at the bottom of the screen. Nice!
" call wilder#set_option('renderer', wilder#wildmenu_renderer(
"       \ wilder#wildmenu_lightline_theme({
"       \   'highlights': {},
"       \   'highlighter': wilder#basic_highlighter(),
"       \   'separator': ' · ',
"       \ })))

" }}}
