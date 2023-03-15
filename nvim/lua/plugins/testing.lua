-- File: plugins/testing.lua
-- Purpose: load and configure testing plugins

return {

  -- Neotest
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
    end,
  },

}
