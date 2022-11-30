" Completion plugins: nvim-cmp and plugins for nvim-cmp and luasnip {{{

" Configure insertion mode completion
set completeopt=menuone,noselect

lua << EOF
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

-- Load the luasnip and nvim-cmp plugins
local luasnip = require("luasnip")
local cmp = require("cmp")

-- Load the cmp_dictionary source that will
-- offer dictionary words as completion sources;
-- note that I tried other plugins and this was
-- the only one that seemed fast enough while
-- also not making the completion menu not work well.
-- It uses the standard dictionary provided with Linux.
require("cmp_dictionary").setup({
    dic = {
        ["*"] = "/usr/share/dict/american-english",
    },
})

-- Setup nvim-cmp
local cmp = require'cmp'
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
    -- {name = 'fuzzy_buffer', max_item_count = 5, priority = 1, keyword_length=5},
    {name = 'omni', max_item_count = 5, priority = 1},
    {name = 'nvim_lsp_signature_help'},
  }, {
    -- Define the second-tier of sources; these will only
    -- appear when there is no active source from the first-tier
    -- {name = 'dictionary', max_item_count = 5, priority = 1, keyword_length = 4},
    {name = 'path'},
  })
})

-- Use completion sources when forward-searching with "/"
cmp.setup.cmdline('/', {
  -- Disable all of the prior settings for nvim-cmp
  -- so that completion supported by luasnip not triggered;
  -- note that if this extra line is not added then
  -- tab completion does not work for this mode
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    {name = 'path'},
    {name = 'buffer'},
    {name = 'fuzzy_buffer'},
  }, {
    {name = 'cmdline'}
  })
})

-- Use completion sources when backward-searching with "?"
cmp.setup.cmdline('?', {
  -- Disable all of the prior settings for nvim-cmp
  -- (see previous note for full explanation)
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    {name = 'path'},
    {name = 'buffer'},
    {name = 'fuzzy_buffer'},
  }, {
    {name = 'cmdline'}
  })
})

-- Use completion sources when running commands with ":"
require'cmp'.setup.cmdline(':', {
  -- Disable all of the prior settings for nvim-cmp
  -- (see previous note for full explanation)
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    {name = 'cmdline'}
  }
})

-- Re-load the luasnip plugin and then load
-- the modules needed to define simple snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Define snippets for email messages
ls.add_snippets("mail", {
    -- Signatures at the end of an email message
    s({trig = "tyakr", dscr = "Detailed Email Sign-Off"}, {
        t({"Thank You and Kind Regards,", "", "\tGreg"}),
    }),
    s({trig = "taakr", dscr = "Detailed Email Sign-Off"}, {
        t({"Thanks Again and Kind Regards,", "", "\tGreg"}),
    }),
    s({trig = "kr", dscr = "Kind Regards"}, {
        t({"Kind Regards,", "", "\tGreg"}),
    }),
    s({trig = "ty", dscr = "Thank You"}, {
        t({"Thank You,", "", "\tGreg"}),
    }),
    -- Greetings at the start of an email message
    s({trig = "hac", dscr = "Hello Again Colleagues"}, {
        t({"Hello Again Colleagues"}),
        t({",", "", ""}),
    }),
    s({trig = "hc", dscr = "Hello Colleagues"}, {
        t({"Hello Colleagues"}),
        t({",", "", ""}),
    }),
    s({trig = "h", dscr = "Hello"}, {
        t({"Hello "}),
        i(1, {"Name"}),
        t({",", "", ""}),
        }),
    s({trig = "ha", dscr = "Hello Again"}, {
          t({"Hello Again "}),
          i(1, {"Name"}),
          t({",", "", ""}),
          })
  },
  -- define the type of signatures in this table
  {key = "mail",}
)

-- Define snippets for email messages
ls.add_snippets("gitcommit", {
    -- Simplified versions of conventional commits
    s({trig = "break", dscr = "break: conventional commits"}, {
        t({"break: "}),
        i(1, {"Message"}),
        }),
    s({trig = "chore", dscr = "chore: conventional commits"}, {
        t({"chore: "}),
        i(1, {"Message"}),
        }),
    s({trig = "docs", dscr = "docs: conventional commits"}, {
        t({"docs: "}),
        i(1, {"Message"}),
        }),
    s({trig = "feat", dscr = "feat: conventional commits"}, {
        t({"feat: "}),
        i(1, {"Message"}),
        }),
    s({trig = "fix", dscr = "fix: conventional commits"}, {
        t({"fix: "}),
        i(1, {"Message"}),
        }),
    s({trig = "refactor", dscr = "refactor: conventional commits"}, {
        t({"refactor: "}),
        i(1, {"Message"}),
        }),
    s({trig = "style", dscr = "style: conventional commits"}, {
        t({"style: "}),
        i(1, {"Message"}),
        }),
    s({trig = "test", dscr = "test: conventional commits"}, {
        t({"test: "}),
        i(1, {"Message"}),
        }),
    s({trig = "try", dscr = "try: personalized conventional commits"}, {
        t({"try: "}),
        i(1, {"Message"}),
        }),
  },
  -- define the type of signatures in this table
  {key = "gitcommit",}
)

-- Load all of the VS Code snippets provided by friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()
EOF

" Disable completion
command! NoCompletion :lua require('cmp').setup.buffer { enabled = false }

" Enable completion
command! Completion :lua require('cmp').setup.buffer { enabled = true }

" }}}
