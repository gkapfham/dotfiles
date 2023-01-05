-- Define a function that makes a label for omnicompletion
local function generate_omni_label(entry, vim_item)
  -- Extract the contents in the vim_item menu
  label = vim.inspect(vim_item.menu)
  -- Determine if the label is "nil"; importantly,
  -- note that it is not the actual value of nil
  -- but rather a string that contains "nil".
  -- In this case, only return the basic label
  if label == "nil" then
    return " Omni"
  -- The label is not "nil" and thus the entire contents
  -- of the label need to appear; this is especially helpful
  -- when display details from the vimtex plugin.
  else
    return " Omni " .. label:gsub("%'", ""):gsub('%"', "")
  end
end

return {

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        completion = {
          completeopt = "menuone,noselect",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("settings").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
      })
    end,
  },

}
