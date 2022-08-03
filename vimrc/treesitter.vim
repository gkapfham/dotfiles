" Treesitter {{{

" Use the treesitter for all of the possible languages available
" Include the configuration for all plugins that use treesitter

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers),
  -- or a list of languages
  ensure_installed = "all",
  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- true gives more syntax information
    -- false (sometimes) gives better highlighting in LaTeX
    additional_vim_regex_highlighting = true,
    -- disable use of treesitter highlighting
    -- for languages as the color choices are poor
    disable = {"markdown", "toml"},
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

lua << EOF
-- Call the setup function to change the default behavior
require("aerial").setup({
  backends = { "treesitter", "lsp", "markdown" },
  close_behavior = "auto",
  default_bindings = true,
  default_direction = "right",
  disable_max_lines = 10000,
  disable_max_size = 2000000, -- Default 2MB
  filter_kind = {
    "Array",
    "Class",
    "Constant",
    "Constructor",
    "Enum",
    "EnumMember",
    "File",
    "Field",
    "Function",
    "Interface",
    "Key",
    "Method",
    "Module",
    "Namespace",
    "Object",
    "Operator",
    "Package",
    "Property",
    "Struct",
    "TypeParameter",
    "Variable",
  },
  highlight_mode = "full_width",
  highlight_closest = true,
  highlight_on_hover = true,
  highlight_on_jump = 300,
  icons = {},
  ignore = {
    unlisted_buffers = true,
    filetypes = {},
    buftypes = "special",
    wintypes = "special",
  },
  link_folds_to_tree = false,
  link_tree_to_folds = true,
  manage_folds = false,
  max_width = { 40, 0.2 },
  width = nil,
  min_width = { 04, 0.2 },
  nerd_font = "auto",
  on_attach = nil,
  on_first_symbols = nil,
  open_automatic = false,
  placement_editor_edge = false,
  post_jump_cmd = "normal! zz",
  close_on_select = false,
  show_guides = true,
  update_events = "TextChanged,InsertLeave",
  guides = {
    -- When the child item has a sibling below it
    mid_item = "├─",
    -- When the child item is the last in the list
    last_item = "└─",
    -- When there are nested child guides to the right
    nested_top = "│ ",
    -- Raw indentation
    whitespace = "  ",
  },
  lsp = {
    -- Fetch document symbols when LSP diagnostics update.
    -- If false, will update on buffer changes.
    diagnostics_trigger_update = true,
    -- Set to false to not update the symbols when there are LSP errors
    update_when_errors = true,
    -- How long to wait (in ms) after a buffer change before updating
    -- Only used when diagnostics_trigger_update = false
    update_delay = 300,
  },
  treesitter = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 300,
  },
  markdown = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 300,
  },
})
EOF

" Configure the matchup plugin to display diagnostics about location
nnoremap <c-k> :MatchupWhereAmI<CR>

" }}}
