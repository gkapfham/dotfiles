-- commands

vim.api.nvim_create_user_command(
  "Reload",
  function(input)
    vim.call("source", "$MYVIMRC", input.bang)
  end,
  {bang = true, desc = "Custom Command: Reload the contents of init.lua"}
)
