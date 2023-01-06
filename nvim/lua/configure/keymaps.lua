-- Define keymaps not specifically connected to a plugin

-- Use the nvim API

-- Insert mode key mappings {{{

-- remap escape
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
vim.keymap.set("n", "<Space>qq", "<cmd>qa<cr>", { desc = "Custom keymap: Quit all" })

-- }}}

-- Use vim.cmd

vim.cmd([[
" Remove trailing whitespace
nnoremap <leader>rtw :%s/\s\+$//e<CR>

" Fix a misspelling with next-best word
nmap <silent> zn <Plug>(SpellRotateForward)
nmap <silent> zp <Plug>(SpellRotateBackward)
vmap <silent> zn <Plug>(SpellRotateForwardV)
vmap <silent> zp <Plug>(SpellRotateBackwardV)

" Toggle the display of spelling mistakes
nmap <leader>s :set spell!<CR>
]])
