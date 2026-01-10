-- File: plugins/versioncontrol.lua
-- Purpose: load and configure all plugins that
-- integrate with the Git version control system

-- Update the diffview file tree
local is_git_ignored = function(filepath)
  vim.fn.system("git check-ignore -q " .. vim.fn.shellescape(filepath))
  return vim.v.shell_error == 0
end

-- Function to update the diffview file tree
local update_diffview_file_tree = function()
  pcall(function()
    local lib = require("diffview.lib")
    local view = lib.get_current_view()
    if view then
      -- This updates the left panel with all the files
      view:update_files()
    end
  end)
end

-- Register handler for file changes in watched directory
require("configure.directorywatcher").registerOnChangeHandler("diffview", function(filepath, events)
  local is_in_dot_git_dir = filepath:match("/%.git/") or filepath:match("^%.git/")

  if is_in_dot_git_dir or not is_git_ignored(filepath) then
    update_diffview_file_tree()
  end
end)

vim.api.nvim_create_autocmd("FocusGained", {
  callback = update_diffview_file_tree,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "DiffviewViewLeave",
  callback = function()
    vim.cmd(":DiffviewClose")
  end,
})

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

-- Delete empty [No Name] buffer when closing a tab
vim.api.nvim_create_autocmd("TabClosed", {
  group = vim.api.nvim_create_augroup("TabCleanUp", { clear = true }),
  callback = function()
    local buffers = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buffers) do
      if
        vim.api.nvim_buf_is_loaded(bufnr)
        and vim.api.nvim_buf_get_name(bufnr) == ""
        -- Important: check for empty buffer type to avoid issues with
        -- plugins like snacks or telescope which use scratch buffers for
        -- preview, for example. They usually set buftype to something like
        -- 'nofile' or 'prompt'.
        and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
      then
        local is_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
        if not is_modified then
          local is_empty = vim.api.nvim_buf_line_count(bufnr) == 1
            and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == ""
          -- Check that the empty buffer is not shown in any window and therefore can be deleted
          local windows = vim.fn.win_findbuf(bufnr)
          if is_empty and #windows == 0 then
            pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
          end
        end
      end
    end
  end,
})

