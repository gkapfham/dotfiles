-- File: plugins/vimtex.lua
-- Purpose: load and configure the vimtex plugin

-- Note about error in vimtex workflow:
-- (1) Open LaTeX main document in nvim
-- (2) Start to compile the document with ,ll
-- (3) Zathura opens the document correctly
-- (4) Make a single change to the document
-- (5) Error: Zathura closes the document
-- (6) Start the preview of document with ,lv
-- (7) Zathura opens document correctly
-- All remaining edits now work correctly
-- Same error is evident if running latexmk separately

return {

  -- vim-sentence-chopper
  {
    ft = "tex",
    "Konfekt/vim-sentence-chopper",
  },

  -- vimtex
  {
    "lervag/vimtex",
    event = "InsertEnter",
    ft = "tex",
    config = function()
      vim.cmd([[
        autocmd BufNewFile,BufRead *.tex set filetype=tex
        " Configure vimtex
        " --> Do not fold
        let g:vimtex_fold_enabled = 0
        " --> Do not open quickfix for warnings
        let g:vimtex_quickfix_open_on_warning = 0
        " --> Do not show the help message
        " let g:vimtex_index_show_help = 0
        " --> Use zathura for the PDF viewer
        " let g:vimtex_view_method = 'sioyek'
        let g:vimtex_view_method = 'zathura'
        " --> Use the nvr program (Neovim-remote)
        "     to facilitate communication between
        "     Neovim and the Zathura PDF viewer
        let g:vimtex_compiler_progname = 'nvr'
        " Configure the latexmk compiler; especially
        " turning off the callback as this seems to
        " generate error messages when compiling
        " and using the zathura program.
        let g:vimtex_compiler_latexmk = {
            \ 'build_dir' : '',
            \ 'callback' : 0,
            \ 'continuous' : 1,
            \ 'executable' : 'latexmk',
            \ 'hooks' : [],
            \ 'options' : [
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \ ],
            \}
        " Define mapping to generate and view the table of contents
        nnoremap <leader>lt :VimtexTocToggle<cr>
        " Define mapping to run a "single-shot" compilation
        " Note that this is especially useful when the LaTeX
        " document requires a long background compilation
        " that is so expensive to always run that if limits
        " the ability to use the text editor interactively
        nnoremap <Space>ll :VimtexCompileSS<cr>
        " Disable syntax highlighting provided by vimtex plugin
        let g:vimtex_syntax_enabled = 0
        " Conceal option
        set conceallevel=1
        let g:tex_conceal='abdmgs'
        " Use tex over plaintex
        let g:tex_flavor = 'tex'
        " Required by the vimtex plugin
        set hidden
        " Use latexindent to break up paragraphs
        " This yields commands like "grip" for formatting with latexindent
        " It is still possible to use commands like "gwip" for paragraph formatting
        nmap gr <plug>(ChopSentences)
        xmap gr <plug>(ChopSentences)
        " Pass options to latexindent
        " Note that latexindent will reference the ~/.indentconfig.yaml
        " file which will point to the ~/.chopsentences.yaml file
        " let g:latexindent_options = '-m -r'
        " Do not use a space after the comment string symbol in LaTeX
        augroup latexcomments
          autocmd!
          autocmd FileType tex setlocal commentstring=%%s
        augroup END
      ]])
    end
  }

}
