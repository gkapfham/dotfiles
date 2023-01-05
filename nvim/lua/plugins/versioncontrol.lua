return {

  -- Fugitive
  {
    "tpope/vim-fugitive",
    cmd = {"G", "Git", "Gwrite"},
    keys = {
      -- Keys: git status
      { "<Space>gg", ":Git <CR>", desc = "Fugitive: Git status" },
      { "<leader>gg", ":Git <CR>", desc = "Fugitive: Git status" },
      -- Keys: git write 
      { "<Space>gw", ":Gwrite <CR>", desc = "Fugitive: Git write to add file" },
      { "<leader>gw", ":Gwrite <CR>", desc = "Fugitive: Git write to add file" },
      -- Keys: git commit
      { "<Space>gcc", ":Git commit <CR>", desc = "Fugitive: Commit current hunk" },
      { "<leader>gcc", ":Git commit <CR>", desc = "Fugitive: Commit current hunk" },
      { "<Space>gcf", ":Git commit %<CR>", desc = "Fugitive: Commit current file" },
      { "<leader>gcf", ":Git commit %<CR>", desc = "Fugitive: Commit current file" },
      { "<Space>gca", ":Git commit -a<CR>", desc = "Fugitive: Commit all files" },
      { "<leader>gca", ":Git commit -a<CR>", desc = "Fugitive: Commit all files" },
    }
  }

}
