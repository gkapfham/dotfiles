" marks.nvim {{{

lua << EOF
require'marks'.setup {
  -- do not use the default keybindings
  default_mappings = false,
  -- make movements cycle back to the beginning/end of buffer
  cyclic = true,
  -- do not save the marks into the shada file
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 150,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- define mappings that are different than the default
  mappings = {
    next = "]m",
    prev = "[m",
    delete = "dm",
    delete_line = "dm-",
    delete_buf = "dm<space>",
    preview = "m;",
  }
}
EOF

" }}}
