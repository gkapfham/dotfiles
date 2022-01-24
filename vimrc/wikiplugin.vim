" Wiki.vim {{{

" Set the root of the wiki
let g:wiki_root = '~/working/wiki'

" Use markdown filetype and syntax highlighting
" for the .wiki files used in the knowledge base
" NOTE: wiki.vim seems to use .wiki even when I
" set it to use .md as the main file type
augroup WikiFileType
  autocmd!
  au BufNewFile,BufRead,BufEnter *.wiki set syntax=markdown
  au BufNewFile,BufRead,BufEnter *.wiki set filetype=markdown
augroup END

" Define mappings that make it easy to search the pages
" and tags in the wiki using fuzzy search with Fzf
" --> pages in the Wiki in the form of File.wiki
nnoremap <Space>fp :WikiFzfPages <CR>
" --> tags in the form of :tagname:
nnoremap <Space>ft :WikiFzfTags <CR>
" --> the contents of a markdown file
nnoremap <Space>fc :WikiFzfToc <CR>

" }}}
