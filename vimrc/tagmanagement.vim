" Tags {{{

" Specify where the tags are stored
set tags=./tags;/,tags;/

" Perform highlighting asynchronously when file is loaded or saved
let g:highlighter#auto_update = 2

" Configure gutentags plugin
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 1

" Only allow Gutentags to generate a tag file that indexes the files
" that are returned by a tool like ripgrep, which is already configured
" to ignore those files that are inside of the .gitignore file
let g:gutentags_file_list_command = 'rg --files'

" }}}
