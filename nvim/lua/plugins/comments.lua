-- File: plugins/comments.lua
-- Purpose: Configure the comment plugin
-- and keymaps for the plugin

return {

  -- mini.comment
  -- Comment source code and other
  -- files in an automatic way
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = function()
      require("mini.comment").setup({})
    end,
  },
}
