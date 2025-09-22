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

-- temporary workaround to ensure that
-- the :Inspect and :InspectTree functions
-- work correctly. Reference:
-- https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

-- Define the leader key and localleader key
-- to be the same key. It is also worth noting
-- that several of my mappings use the space
-- bar as the main trigger along with or
-- instead of using one of these leader keys

-- Define the leader key
vim.g.mapleader = ","

-- Define the localleader key
vim.g.maplocalleader = ","

-- Filetype detection and settings
vim.cmd('filetype plugin indent on')

-- Setup the lazy.nvim to search for lua files
-- in the plugins/ directory, load the color
-- scheme, and make additional default settings
require("lazy").setup({
  spec = "plugins",
  -- Always load all of the plugins in lazyily
  defaults = { lazy = true, },
  install = { colorscheme = { "onedark_dark" } },
  -- Do not automatically perform the check
  -- for plugins and produce diagnostic message
  checker = { enabled = false },
  -- Detect changes to the configuration and
  -- attempt to reload but without notifications
  change_detection = {
    enabled = true,
    notify = true,
  },
  -- Configure the user interface to have a rounded
  -- border and to specify other cosmetic features
  -- as needed; make sure to see the color scheme
  -- in the colorscheme.lua file for more details
  -- concerning the themeing of Lazy's interface
  ui = {
    border = "rounded",
  },
  -- Disable plugins that are internal to neovim;
  -- they are not needed and hamper performance
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
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

-- Always enter insert mode when editing git commit messages
local setupcommit = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
      vim.cmd("startinsert")
    end,
  })
end
setupcommit()

-- Always set the filetype to markdown for .md and .qmd files
-- local setupmarkdown = function()
--   vim.cmd([[
--     autocmd BufNewFile,BufRead *.md set filetype=markdown
--     autocmd BufNewFile,BufRead *.qmd set filetype=markdown
--     ]])
-- end
-- setupmarkdown()

-- Load the files in the configure module
require("configure.settings")
require("configure.autocmds")
require("configure.keymaps")
require("configure.commands")
