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
        height = 11,
        go_back = false,
        stopinsert = "auto",
        keep_one = true,
      },

  }
EOF

" Run all/part of a test suite

" --> Run the test case nearest to the cursor
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <Space>tn :TestNearest<CR>

" --> Run all of the tests in the current file
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <Space>tf :TestFile<CR>

" --> Run all of the tests in the entire test suite
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <Space>ta :TestSuite<CR>

" --> Run the test case that was last previously run
" (this is useful during debugging when there is a
" single failing test case in the test suite)
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <Space>tl :TestLast<CR>

" }}}
