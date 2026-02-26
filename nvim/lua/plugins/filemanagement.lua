-- File: plugins/filetree.lua
-- Purpose: load and configure the oil.nvim plugin
-- that also manages files through a full buffer
-- (note that all other file trees are now managed
-- by the snacks.nvim plugin and aligned to the
-- right side of the screen using edge.nvim)

return {

  -- oil.nvim
  -- File system navigation and management
  -- (e.g., allows for file renaming and deletion)
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    config = function()
      require("oil").setup({
        -- keep oil configured but do not make it the default file explorer
        -- since we use a snacks-based floating explorer on `-`
        default_file_explorer = false,
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = false,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          timeout_ms = 1000,
          autosave_changes = false,
        },
        -- Constrain the cursor to the editable parts of the oil buffer
        -- Set to `false` to disable, or "name" to keep it on the file names
        constrain_cursor = "name",
        experimental_watch_for_changes = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        keymaps_help = {
          border = "rounded",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = true,
          ---@diagnostic disable-next-line: unused-local
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          ---@diagnostic disable-next-line: unused-local
          is_always_hidden = function(name, bufnr)
            return false
          end,
          sort = {
            { "type", "asc" },
            { "name", "asc" },
          },
        },
        float = {
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          override = function(conf)
            return conf
          end,
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          update_on_cursor_moved = true,
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
        ssh = {
          border = "rounded",
        },
      })
      -- open snacks file explorer in a floating window when pressing '-'
      vim.keymap.set("n", "-", function()
        local ok, Snacks = pcall(require, "snacks")
        if not ok or not Snacks or not Snacks.picker or not Snacks.picker.explorer then
          -- fallback to oil if snacks isn't available
          vim.cmd("Oil")
          return
        end
        -- request a centered floating picker with rounded border
        -- set a custom filetype so edgy.nvim (which matches ft 'snacks_layout_box')
        -- does not capture this picker into the right sidebar
        -- set a sentinel so edgy won't capture the transient layout box
        vim.g.__snacks_ignore_layout_box = true
        Snacks.picker.explorer({
          -- force a floating layout (use the `select` preset which is floaty)
          layout = { preset = "select" },
          position = "float",
          border = "rounded",
          width = 0.6,
          height = 0.6,
          backdrop = false,
          zindex = 50,
          ft = "snacks_float_explorer",
          scratch_ft = "snacks_float_explorer",
        })
      end, { desc = "Open Snacks floating File Explorer" })
    end,
  },
}
