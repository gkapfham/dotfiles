" Treesitter {{{

" Use the treesitter for all of the possible languages available
" Include the configuration for all plugins that use treesitter

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers),
  -- or a list of languages
  ensure_installed = "maintained",
  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- true gives more syntax information
    -- false (sometimes) gives better highlighting in LaTeX
    additional_vim_regex_highlighting = true,
  },
  indent = {
    -- false disables because Python Treesitter is buggy right now
    enable = false
  },
  -- enable treesitter for the matchup plugin that enhances matches
  -- highlighting and movements using the % symbol
  matchup = {
    enable = true,
  },
}
EOF

" }}}
