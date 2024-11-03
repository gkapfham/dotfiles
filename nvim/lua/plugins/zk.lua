-- File: plugins/zk.lua
-- Purpose: Configure the zk plugin
-- that supports the zettelkasten method
-- for taking, organizing, and storing notes

return {

  {
    "zk-org/zk-nvim",
    event = "VeryLazy",
    config = function()
      require("zk").setup({
        picker = "telescope",
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
    end,
    -- Keys
    keys = {
      -- New note
      { "<Space>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') } <CR>", desc = "Zk: New Note" },
      -- Open notes
      { "<Space>zo", "<Cmd>ZkNotes { sort = { 'modified' } } <CR>", desc = "Zk: Open Notes" },
      -- Open notes by tags
      { "<Space>zt", "<Cmd>ZkTags <CR>", desc = "Zk: Open Notes by Tags" },
      -- Open backlinks to a note
      { "<Space>zt", "<Cmd>ZkBacklinks <CR>", desc = "Zk: Open Backlinks to a Note" },
      -- Find notes
      { "<Space>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } } <CR>",
        desc = "Zk: Find Matching Notes" },
      -- Find notes in visual mode
      { "<Space>zf", ":'<,'>ZkMatch<CR>", desc = "Zk: Find Matching Notes", mode = "v" },
    },
  }

}
