" Testing {{{

" " Run the test suite async and display in quickfix
" let test#strategy = "tslime"

" " Always run pytest test suites so that:
" " -x: stop testing as soon as test fails
" " -s: display all standard output and standard error
" let test#python#pytest#options = '-x -s'

lua << EOF
  require("nvim-test").setup{
    term = "terminal",
    termOpts = {
        direction = "horizontal",
        height = 15,
        go_back = false,
        stopinsert = "auto",
        keep_one = true,
      },

  }
EOF

" Run all/part of a test suite
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

" }}}
