" Completion with UltiSnips, Coq.nvim, and Wilder.nvim {{{

" Completion engine is compatible with UltiSnips
let g:UltiSnipsExpandTrigger='<C-s>'
let g:UltiSnipsJumpForwardTrigger='<C-s>'
let g:UltiSnipsJumpBackwardTrigger='<C-j>'

set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.

  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },

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

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
    })
  })

  -- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  -- cmp.setup.cmdline('/', {
  --   sources = {
  --     { name = 'buffer' }
  --   }
  -- })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- -- Setup lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['pyright'].setup {
  --   capabilities = capabilities
  -- }

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

" Basic configuration for the wilder.nvim plugin
" that makes searching in the wildmenu possible
call wilder#setup({'modes': [':', '/', '?']})

" Configure the wilder.nvim so that it supports
" the theme from the lightline and renders in it;
" this means that the completion items render in
" the lightline at the bottom of the screen. Nice!
call wilder#set_option('renderer', wilder#wildmenu_renderer(
      \ wilder#wildmenu_lightline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': ' · ',
      \ })))

" }}}
