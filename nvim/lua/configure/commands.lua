-- File: Commands

-- Wrapping
vim.api.nvim_create_user_command("NoWrap", "set textwidth=0", {})
vim.api.nvim_create_user_command("StandardWrap", "set textwidth=80", {})
vim.api.nvim_create_user_command("Wrap", "set textwidth=120", {})
