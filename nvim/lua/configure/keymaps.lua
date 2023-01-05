-- Define keymaps not specifically connected to a plugin

-- Insert mode key mappings {{{

vim.keymap.set("i", "jk", "<ESC>", { desc = "Custom keymap: Escape" })

-- }}}

-- Normal mode key mappings {{{

-- buffers
vim.keymap.set("n", "<Space>u", "<cmd>b#<cr>", { desc = "Custom keymap: Previous buffer" })

-- command mode
vim.keymap.set("n", "<leader><leader>", ":", { desc = "Custom keymap: Enter command mode" })

-- lines
vim.keymap.set("n", "oo", "O<ESC>", { desc = "Custom keymap: Insert a blank line at end of line" })
vim.keymap.set("n", "oO", "i<cr><ESC>", { desc = "Custom keymap: Insert a blank line at the cursor location" })

-- quitting
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Custom keymap: Quit all" })

-- }}}


