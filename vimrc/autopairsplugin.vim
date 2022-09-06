" Autopairs {{{

" Configure the nvim-ts-autotag plugin

" lua << EOF
" require('nvim-ts-autotag').setup()
" EOF

" let g:closetag_filetypes = 'markdown,liquid,html,xhtml,phtml'

lua << EOF
require("nvim-autopairs").setup {}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
EOF

# }}}
