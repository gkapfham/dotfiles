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
          -- Check that the empty buffer is not shown in any window
          -- and therefore can be deleted
          local windows = vim.fn.win_findbuf(bufnr)
          if is_empty and #windows == 0 then
            pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
          end
        end
      end
    end
  end,
})

-- Comment input buffer keymaps for the code review plugin
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeReviewInputEnter",
  -- Confirm that the code review plugin was loaded
  callback = function(ev)
    local buf = ev.data.buf
    local cr = require("code-review")
    local funcs = cr.get_input_buffer_functions(buf)
    -- Submit with C-CR in both insert and normal mode
    -- (do not use the default of CTRL-<CR> is this is
    -- used by ghostty to go into full screen mode)
    vim.keymap.set({ "i", "n" }, "<CR>", funcs.submit, { buffer = buf })
    -- Cancel with Esc or q in normal mode
    vim.keymap.set("n", "<Esc>", funcs.cancel, { buffer = buf })
    vim.keymap.set("n", "q", funcs.cancel, { buffer = buf })
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

  -- git-conflict.nvim for resolving merge conflicts
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    -- tag = "v2.1.0",
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
          -- Staged hunk navigation
          map("n", "]h", function()
            gs.nav_hunk("next", { target = "staged" })
          end)
          map("n", "[h", function()
            gs.nav_hunk("prev", { target = "staged" })
          end)
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
          add = { text = "" },
          change = { text = "󰜥" },
          delete = { text = "-" },
          topdelete = { text = "" },
          changedelete = { text = "󰦒" },
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
          -- Check for git directory changes every 500ms for faster detection
          interval = 500,
        },
        preview_config = {
          border = "rounded",
        },
        attach_to_untracked = false,
        current_line_blame = false,
        -- Higher priority ensures gitsigns are visible above other signs
        -- Default is 6; setting to 10 ensures it's above diagnostics and other plugins
        sign_priority = 10,
        -- Minimal debounce for near-instant updates after file changes
        update_debounce = 50,
        status_formatter = nil,
        -- Always refresh staged state on every update for faster response to commits
        -- Default is false; enabling ensures signs update immediately after staging/committing
        _refresh_staged_on_update = true,
      })
      -- Comprehensive refresh strategy to ensure signs always update correctly
      local function force_gitsigns_refresh_all_buffers()
        vim.schedule(function()
          pcall(function()
            local gitsigns = require("gitsigns")
            -- Refresh all attached buffers, not just current
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
                gitsigns.refresh()
              end
            end
          end)
        end)
      end
      -- Targeted refresh for current buffer only (faster)
      local function force_gitsigns_refresh_current()
        vim.schedule(function()
          pcall(function()
            require("gitsigns").refresh()
          end)
        end)
      end
      -- Create an autocommand group for gitsigns refresh events
      local refresh_group = vim.api.nvim_create_augroup("GitSignsRefresh", { clear = true })
      -- Critical: Refresh immediately after writing any file to disk
      -- This ensures signs update when you save files that were just staged/committed
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = refresh_group,
        callback = function()
          -- Immediate refresh plus a delayed one to catch async git operations
          force_gitsigns_refresh_current()
          vim.defer_fn(force_gitsigns_refresh_current, 100)
        end,
      })
      -- When commit message buffer is closed, the commit is complete
      vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload" }, {
        group = refresh_group,
        pattern = { "COMMIT_EDITMSG", "*COMMIT_EDITMSG", "*/COMMIT_EDITMSG" },
        callback = function()
          -- After commit completes, refresh all buffers since multiple files may be affected
          -- Use staggered refreshes to ensure we catch the git state changes
          vim.defer_fn(force_gitsigns_refresh_all_buffers, 50)
          vim.defer_fn(force_gitsigns_refresh_all_buffers, 200)
          vim.defer_fn(force_gitsigns_refresh_all_buffers, 500)
        end,
      })
      -- After any shell command completes (catches :!git, :Git, etc.)
      vim.api.nvim_create_autocmd("ShellCmdPost", {
        group = refresh_group,
        callback = function()
          -- Shell commands may affect multiple files, refresh all
          vim.defer_fn(force_gitsigns_refresh_all_buffers, 100)
          vim.defer_fn(force_gitsigns_refresh_all_buffers, 300)
        end,
      })
      -- When focus returns to neovim (for external git commands)
      vim.api.nvim_create_autocmd("FocusGained", {
        group = refresh_group,
        callback = function()
          -- External commands may have changed multiple files
          force_gitsigns_refresh_all_buffers()
          vim.defer_fn(force_gitsigns_refresh_all_buffers, 200)
        end,
      })
      -- When entering a buffer, refresh to ensure signs are current
      vim.api.nvim_create_autocmd("BufEnter", {
        group = refresh_group,
        callback = function()
          -- Only refresh if it's a normal file buffer
          if vim.bo.buftype == "" then
            force_gitsigns_refresh_current()
          end
        end,
      })
      -- User command for manual refresh when needed
      vim.api.nvim_create_user_command("GitSignsRefresh", function()
        force_gitsigns_refresh_all_buffers()
        vim.notify("GitSigns refreshed", vim.log.levels.INFO)
      end, { desc = "Manually refresh GitSigns for all buffers" })
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
