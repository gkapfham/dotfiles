-- File: plugins/completion.lua
-- Purpose: Configure the nvim-cmp plugin
-- and all of the plugins that enhance it

-- Support functions implemented in lua {{{

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

-- }}}

return {

  -- Auto completion with nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Stand-alone cmp plugins
      "andersevenrud/cmp-tmux",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "octaltree/cmp-look",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "quangnguyen30192/cmp-nvim-tags",
      "ray-x/cmp-treesitter",
      "saadparwaiz1/cmp_luasnip",
      "jmbuhr/otter.nvim",
      "jc-doyle/cmp-pandoc-references",
      -- Fuzzy buffer plugin with dependencies
      {"romgrk/fzy-lua-native", build = "make"},
      "tzachar/cmp-fuzzy-buffer",
      "tzachar/fuzzy.nvim",
    },
    -- Configure the nvim-cmp plugin
    config = function()
      -- Configure standard completion for menus
      vim.cmd([[set completeopt=menu,menuone,noselect]])
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      -- Configure the dictionary plugin
      require('cmp').setup({
          sources = {
              {
                  name = 'look',
                  keyword_length = 2,
                  option = {
                      convert_case = true,
                      loud = true,
                      dict = '/usr/share/dict/american-english'
                  }
              }
          }
      })
      -- Configure all aspects of nvim-cmp
      cmp.setup({
        -- Do not preselect items
        preselect = cmp.PreselectMode.None,
        -- Define sorting order
        -- sorting = {
        --   comparators = {
        --     cmp.config.compare.kind,
        --     cmp.config.compare.order,
        --     cmp.config.compare.score,
        --     cmp.config.compare.recently_used,
        --     cmp.config.compare.length,
        --     cmp.config.compare.locality,
        --     cmp.config.compare.sort_text,
        --     cmp.config.compare.offset,
        --     cmp.config.compare.exact,
        --   },
        -- },
        -- Define the performance characteristics for nvim-cmp
        -- Favor the quick delivery of a minimal number of completions
        performance = {
          throttle = 0,
          fetching_timeout = 50,
          debounce = 10,
          -- trigger_debounce_time = 10,
          async_budget = 1,
          max_view_entries = 40
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
              cmdline_history = " Command",
              fuzzy_buffer = " Fuzzy",
              nvim_lsp = " LSP",
              nvim_lsp_document_symbol = " LSP",
              path = "פּ Path",
              otter = " Otter",
              pandoc_references = " Pandoc",
              rg = " Search",
              tags = "笠Tags",
              treesitter = " Tree",
              tmux = " Tmux",
              luasnip = " Snippet",
              look = " Spell",
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
          -- Define the same <Tab> mapping but also for
          -- <C-n> so that this also advances forward
          ["<C-n>"] = cmp.mapping(function(fallback)
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
          -- Define the same <S-Tab> mapping but also for
          -- <C-p> so that this also advances backward
          ["<C-p>"] = cmp.mapping(function(fallback)
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
          {name = 'treesitter', max_item_count = 5, priority = 10},
          {name = 'nvim_lsp', max_item_count = 10, priority = 10},
          -- Look at all of the open buffers
          {
            name = 'buffer', max_item_count = 10, priority = 20,
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          {name = 'fuzzy_buffer', max_item_count = 5, priority = 1},
          {name = 'tags', max_item_count = 5, priority = 5},
          {name = 'luasnip', max_item_count = 5, priority = 10},
          {name = 'otter', max_item_count = 5, priority = 5, keyword_length = 2},
          {name = 'pandoc_references', max_item_count = 5, priority = 5, keyword_length = 2},
          {name = 'tmux', max_item_count = 5, priority = 1, keyword_length = 2},
          {name = 'dictionary', max_item_count = 5, priority = 1, keyword_length = 3},
          {name = 'look', max_item_count = 5, priority = 1, keyword_length = 3},
          {name = 'nvim_lsp_signature_help'},
        }, {
            -- Define the second-tier of sources; these will only
            -- appear when there is no active source from the first-tier
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
          {name = 'buffer', max_item_count = 5, priority = 10},
          {name = 'fuzzy_buffer', max_item_count = 5, priority = 5},
        }, {
            {name = 'cmdline'},
          })
      })
      -- Use completion sources when backward-searching with "?"
      cmp.setup.cmdline('?', {
        -- Disable all of the prior settings for nvim-cmp
        -- (see previous note for full explanation)
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {name = 'path'},
          {name = 'buffer', max_item_count = 5},
          {name = 'fuzzy_buffer', max_item_count = 5, priority = 5},
        }, {
            {name = 'cmdline'},
          })
      })
      -- Use completion sources when running commands with ":"
      require'cmp'.setup.cmdline(':', {
        -- Disable all of the prior settings for nvim-cmp
        -- (see previous note for full explanation)
        mapping = cmp.mapping.preset.cmdline(),
        -- Use both the cmdline source (i.e., all valid
        -- commands) and the cmdline_history source (i.e.,
        -- all commands previously used in command prompt)
        sources = cmp.config.sources({
          {name = 'cmdline', max_item_count = 5},
          {name = 'cmdline_history', max_item_count = 5}
        }, {
        })
      })
    end,
  },

}
