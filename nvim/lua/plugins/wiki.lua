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
      -- Define key mappins
      { "<Space>we", "<cmd> WikiEnable<CR>", desc = "Wiki: Enable" },
      { "<Space>ww", "<cmd> WikiPages<CR>", desc = "Wiki: Display all pages" },
      { "<Space>wt", "<cmd> WikiTags<CR>", desc = "Wiki: Display all tags" },
      { "<Space>wg", "<cmd> WikiTocGenerate<CR>", desc = "Wiki: Generator table-of-contents" },
      { "<Space>wn", "<cmd> WikiToc<CR>", desc = "Wiki: Generator table-of-contents" },
    }
  },

}
