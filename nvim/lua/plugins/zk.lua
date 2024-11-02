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
    end
  }

}
