-- File: plugins/autopairs.lua
-- Purpose: Configure the autopairs plugin

return {

  -- nvim-ts-autotag
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

}
