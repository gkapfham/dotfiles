-- File: plugins/filetree.lua
-- Purpose: load and configure the neo-tree plugin
-- and the oil.nvim plugin that also manages files

return {

  -- oil.nvim
  -- File system navigation and management
  -- (e.g., allows for file renaming and deletion)
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    config = function()
      require("oil").setup({
        default_file_explorer = true,
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
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

}
