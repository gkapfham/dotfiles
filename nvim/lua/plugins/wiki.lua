-- File: plugins/wiki.lua
-- Purpose: Configure the wiki plugin
-- and keymaps for the plugin

return {

  -- wiki.vim
  {
    "lervag/wiki.vim",
    cmd = {"WikiEnable"},
    config = function()
      vim.cmd([[
       let g:wiki_root = '~/working/wiki'
       ]])
    end,
    keys = {
      -- Toggle display
      { "<Space>ww", "<cmd> WikiPages<CR>", desc = "Wiki: Display all pages" },
      { "<Space>wt", "<cmd> WikiTags<CR>", desc = "Wiki: Display all tags" },
    }
  },

}
