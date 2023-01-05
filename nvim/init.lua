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
  defaults = { lazy = true, version = "*" },
  install = { colorscheme = { "vitaminonec" } },
  checker = { enabled = true },
  change_detection = {
    enabled = true,
    notify = false,
  },
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

-- Load the files in the configure module
require("configure.settings")
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

