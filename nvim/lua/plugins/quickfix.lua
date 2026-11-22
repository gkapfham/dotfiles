-- File: plugins/quickfix.lua
-- Purpose: load and configure quickfix plugin

return {

  -- trouble.nvim
  -- Improve preview of diagnostics and
  -- the quickfix and locations lists
  {
    "folke/trouble.nvim",
    opts = {
      auto_preview = false,
    },
    cmd = "Trouble",
    keys = {
      {
        "<Space>td",
        "<cmd>Trouble diagnostics toggle filter.buf=0 focus=false pinned=true win.relative=win win.position=right<cr>",
        desc = "Trouble: Buffer Diagnostics",
      },
      {
        "<Space>tD",
        "<cmd>Trouble diagnostics toggle focus=false pinned=true win.relative=win win.position=right<cr>",
        desc = "Trouble: Diagnostics",
      },
      {
        "<Space>to",
        "<cmd>Trouble symbols toggle focus=false pinned=true win.relative=win win.position=right<cr>",
        desc = "Trouble: Symbols",
      },
      {
        "<Space>ql",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Trouble: Location List",
      },
      {
        "<Space>qf",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Trouble: Quickfix List",
      },
    },
  }

}
