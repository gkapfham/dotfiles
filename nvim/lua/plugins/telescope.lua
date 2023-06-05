-- File: plugins/telescope.lua
-- Purpose: load and configure the telescope plugin
-- and those plugins that enhance telescope

return {

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "benfowler/telescope-luasnip.nvim",
      "ThePrimeagen/refactoring.nvim",
      "debugloop/telescope-undo.nvim",
    },
    -- Configure
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--hidden',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<cr>"] = false,
            },
          },
          layout_config = {
            horizontal = {
              height = 0.8,
              width = 0.9
            }
          },
          path_display = {
            "absolute",
          },
          prompt_prefix = "> ",
          selection_caret = "> ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "closest",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          file_sorter =  require'telescope.sorters'.get_fuzzy_file,
          file_ignore_patterns = {},
          generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          color_devicons = false,
          use_less = true,
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
          file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
        },
        pickers = {
          buffers = {
            sort_lastused = true,
          }
        },
        extensions = {
          undo = {
            use_delta = false,
            side_by_side = false,
            use_custom_command = nil,
            diff_context_lines = vim.o.scrolloff,
            entry_format = "state #$ID, $STAT, $TIME",
            mappings = {
              i = {
                ["<cr>"] = require("telescope-undo.actions").yank_additions,
                ["<C-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<C-r>"] = require("telescope-undo.actions").restore,
              },
            },
          },
        },

      }
      -- Load the aerial extension; this provides navigation
      -- using tags, treesitter, and LSP. It is especially
      -- useful when Telescope does not correctly read tags
      -- for certain types of files like Markdown files
      require('telescope').load_extension('aerial')
      -- Load the luasnip extension for telescope
      require('telescope').load_extension('luasnip')
      -- Load and configure the refactoring telescope extension;
      -- note that refactoring requires section of code in visual mode
      require("telescope").load_extension("refactoring")
      require("telescope").load_extension("undo")
      -- Load and configure the notify plugin so that all
      -- notifications are viewable through telescope; note
      -- that this is now required because telescope is loaded
      -- in a lazy fashion and this plugin will not load
      -- unless done in an explicit fashion
      require("telescope").load_extension("notify")
      -- Configure the keymap for refactoring; setting it here because
      -- I do know how to set visual mode keymaps in keys section of spec
      vim.api.nvim_set_keymap(
        "v",
        "<space>rr",
        "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        { noremap = true }
      )
    end,
    -- Keys
    keys = {
      -- Aerial
      { "<Space>ta", "<cmd> Telescope aerial <CR>", desc = "Telescope: Aerial" },
      -- Buffers
      { "<Space>i", "<cmd> Telescope buffers <CR>", desc = "Telescope: Buffers" },
      { "<Space>tf", "<cmd> Telescope current_buffer_fuzzy_find <CR>", desc = "Telescope: Fuzzy search buffers" },
      -- Files
      { "<C-p>", "<cmd> Telescope find_files hidden=true <CR>", desc = "Telescope: Find files (Hidden)" },
      { "<Space>p", "<cmd> Telescope find_files hidden=true <CR>", desc = "Telescope: Find files (Hidden)" },
      { "<Space>o", "<cmd> Telescope find_files <CR>", desc = "Find Files" },
      -- Help
      { "<Space>th", "<cmd> Telescope help_tags <CR>", desc = "Telescope: Help tags" },
      -- History
      { "<Space>tc", "<cmd> Telescope command_history <CR>", desc = "Telescope: Command history" },
      -- Keymaps
      { "<Space>tk", "<cmd> Telescope keymaps <CR>", desc = "Telescope: Keymaps" },
      -- Languageserver
      { "<Space>gd", "<cmd> Telescope lsp_definitions <CR>", desc = "Telescope: Definitions" },
      { "<Space>gr", "<cmd> Telescope lsp_references <CR>", desc = "Telescope: References" },
      { "<Space>ds", "<cmd> Telescope lsp_document_symbols <CR>", desc = "Telescope: Document symbols" },
      { "<Space>ws", "<cmd> Telescope lsp_workspace_symbols <CR>", desc = "Telescope: Workspace symbols" },
      { "<Space>dd", "<cmd> Telescope diagnostics bufnr=0 <CR>", desc = "Telescope: Document diagnostics" },
      { "<Space>wd", "<cmd> Telescope diagnostics <CR>", desc = "Telescope: Workspace diagnostics" },
      -- Marks
      { "<Space>tm", "<cmd> Telescope marks <CR>", desc = "Telescope: Marks" },
      -- Notifications
      { "<Space>sn", "<cmd> Telescope notify <CR>", desc = "Telescope: Notifications" },
      -- Reloader
      { "<Space>rr", "<cmd> Telescope reloader <CR>", desc = "Telescope: Reloader" },
      -- Searching
      { "<Space>gs", "<cmd> Telescope grep_string <CR>", desc = "Telescope: Search for word under cursor" },
      { "<Leader>gs", "<cmd> Telescope grep_string <CR>", desc = "Telescope: Search for word under cursor" },
      { "<Space>ga", "<cmd> Telescope live_grep <CR>", desc = "Telescope: Search for input string" },
      -- Snippets
      { "<Space>ss", "<cmd> Telescope luasnip <CR>", desc = "Telescope: Luasnip" },
      -- Spelling
      { "<Space>tz", "<cmd> Telescope spell_suggest <CR>", desc = "Telescope: Spelling suggestion" },
      -- Tags
      { "<Space>tt", "<cmd> Telescope tags <CR>", desc = "Telescope: Tags" },
      { "<leader>tt", "<cmd> Telescope tags <CR>", desc = "Telescope: Tags" },
      { "<Space>tb", "<cmd> Telescope current_buffer_tags <CR>", desc = "Telescope: Buffer tags" },
      { "<leader>tb", "<cmd> Telescope tags <CR>", desc = "Telescope: Buffer tags" },
      -- Treesitter
      { "<Space>ts", "<cmd> Telescope treesitter <CR>", desc = "Telescope: Treesitter " },
      { "<leader>ts", "<cmd> Telescope treesitter <CR>", desc = "Telescope: Treesitter " },
    }
  }

}
