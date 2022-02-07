" Completion with UltiSnips, Coq.nvim, and Wilder.nvim {{{

" Completion engine is compatible with UltiSnips
let g:UltiSnipsExpandTrigger='<C-s>'
let g:UltiSnipsJumpForwardTrigger='<C-s>'
let g:UltiSnipsJumpBackwardTrigger='<C-j>'

set completeopt=menu,menuone,noselect

lua <<EOF
-- define symbols for the icons used by nvim-cmp
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

-- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  -- use the custom view packaged by nvim-cmp
  view = {
        entries = "custom"
  },
  formatting = {
      format = function(entry, vim_item)
        -- define the icons used for the completion labels
        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
        -- define labels for the completion menu
        vim_item.menu = ({
          buffer = "[Buffer]",
          tmux = "[Tmux]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[LaTeX]",
        })[entry.source.name]
        return vim_item
      end
    },
  -- define mappings for the keyboard commands when using completion menu
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
  -- define the sources for the completions
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'treesitter' },
    { name = 'tmux', },
    { name = 'ultisnips' },
  }, {
    { name = 'path' },
  })
})

-- use completion sources when forward-searching with "/"
cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'buffer' }
  }, {
    { name = 'cmdline' }
  })
})

-- use completion sources when backward-searching with "?"
cmp.setup.cmdline('?', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'buffer' }
  }, {
    { name = 'cmdline' }
  })
})

-- use completion sources when running commands with ":"
require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})

EOF

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
