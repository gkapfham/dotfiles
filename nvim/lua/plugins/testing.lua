-- File: plugins/testing.lua
-- Purpose: load and configure testing plugins

return {

  -- ToggleTerm
  -- quick and customizable terminal window
  -- that can also be used for testing running
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        shade_terminals = false,
        direction = "float",
        float_opts = {
          width = 100,
          height = 20,
        }
      })
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
    keys = {
      { "<Space>tt","<cmd> ToggleTerm <CR>", desc = "Toggleterm: Toggle display" },
    },
  },

  -- nvim-test
  -- Run tests with nvim and display in toggleterm
  {
    "klen/nvim-test",
    event = "VeryLazy",
    config = function()
      require('nvim-test').setup({
        term = "toggleterm",
        termOpts = {
          direction = "float",
          -- height = 10,         -- terminal's height (for horizontal|float)
          go_back = false,     -- return focus to original window after executing
          -- stopinsert = "auto", -- exit from insert mode (true|false|"auto")
          keep_one = true,     -- keep only one terminal for testing
        },
      })
    end
  },

  -- -- Test
  -- {
  --   "nvim-neotest/neotest-python",
  --   dependencies = {
  --     "nvim-neotest/neotest",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   event = "VeryLazy",
  --   config = function()
  --     require("neotest").setup({
  --       adapters = {
  --         require("neotest-python")
  --       },
  --       quickfix = {
  --         enabled = true,
  --         open = true
  --       },
  --     })
  --     vim.cmd([[
  --       " au Filetype neotest-output-panel setlocal listchars+=tab:\ \
  --       command! TestSummary lua require("neotest").summary.toggle()
  --       command! TestFile lua require("neotest").run.run(vim.fn.expand("%"))
  --       command! Test lua require("neotest").run.run(vim.fn.getcwd())
  --       command! TestNearest lua require("neotest").run.run()
  --       command! TestDebug lua require("neotest").run.run({ strategy = "dap" })
  --       command! TestAttach lua require("neotest").run.attach()
  --       command! TestOutput lua require("neotest").output.toggle()
  --       command! TestRunner lua require("neotest").output_panel.toggle()
  --     ]])
  --   end,
  -- },

}
