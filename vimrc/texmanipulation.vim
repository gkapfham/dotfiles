" Text Manipulation {{{

" Insert a blank line at end of line
nmap oo Ojk

" Insert a blank line at cursor
nnoremap oO i<CR><ESC>

" Support the backspace key in insert mode
set backspace=indent,eol,start

" Interactive EasyAlign in visual mode (e.g., 'vipga')
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g., gaip)
nmap ga <Plug>(EasyAlign)

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Configure the autopairs.nvim plugin
lua << EOF
local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

npairs.setup({ map_bs = false, map_cr = false })
vim.g.coq_settings = { keymap = { recommended = false } }

-- skip it, if you use another global object
_G.MUtils= {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return npairs.esc('<c-y>')
    else
      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
EOF

" Configure the matchup plugin to display diagnostics about location
nnoremap <c-k> :<c-u>MatchupWhereAmI<CR>

" Remove trailing whitespace
nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" Fix a misspelling with next-best word
nmap <silent> zn <Plug>(SpellRotateForward)
nmap <silent> zp <Plug>(SpellRotateBackward)
vmap <silent> zn <Plug>(SpellRotateForwardV)
vmap <silent> zp <Plug>(SpellRotateBackwardV)

" Toggle the display of spelling mistakes
nmap <silent> <leader>s :set spell!<CR>

" }}}

