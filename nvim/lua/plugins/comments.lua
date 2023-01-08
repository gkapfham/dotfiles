-- File: plugins/comments.lua
-- Purpose: Configure the comment plugin
-- and keymaps for the plugin

return {

  -- Comments plugin
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = function()
      local comment = require("Comment")
      comment.setup()
      vim.cmd([[nmap <Space>cc :execute "normal! i" . split(&commentstring, '%s')[0]<CR>]])
    end,
  },

}
