-- File: plugins/autopairs.lua
-- Purpose: Configure the autopairs plugin

return {

  -- -- ultimate-autopairs.nvim
  -- {
  --   'altermo/ultimate-autopair.nvim',
  --   event={'InsertEnter','CmdlineEnter'},
  --   opts={
  --   },
  -- },

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
