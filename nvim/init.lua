-- Bootstrap the use of lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Define the leader key
vim.g.mapleader = ","

-- Setup the lazy.nvim to search for lua files
-- in the plugins/ directory, load the color
-- scheme, and make additional default settings
require("lazy").setup({
  spec = "plugins",
  -- always load all of the plugins in lazyily
  defaults = { lazy = true, version = "*" },
  install = { colorscheme = { "vitaminonec" } },
  -- do not automatically perform the check
  -- for plugins and produce diagnostic message
  checker = { enabled = false },
  -- detect changes to the configuration and
  -- attempt to reload but without notifications
  change_detection = {
    enabled = true,
    notify = true,
  },
  -- disable plugins that are internal to neovim;
  -- they are not needed and hamper performance
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Define the keymap for loading lazy dashboard
vim.keymap.set("n", "<Space>sl", "<cmd>:Lazy<cr>")
vim.keymap.set("n", "<leader>sl", "<cmd>:Lazy<cr>")

-- Load the files in the configure module
require("configure.settings")
require("configure.autocmds")
require("configure.keymaps")
require("configure.commands")

-- Diagnostic that display at startup

-- local Util = require("lazy.core.util")
-- Util.walk(vim.env.VIMRUNTIME .. "/plugin", function(path, name, t)
--  print(table.concat({ path, name, t }, " | "))
-- end)

-- Util.lsmod("plugins", function(modname, modpath)
--  print(modname .. ": " .. modpath)
-- end)

