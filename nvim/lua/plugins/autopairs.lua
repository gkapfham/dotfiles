-- File: plugins/autopairs.lua
-- Purpose: Configure the autopairs plugin

return {

  -- -- Mini.pairs
  -- {
  --   "echasnovski/mini.pairs",
  --   event="VeryLazy",
  --   config = function()
  --     require('mini.pairs').setup()
  --   end,
  -- },

  -- -- Autoclose for pairs
  -- {
  --   "m4xshen/autoclose.nvim",
  --   event="VeryLazy",
  --   config = function()
  --     local configinput = {
  --       keys = {
  --         ["("] = { escape = false, close = true, pair = "()", disabled_filetypes = {} },
  --         ["["] = { escape = false, close = true, pair = "[]", disabled_filetypes = {} },
  --         ["{"] = { escape = false, close = true, pair = "{}", disabled_filetypes = {} },
  --         [">"] = { escape = true, close = false, pair = "<>", disabled_filetypes = {} },
  --         [")"] = { escape = true, close = false, pair = "()", disabled_filetypes = {} },
  --         ["]"] = { escape = true, close = false, pair = "[]", disabled_filetypes = {} },
  --         ["}"] = { escape = true, close = false, pair = "{}", disabled_filetypes = {} },
  --         ['"'] = { escape = true, close = true, pair = '""', disabled_filetypes = {} },
  --         ["'"] = { escape = true, close = true, pair = "''", disabled_filetypes = {} },
  --         ["`"] = { escape = true, close = true, pair = "``", disabled_filetypes = {} },
  --       },
  --       options = {
  --         disabled_filetypes = { "text" },
  --         disable_when_touch = true,
  --         pair_spaces = false,
  --         auto_indent = true,
  --       },
  --     }
  --     require('autoclose').setup(configinput)
  --   end,
  -- },

  -- -- Autopairs
  -- {
  --   "windwp/nvim-autopairs",
  --   event="VeryLazy",
  --   config = function()
  --     local remap = vim.api.nvim_set_keymap
  --     local npairs = require('nvim-autopairs')
  --     npairs.setup({ map_bs = false, map_cr = false })
  --     vim.g.coq_settings = { keymap = { recommended = false } }
  --     -- Skip it, if you use another global object
  --     _G.MUtils= {}
  --     MUtils.CR = function()
  --       if vim.fn.pumvisible() ~= 0 then
  --         if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
  --           return npairs.esc('<c-y>')
  --         else
  --           return npairs.esc('<c-e>') .. npairs.autopairs_cr()
  --         end
  --       else
  --         return npairs.autopairs_cr()
  --       end
  --     end
  --     remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })
  --     MUtils.BS = function()
  --       if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
  --         return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  --       else
  --         return npairs.autopairs_bs()
  --       end
  --     end
  --     remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
  --     local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  --     local cmp = require('cmp')
  --     cmp.event:on(
  --       'confirm_done',
  --       cmp_autopairs.on_confirm_done()
  --     )
  --   end,
  -- },

  -- Autotag
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

}