return {

  -- vim-fugitive for git integration
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gwrite" },
    keys = {
      -- Keys: git status
      { "<Space>gg", ":call ToggleGstatus() <CR>", desc = "Fugitive: Git status toggle" },
      { "<leader>gg", ":call ToggleGstatus() <CR>", desc = "Fugitive: Git status toggle" },
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
    },
  },

  -- codediff.nvim for side-by-side code diffs
  -- that seems eaiser to use than diffview.nvim
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
    config = function()
      require("codediff").setup({
        highlights = {
          line_insert = "DiffAdd",
          line_delete = "DiffDelete",
          char_insert = nil,
          char_delete = nil,
          -- Brightness multiplier (only used when char_insert/char_delete are nil)
          -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
          char_brightness = nil, -- Auto-adjust based on your colorscheme
          -- nil = use default fallback chain
          -- Unresolved: DiagnosticSignWarn
          conflict_sign = nil,
          -- Resolved: Comment
          conflict_sign_resolved = nil,
          -- Accepted: GitSignsAdd -> DiagnosticSignOk
          conflict_sign_accepted = nil,
          -- Rejected: GitSignsDelete -> DiagnosticSignError
          conflict_sign_rejected = nil,
        },
        -- Diff view behavior
        diff = {
          disable_inlay_hints = true,
          max_computation_time_ms = 5000,
          hide_merge_artifacts = true,
        },
        -- Explorer panel configuration
        explorer = {
          position = "bottom",
          width = 40,
          height = 8,
          indent_markers = true,
          icons = {
            folder_closed = "",
            folder_open = "",
          },
          view_mode = "list",
          file_filter = {
            ignore = {},
          },
        },
        keymaps = {
          view = {
            quit = "q",
            toggle_explorer = "<leader>b",
            -- not needed because I use another plugin
            -- next_hunk = "]c", -- Jump to next change
            -- prev_hunk = "[c", -- Jump to previous change
            -- next_file = "]f", -- Next file in explorer mode
            -- prev_file = "[f", -- Previous file in explorer mode
            diff_get = "do",
            diff_put = "dp",
          },
          explorer = {
            select = "<CR>",
            hover = "K",
            refresh = "R",
            toggle_view_mode = "i",
          },
          -- Comments provide reminders about the meaning of
          -- the keymaps; helpful when resolving a merge conflict
          conflict = {
            accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
            accept_current = "<leader>co", -- Accept current (ours/right) change
            accept_both = "<leader>cb", -- Accept both changes (incoming first)
            discard = "<leader>cx", -- Discard both, keep base
            next_conflict = "]x", -- Jump to next conflict
            prev_conflict = "[x", -- Jump to previous conflict
            diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
            diffget_current = "3do", -- Get hunk from current (right/ours) buffer
          },
        },
      })
    end,
  },

  -- diffview.nvim for viewing diffs
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "DiffviewOpen", "DiffviewLog" },
    keys = {
      { "<Space>do", "<cmd>DiffviewOpen HEAD -- %<cr>", desc = "Open diffview for current file" },
    },
    config = function()
      require("diffview").setup({
        use_icons = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        watch_index = true, -- Update views when the git index changes
        view = {
          default = {
            layout = "diff2_vertical",
          },
        },
      })
    end,
  },

  -- git-conflict.nvim for resolving merge conflicts
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    tag = "v2.1.0",
    config = true,
  },

  -- gitsigns.nvim for showing git diffs in the sign column
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })
          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })
          -- Actions
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted)
          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
        -- Define the signs; note that the color scheme is
        -- now defined in the colorscheme file called
        -- colorscheme.lua in the same directory as this file
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
          topdelete = { text = "^" },
          changedelete = { text = "~" },
          untracked = { text = "?" },
        },
        signs_staged = {
          add = { text = "󰐖" },
          change = { text = "󰑕" },
          delete = { text = "󰍵" },
          topdelete = { text = "" },
          changedelete = { text = "󰦓" },
          untracked = { text = "" },
        },
        numhl = false,
        linehl = false,
        watch_gitdir = {
          follow_files = true,
          -- Check for git directory changes every 1 second
          interval = 1000,
        },
        preview_config = {
          border = "rounded",
        },
        attach_to_untracked = false,
        current_line_blame = false,
        sign_priority = 1,
        -- Reduce debounce for faster updates
        update_debounce = 100,
        status_formatter = nil,
      })
      -- Safely refresh gitsigns to reload display from git status
      local function force_gitsigns_refresh()
        pcall(function()
          local gitsigns = require("gitsigns")
          -- Only refresh - this is read-only and safe
          gitsigns.refresh()
        end)
      end
      -- Create an autocommand group for gitsigns refresh events
      local refresh_group = vim.api.nvim_create_augroup("GitSignsRefresh", { clear = true })
      -- When commit message buffer is closed, the commit is complete
      vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload" }, {
        group = refresh_group,
        pattern = { "COMMIT_EDITMSG", "*COMMIT_EDITMSG", "*/COMMIT_EDITMSG" },
        callback = function()
          -- Use multiple delayed refreshes to ensure we catch the commit
          -- The commit might take a moment to write to .git/index
          vim.defer_fn(force_gitsigns_refresh, 100)
          vim.defer_fn(force_gitsigns_refresh, 300)
          vim.defer_fn(force_gitsigns_refresh, 600)
        end,
      })
      -- After any shell command completes (catches :!git, :Git, etc.)
      vim.api.nvim_create_autocmd("ShellCmdPost", {
        group = refresh_group,
        callback = function()
          vim.defer_fn(force_gitsigns_refresh, 200)
        end,
      })
      -- When focus returns to neovim (for external git commands)
      vim.api.nvim_create_autocmd("FocusGained", {
        group = refresh_group,
        callback = function()
          vim.defer_fn(force_gitsigns_refresh, 100)
        end,
      })
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
