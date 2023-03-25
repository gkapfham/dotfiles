-- File: plugins/testing.lua
-- Purpose: load and configure testing plugins

return {

  -- Test
  {
    "nvim-neotest/neotest-python",
    dependencies = {
      "nvim-neotest/neotest",
    },
    event = "VeryLazy",
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")
        },
        quickfix = {
          enabled = true,
          open = true
        },
      })
      vim.cmd([[
        " au Filetype neotest-output-panel setlocal listchars+=tab:\ \
        command! TestSummary lua require("neotest").summary.toggle()
        command! TestFile lua require("neotest").run.run(vim.fn.expand("%"))
        command! Test lua require("neotest").run.run(vim.fn.getcwd())
        command! TestNearest lua require("neotest").run.run()
        command! TestDebug lua require("neotest").run.run({ strategy = "dap" })
        command! TestAttach lua require("neotest").run.attach()
        command! TestOutput lua require("neotest").output.toggle()
        command! TestRunner lua require("neotest").output_panel.toggle()
      ]])
    end,
  },

}
