-- File: plugins/versioncontrol.lua
-- Purpose: load and configure all plugins that
-- integrate with the Git version control system

return {

  -- Fugitive
  {
    "tpope/vim-fugitive",
    cmd = {"G", "Git", "Gwrite"},
    keys = {
      -- Keys: git status
      { "<Space>gg", ":Git <CR>", desc = "Fugitive: Git status" },
      { "<leader>gg", ":Git <CR>", desc = "Fugitive: Git status" },
      -- Keys: git write
      { "<Space>gw", ":Gwrite <CR>", desc = "Fugitive: Git write to add file" },
      { "<leader>gw", ":Gwrite <CR>", desc = "Fugitive: Git write to add file" },
      -- Keys: git commit
      { "<Space>gcc", ":Git commit <CR>", desc = "Fugitive: Commit current hunk" },
      { "<leader>gcc", ":Git commit <CR>", desc = "Fugitive: Commit current hunk" },
      { "<Space>gcf", ":Git commit %<CR>", desc = "Fugitive: Commit current file" },
      { "<leader>gcf", ":Git commit %<CR>", desc = "Fugitive: Commit current file" },
      { "<Space>gca", ":Git commit -a<CR>", desc = "Fugitive: Commit all files" },
      { "<leader>gca", ":Git commit -a<CR>", desc = "Fugitive: Commit all files" },
    }
  },

  -- Flog
  {
    "rbong/vim-flog",
    dependencies = {
      "tpope/vim-fugitive",
    },
    cmd = {"Flog", "Flogsplit"},
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = {hl = 'DiffAdd'   , text = '+', numhl='None', linehl='None'},
          change       = {hl = 'DiffChange', text = '~', numhl='None', linehl='None'},
          delete       = {hl = 'DiffDelete', text = '-', numhl='None', linehl='None'},
          topdelete    = {hl = 'DiffDelete', text = '^', numhl='None', linehl='None'},
          changedelete = {hl = 'DiffChange', text = '~', numhl='None', linehl='None'},
        },
        numhl = false,
        linehl = false,
        keymaps = {
          -- Default keymap options
          noremap = true,
          buffer = true,
          ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
          ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},
          ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
          ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
          ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
          -- Text objects
          ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
          ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
        },
        watch_gitdir = {
          interval = 500
        },
        diff_opts = {
          internal = true
        },
        attach_to_untracked = false,
        current_line_blame = false,
        sign_priority = 100,
        update_debounce = 50,
        status_formatter = nil,
      }
    end,
  },

}
