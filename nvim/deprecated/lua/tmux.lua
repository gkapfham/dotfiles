-- File: plugins/tmux.lua
-- Purpose: Configure the plugins
-- for interaction with a tmux window and pane

return {

  -- Configure the tslime.vim plugin;
  -- note that this makes it easily possible
  -- to send Python code to a pre-configured
  -- REPL in another tmux pane or to send a
  -- command for running a test suite. It is
  -- specifically useful with the quarto.nvim
  -- plugin for running Python code.

  -- {
  --   "jgdavey/tslime.vim",
  --   event = "VeryLazy",
  --   config = function()
  --     local comment = require("Comment")
  --     comment.setup()
  --     vim.cmd([[
  --     vmap <C-c><C-c> <Plug>SendSelectionToTmux
  --     nmap <C-c><C-c> <Plug>NormalModeSendToTmux
  --     nmap <C-c>r <Plug>SetTmuxVars
  --     let g:tslime_always_current_session = 1
  --     ]])
  --   end,
  -- },

}
