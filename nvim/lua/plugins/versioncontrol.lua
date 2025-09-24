-- File: plugins/versioncontrol.lua
-- Purpose: load and configure all plugins that
-- integrate with the Git version control system

-- Make it easy to toggle the git status
-- window provided by vim-fugitive, ensuring
-- that the sidebar in the edgy does not close
vim.cmd([[
function! ToggleGstatus() abort
  for l:winnr in range(1, winnr('$'))
    if !empty(getwinvar(l:winnr, 'fugitive_status'))
      exe l:winnr 'close'
      return
    endif
  endfor
  keepalt Git
endfunction
]])

return {

  -- vim-fugitive for git integration
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gwrite" },
    -- config = function()
    --   vim.api.nvim_create_autocmd("FileType", {
    --     pattern = "gitcommit",
    --     callback = function()
    --       vim.cmd("startinsert")
    --     end,
    --   })
    -- end,
    keys = {
      -- Keys: git status
      { "<Space>gg",   ":call ToggleGstatus() <CR>", desc = "Fugitive: Git status toggle" },
      { "<leader>gg",  ":call ToggleGstatus() <CR>", desc = "Fugitive: Git status toggle" },
      -- Keys: git write
      { "<Space>gw",   ":Gwrite <CR>",               desc = "Fugitive: Git write to add file" },
      { "<leader>gw",  ":Gwrite <CR>",               desc = "Fugitive: Git write to add file" },
      -- Keys: git commit
      { "<Space>gcc",  ":Git commit <CR>",           desc = "Fugitive: Commit current hunk" },
      { "<leader>gcc", ":Git commit <CR>",           desc = "Fugitive: Commit current hunk" },
      { "<Space>gcf",  ":Git commit %<CR>",          desc = "Fugitive: Commit current file" },
      { "<leader>gcf", ":Git commit %<CR>",          desc = "Fugitive: Commit current file" },
      { "<Space>gca",  ":Git commit -a<CR>",         desc = "Fugitive: Commit all files" },
      { "<leader>gca", ":Git commit -a<CR>",         desc = "Fugitive: Commit all files" },
    }
  },

  -- diffview.nvim for viewing diffs
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "DiffviewOpen", "DiffviewLog" },
  },

  -- git-conflict.nvim for resolving merge conflicts
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    tag = 'v2.1.0',
    config = true,
  },

  -- gitsigns.nvim for showing git diffs in the sign column
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })
          -- Actions
          map('n', '<leader>hs', gs.stage_hunk)
          map('n', '<leader>hr', gs.reset_hunk)
          map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line { full = true } end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)
          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
        -- Define the signs; note that the color scheme is
        -- now defined in the colorscheme file called
        -- colorscheme.lua in the same directory as this file
        signs = {
          add          = { text = '+', },
          change       = { text = '~', },
          delete       = { text = '-', },
          topdelete    = { text = '^', },
          changedelete = { text = '~', },
          untracked    = { text = '?', },
        },
        numhl = false,
        linehl = false,
        watch_gitdir = {
          follow_files = true,
          -- interval = 100
        },
        -- diff_opts = {
        --   internal = true
        -- },
        preview_config = {
          border = "rounded"
        },
        attach_to_untracked = false,
        current_line_blame = false,
        sign_priority = 1,
        update_debounce = 50,
        status_formatter = nil,
      }
    end,
  },

  -- mini.diff for showing diffs in the buffer,
  -- used especially for the codecompanion plugin
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },

  -- messenger.nvim for viewing commit messages
  {
    "lsig/messenger.nvim",
    event = "VeryLazy",
    opts = {
      border = "rounded",
    },
    keys = {
      { "<space>gm", "<cmd>MessengerShow<cr>", desc = "Git Messenger" },
    },
  },

}
