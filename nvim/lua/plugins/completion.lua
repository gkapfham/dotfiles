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

-- Define symbols for the icons used by nvim-cmp
-- These symbols will appear on the right-hand side
-- of the actual completion suggested by nvim-cmp
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

-- Define the has_words_before function used in the
-- integration between luasnip and nvim-cmp; note
-- that this function must exist for other code in
-- this file to work correctly
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {

  -- Snippet definition and insertion with luasnip
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    config = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- Auto completion with nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
	cmp.setup({
	  -- Define the performance characteristics for nvim-cmp
	  performance = {
	    throttle = 2,
	    trigger_debounce_time = 50
	  },
	  -- Specify a snippet engine
	  snippet = {
	    expand = function(args)
	      require'luasnip'.lsp_expand(args.body)
	    end
	  },
	  -- Use the custom view packaged by nvim-cmp
	  view = {
	    entries = "custom"
	  },
	  -- Configure the formatting of the completion menu
	  formatting = {
	      format = function(entry, vim_item)
		-- Define the icons used for the completion labels
		vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
		-- Define labels for the completion menu;
		-- these will appear to the right of a completion
		-- suggestion in the nvim-cmp menu
		vim_item.menu = ({
		  buffer = " Buffer",
		  cmdline = " Command",
		  fuzzy_buffer = " Fuzzy",
		  nvim_lsp = " LSP",
		  -- Customize the label to include contextual details (e.g., bibtex entry or reference details)
		  omni = generate_omni_label(entry, vim_item),
		  path = "פּ Path",
		  rg = " Search",
		  tags = "笠Tags",
		  treesitter = " Tree",
		  luasnip = " Snippet",
		  dictionary = " Spell",
		})[entry.source.name]
		return vim_item
	      end
	    },
	  -- Define mappings for the keyboard commands when using completion menu
	  mapping = {
	    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
	    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
	    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
	    ['<C-y>'] = cmp.config.disable,
	    ['<C-e>'] = cmp.mapping({
	      i = cmp.mapping.abort(),
	      c = cmp.mapping.close(),
	    }),
	    ['<CR>'] = cmp.mapping.confirm({ select = false }),
	    -- Define mappings for using snippets; note that luasnip
	    -- works even when you have left the context of the snippet.
	    -- This means that you can jump back into the snippet by
	    -- using <S-Tab> even after going through every field.
	    -- Go forward in the template holes for the snippet
	    ["<Tab>"] = cmp.mapping(function(fallback)
	      if cmp.visible() then
		cmp.select_next_item()
	      elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	      elseif has_words_before() then
		cmp.complete()
	      else
		fallback()
	      end
	    end, { "i", "s" }),
	    -- Go back in the template holes in the snippet
	    ["<S-Tab>"] = cmp.mapping(function(fallback)
	      if cmp.visible() then
		cmp.select_prev_item()
	      elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	      else
		fallback()
	      end
	    end, { "i", "s" }),
	  },
	  -- Define the sources for the completions;
	  -- note that sources that appear earlier in the
	  -- list have higher priority. Also note that sources
	  -- with a higher priority have higher weighting on priority.
	  sources = cmp.config.sources({
	    -- Define the first-tier of sources
	    {name = 'luasnip', max_item_count = 5, priority = 10},
	    {name = 'treesitter', max_item_count = 5, priority = 10},
	    {name = 'nvim_lsp', max_item_count = 10, priority = 10},
	    {
	      name = 'buffer', max_item_count = 10, priority = 20,
		option = {
		  get_bufnrs = function()
		    local bufs = {}
		    for _, win in ipairs(vim.api.nvim_list_wins()) do
		      bufs[vim.api.nvim_win_get_buf(win)] = true
		    end
		    return vim.tbl_keys(bufs)
		  end
		},
	    },
	    {name = 'tags', max_item_count = 5, priority = 5},
	    {name = 'omni', max_item_count = 5, priority = 1},
	    {name = 'nvim_lsp_signature_help'},
	  }, {
	    -- Define the second-tier of sources; these will only
	    -- appear when there is no active source from the first-tier
	    -- {name = 'dictionary', max_item_count = 5, priority = 1, keyword_length = 4},
	    {name = 'path'},
	  })
	})


    end,
  },

}
