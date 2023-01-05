-- File: telescope.lua
-- Purpose: load and configure the telescope plugin
-- and those plugins that enhance telescope

return {

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
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
	    fzf = {
	      fuzzy = true,
	      override_generic_sorter = true,
	      override_file_sorter = true,
	      case_mode = "smart_case",
	    }
	  }
	}
    end,
    keys = {
      -- Buffers
      { "<Space>i", "<cmd> Telescope buffers <CR>", desc = "Telescope: Buffers" },
      { "<Space>rf", "<cmd> Telescope current_buffer_fuzzy_find <CR>", desc = "Telescope: Buffers" },
      -- Files 
      { "<C-p>", "<cmd> Telescope find_files hidden=true <CR>", desc = "Telescope: Find Files (Hidden)" },
      { "<Space>p", "<cmd> Telescope find_files hidden=true <CR>", desc = "Telescope: Find Files (Hidden)" },
      { "<Space>o", "<cmd> Telescope find_files <CR>", desc = "Find Files" },
      -- Keymaps
      { "<Space>k", "<cmd> Telescope keymaps <CR>", desc = "Telescope: Keymaps" },
      -- Marks 
      { "<Space>m", "<cmd> Telescope marks <CR>", desc = "Telescope: Marks" },
      -- Reloader
      { "<Space>rr", "<cmd> Telescope reloader <CR>", desc = "Telescope: Reloader" },
      -- Searching
      { "<Space>gs", "<cmd> Telescope grep_string <CR>", desc = "Telescope: Search for word under cursor" },
      { "<Leader>gs", "<cmd> Telescope grep_string <CR>", desc = "Telescope: Search for word under cursor" },
      { "<Space>ga", "<cmd> Telescope live_grep <CR>", desc = "Telescope: Search for input string" },
      { "<Leader>ga", "<cmd> Rg <CR>", desc = "Ripgrep: Search for input string" },
    } 
  }	

}
