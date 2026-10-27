-- File: configure/autocmds.lua
-- Purpose: Define global autocommands

-- Check if a file should be reloaded when it is changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Set COLORTERM to truecolor for Neovim's terminal
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("let g:terminal_color_0 = '#767676'")
    vim.cmd("let g:terminal_color_1 = '#d78700'")
    vim.cmd("let g:terminal_color_2 = '#6f9500'")
    vim.cmd("let g:terminal_color_3 = '#b7b757'")
    vim.cmd("let g:terminal_color_4 = '#87afd7'")
    vim.cmd("let g:terminal_color_5 = '#a569a5'")
    vim.cmd("let g:terminal_color_6 = '#d75f5f'")
    vim.cmd("let g:terminal_color_7 = '#b2b2b2'")
    vim.cmd("let g:terminal_color_8 = '#767676'")
    vim.cmd("let g:terminal_color_9 = '#d78700'")
    vim.cmd("let g:terminal_color_10 = '#6f9500'")
    vim.cmd("let g:terminal_color_11 = '#b7b757'")
    vim.cmd("let g:terminal_color_12 = '#87afd7'")
    vim.cmd("let g:terminal_color_13 = '#a569a5'")
    vim.cmd("let g:terminal_color_14 = '#d75f5f'")
    vim.cmd("let g:terminal_color_15 = '#b2b2b2'")
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
