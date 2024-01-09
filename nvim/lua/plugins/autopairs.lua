-- File: plugins/autopairs.lua
-- Purpose: Configure the autopairs plugin

return {

  -- nvim-autpairs: automatically create pairs
  -- configuration ensures that when you have
  -- variable = |value
  -- and you press ( it does not add ()
  -- (note that | represents the cursor)
  {
    'windwp/nvim-autopairs',
    event={'InsertEnter','CmdlineEnter'},
    config=function()
      require('nvim-autopairs').setup({
        ignored_next_char = "[%w%.]"
      })
    end,
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
