-- File: plugins/comments.lua
-- Purpose: Configure the comment plugin
-- and keymaps for the plugin

return {

  -- Comments plugin
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      local comment = require("Comment")
      comment.setup()
    end,
  },

}
