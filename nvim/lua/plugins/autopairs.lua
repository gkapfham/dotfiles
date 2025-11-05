-- File: plugins/autopairs.lua
-- Purpose: Configure the autopairs plugin

return {

  -- nvim-autopairs: automatically insert closing pairs
  -- with some disabling of certain filetypes
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      local getRule = require("nvim-autopairs").get_rules
      require('nvim-autopairs').setup({
        check_ts = true,
        enable_check_bracket_line = false,
        map_c_h = true,
        map_c_w = true,
      })
      -- do not perform autopair matching when dealing with
      -- certain types of surrounding symbols that often need
      -- to have three of them displayed (e.g., backtick in markdown)
      getRule("`")[1].not_filetypes = { "markdown", "quarto", "tex" }
      getRule("'")[1].not_filetypes = { "tex" }
    end
  },

  -- nvim-ts-autotag: automatically generate tags
  -- for html/xml paired tags, like <div></div>
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

}
