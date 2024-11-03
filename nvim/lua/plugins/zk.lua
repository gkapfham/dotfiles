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
      -- Add the key mappings only for Markdown files in a zk notebook
      if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
        local function map(...) vim.api.nvim_buf_set_keymap(0, ...) end
        local opts = { noremap=true, silent=false }
        -- Preview a linked note
        map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
      end
    end,
    -- Keys
    keys = {
      -- New note
      { "<Space>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') } <CR>", desc = "Zk: New Note" },
      -- Open notes
      { "<Space>zo", "<Cmd>ZkNotes { sort = { 'modified' } } <CR>",         desc = "Zk: Open Notes" },
      -- Open notes by tags
      { "<Space>zt", "<Cmd>ZkTags <CR>",                                    desc = "Zk: Open Notes by Tags" },
      -- Open backlinks to a note
      { "<Space>zb", "<Cmd>ZkBacklinks <CR>",                               desc = "Zk: Open Backlinks to a Note" },
      -- Open links in a note
      { "<Space>zl", "<Cmd>ZkLinks <CR>",                                   desc = "Zk: Open Links in a Note" },
      -- Find notes
      {
        "<Space>zf",
        "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } } <CR>",
        desc = "Zk: Find Matching Notes"
      },
      -- Find notes in visual mode
      { "<Space>zf", ":'<,'>ZkMatch<CR>", desc = "Zk: Find Matching Notes", mode = "v" },
    },
  }

}
