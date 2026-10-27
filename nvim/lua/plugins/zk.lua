-- File: plugins/zk.lua
-- Purpose: Configure the zk plugin
-- that supports the zettelkasten method
-- for taking, organizing, and storing notes

return {

  -- zk-nvim
  -- Zettelkasten note-taking
  {
    "zk-org/zk-nvim",
    event = "VeryLazy",
    config = function()
      require("zk").setup({
        picker = "snacks_picker",
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
        local opts = { noremap = true, silent = false }
        -- Preview a linked note
        map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
      end
      local zk = require("zk")
      local commands = require("zk.commands")
      local function make_edit_fn(defaults, picker_options)
        return function(options)
          options = vim.tbl_extend("force", defaults, options or {})
          zk.edit(options, picker_options)
        end
      end
      commands.add("ZkOrphans", make_edit_fn({ orphan = true }, { title = "Zk Orphans" }))
      commands.add("ZkRecents", make_edit_fn({ createdAfter = "2 weeks ago" }, { title = "Zk Recents" }))
    end,
    -- Keys
    keys = {
      -- New note
      { "<Space>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') } <CR>", desc = "Zk: New Note" },
      -- Open notes
      { "<Space>zo", "<Cmd>ZkNotes { sort = { 'modified' } } <CR>",         desc = "Zk: Open Notes" },
      -- Open recent notes
      { "<Space>zr", "<Cmd>ZkRecents <CR>",                                 desc = "Zk: Open Recent Notes" },
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
