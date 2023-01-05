return {

  -- fugitive
  {
    "tpope/vim-fugitive",
    cmd = {"G", "Git", "Gwrite"},
    keys = {
      -- git status
      { "<Space>gg", ":Git <CR>", desc = "Fugitive: Git status" },
      { "<leader>gg", ":Git <CR>", desc = "Fugitive: Git status" },
      -- git write 
      { "<Space>gw", ":Gwrite <CR>", desc = "Fugitive: Git write to add file" },
      { "<leader>gw", ":Gwrite <CR>", desc = "Fugitive: Git write to add file" },
      -- git commit
      { "<leader>gcc", ":Git commit <CR>", desc = "Fugitive: Commit current hunk" },
      { "<leader>gcf", ":Git commit %<CR>", desc = "Fugitive: Commit current file" },
      { "<leader>gca", ":Git commit -a<CR>", desc = "Fugitive: Commit all files" },
    }
  }

}
