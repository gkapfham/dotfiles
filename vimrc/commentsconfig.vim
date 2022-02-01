" Comments {{{

" Use the comment.nvim plugin
lua << EOF
require('Comment').setup()
EOF

" Insert a comment symbol on the current line at cursor location
nmap <Space>cc :execute "normal! i" . split(&commentstring, '%s')[0]<CR>

" }}}
