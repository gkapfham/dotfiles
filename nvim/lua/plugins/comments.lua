-- File: plugins/comments.lua
-- Purpose: Configure the comment plugin
-- and keymaps for the plugin

return {

  -- Comment.nvim
  -- Comment source code and other
  -- files in an automatic way
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      local comment = require("Comment")
      comment.setup()
    end,
  },
}
