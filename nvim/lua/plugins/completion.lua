-- File: plugins/completion.lua
-- Purpose: Configure the nvim-cmp plugin
-- and all of the plugins that enhance it

local prompts = {
  -- Code related prompts
  Explain = "Please explain how the following code works.",
  Review = "Please review the following code and provide suggestions for improvement.",
  Tests = "Please explain how the selected code works, then generate unit tests for it.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
  FixCode = "Please fix the following code to make it work as intended.",
  FixError = "Please explain the error in the following text and provide a solution.",
  BetterNamings = "Please provide better names for the following variables and functions.",
  Documentation = "Please provide documentation for the following code.",
  SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
  SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
  -- Text related prompts
  Summarize = "Please summarize the following text.",
  Spelling = "Please correct any grammar and spelling errors in the following text.",
  Wording = "Please improve the grammar and wording of the following text.",
  Concise = "Please rewrite the following text to make it more concise.",
}

-- Supporting variables and functions implemented in lua {{{

-- Define symbols for the icons used by nvim-cmp;
-- These symbols will appear on the right-hand side
-- of the actual completion suggested by nvim-cmp;
-- Note that these symbols are the second label from
-- the right that appears for each completion line;
-- If there is not a symbol defined for a particular
-- completion then the symbol will not appear at all
-- and there will instead be the display of nil
local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  KeywordDirective = "󰌋",
  KeywordImport = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "𝙏",
  Nospell = "",
  Spell = "",
  StringSpecialPath = "",
  StringSpecialSymbol = "󱔁",
  StringSpecialUrl = "󰌷",
  String = "",
  Copilot = "",
  Supermaven = "",
  Comment = "",
  Label = "󰜢",
  TextTitle1 = "",
  TextTitle2 = "",
  TextTitle3 = "",
  Tag = "󱈤",
  Tree = "",
  Treesitter = "",
  MarkupHeading = "",
  MarkupHeading1 = "",
  MarkupHeading2 = "",
  MarkupHeading3 = "",
  MarkupHeading4 = "",
  MarkupHeading5 = "",
  MarkupLink = "󰌷",
  MarkupRawBlock = "󰒔",
  MarkupStrong = "",
}

-- Define the has_words_before function used in the
-- integration between luasnip and nvim-cmp; note
-- that this function must exist for other code in
-- this file to work correctly

-- Old version of the function before using GitHub copilot
-- local has_words_before = function()
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

-- }}}

return {

  -- yanky.nvim for clipboard management
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    config = function()
      require("yanky").setup({
        ring = {
          history_length = 100,
          storage = "shada",
          storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
          sync_with_numbered_registers = true,
          cancel_event = "update",
          ignore_registers = { "_" },
          update_register_on_cycle = false,
        },
        picker = {
          select = {
            action = nil,
          },
          telescope = {
            use_default_mappings = true,
            mappings = nil,
          },
        },
        system_clipboard = {
          sync_with_ring = true,
          clipboard_register = nil,
        },
        highlight = {
          on_put = false,
          on_yank = true,
          timer = 100,
        },
        preserve_cursor_position = {
          enabled = true,
        },
        textobj = {
          enabled = true,
        },

      })
      vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)")
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
    end,
  },

  -- Supermaven-nvim
  -- Use the Supermaven completion engine;
  -- note that it provides built-int support
  -- for nvim-cmp and thus it is easy to integrate
  -- into this setup. Using free tier for now.
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        -- disable the default keymaps and settings
        -- that would normally make virtual text appear;
        -- not using those since Supermaven integrates
        -- with nvim-cmp and that is primary approach
        disable_inline_completion = true,
        disable_keymaps = true
      })
    end,
  },

  -- copilot.lua
  -- Use the GitHub copilot plugin
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      -- setup the plugin using a default configuration
      -- that will disable the use of the standard features
      -- of the copilot plugin because they are going to
      -- be used through the nvim-cmp completion system
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        -- define the filetypes for which the copilot
        -- plugin will be enabled or disabled
        filetypes = {
          markdown = true,
          yaml = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      })
      -- Set the filetype to markdown when entering the
      -- copilot-chat buffer; note that this is set correctly
      -- the first time but the plugin itself. However, later
      -- the syntax highlighting is removed and this makes
      -- it difficult to read the output from GitHub copilot.
      -- this fix ensures that highlighting is always enabled
      vim.cmd([[
         autocmd FileType copilot-chat set filetype=markdown
      ]])
    end,
  },

  -- copilot-cmp
  -- Integrate the copilot with nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
      vim.cmd([[
         autocmd BufEnter copilot-chat set filetype=markdown
      ]])
    end
  },

  -- CopilotChat.nvim
  -- Chat with GitHub copilot; note that
  -- while the user interface and experience
  -- is not yet polished this tool works well
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    version = "v2.1.0",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      prompts = prompts,
      show_help = "yes",
      debug = false,
      disable_extra_info = "no",
      language = "English",
      -- default window options
      window = {
        layout = 'float',    -- 'vertical', 'horizontal', 'float'
        -- Options below only apply to floating windows
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'single',   -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        width = 0.8,         -- fractional width of parent
        height = 0.6,        -- fractional height of parent
        row = nil,           -- row position of the window, default is centered
        col = nil,           -- column position of the window, default is centered
        title = 'Copilot',   -- title of chat window
        footer = nil,        -- footer of chat window
        zindex = 1,          -- determines if window is on top or below other floating windows
      },
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      -- Use unnamed register for the selection
      opts.selection = select.unnamed
      -- Override the git prompts message
      opts.prompts.Commit = {
        prompt = "Write commit message for the change with commitizen convention",
        selection = select.gitdiff,
      }
      opts.prompts.CommitStaged = {
        prompt = "Write commit message for the change with commitizen convention",
        selection = function(source)
          return select.gitdiff(source, true)
        end,
      }
      chat.setup(opts)
      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })
      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })
      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })
      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true
        end,
      })
    end,
    event = "VeryLazy",
    keys = {
      {
        "<Space>cco",
        "<cmd>CopilotChatOpen<cr>",
        desc = "CopilotChat: Open",
      },
      {
        "<Space>cct",
        "<cmd>CopilotChatToggle<cr>",
        desc = "CopilotChat: Toggle",
      },
      {
        "<Space>ccy",
        ":CopilotChat",
        desc = "CopilotChat: Open chat based on contents of register y",
      },
      {
        "<Space>cco",
        "<cmd>CopilotChatInline<cr>",
        desc = "CopilotChat: Open inline chat",
      },
      {
        "<Space>ccv",
        ":CopilotChatVisual",
        mode = "x",
        desc = "CopilotChat: Open chat based on visual highlight",
      },
      {
        "<Space>ccr",
        "<cmd>CopilotChatReset<cr>",
        desc = "CopilotChat: Reset chat history and clear buffer",
      },
    },
  },

  -- nvim-cmp
  -- Auto completion with nvim-cmp
  -- Note that you can cancel the
  -- current completion with <C-e>;
  -- this is useful when Copilot immediately
  -- makes a suggestion and this will
  -- prevent the use of <Tab> for indenting
  -- as it will be setup for accepting
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Stand-alone cmp plugins
      "andersevenrud/cmp-tmux",
      "chrisgrieser/cmp-nerdfont",
      "chrisgrieser/cmp_yanky",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "quangnguyen30192/cmp-nvim-tags",
      "ray-x/cmp-treesitter",
      "saadparwaiz1/cmp_luasnip",
      "jmbuhr/otter.nvim",
      "jc-doyle/cmp-pandoc-references",
      "zbirenbaum/copilot-cmp",
      -- Fuzzy buffer plugin with dependencies
      { "romgrk/fzy-lua-native", build = "make" },
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
      vim.opt.spell = true
      vim.opt.spelllang = { 'en_us' }
      -- Configure all aspects of nvim-cmp
      cmp.setup({
        -- Do not preselect items
        preselect = cmp.PreselectMode.None,
        -- Configure the completion menu that appears
        -- to show a preview of the documentation (i.e.,
        -- this is the color scheme for the menu that
        -- appears when you select a completion suggestion
        -- and it has additional context information).
        -- Note that this needs to be changed because the
        -- default color scheme uses NormalFloat with a
        -- background that works better for GitHub
        -- Copilot chat and that does not match PMenu.
        window = {
          documentation = {
            winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder',
          }
        },
        -- Define the performance characteristics for nvim-cmp
        -- Favor the quick delivery of a minimal number of completions
        performance = {
          throttle = 0,
          fetching_timeout = 50,
          debounce = 10,
          async_budget = 1,
          max_view_entries = 50
        },
        -- Specify a snippet engine
        snippet = {
          expand = function(args)
            require 'luasnip'.lsp_expand(args.body)
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
              buffer = " Buffer",
              cmdline = " Command",
              cmp_yanky = " Clipboard",
              fuzzy_buffer = "󰓐 Fuzzy",
              nvim_lsp = " LSP",
              nvim_lsp_document_symbol = " LSP",
              path = " Path",
              nerdfont = " Font",
              otter = " Otter",
              pandoc_references = " Pandoc",
              rg = " Search",
              tags = " Tags",
              treesitter = " Tree",
              tmux = " Tmux",
              luasnip = " Snippet",
              look = " Spell",
              spell = " Spell",
              copilot = " Copilot",
              supermaven = " Supermaven",
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
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            elseif cmp.visible() then
              -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          -- Define the same <Tab> mapping but also for
          -- <C-n> so that this also advances forward
          ["<C-n>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            elseif cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
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
          { name = 'treesitter',   max_item_count = 5,  priority = 10 },
          { name = 'nvim_lsp',     max_item_count = 10, priority = 10 },
          { name = 'copilot',      max_item_count = 5,  priority = 8 },
          { name = 'supermaven',   max_item_count = 5,  priority = 8 },
          -- Look at all of the open buffers
          {
            name = 'buffer',
            max_item_count = 10,
            priority = 20,
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          { name = 'cmp_yanky',         max_item_count = 5,  priority = 6 },
          { name = 'fuzzy_buffer',      max_item_count = 5,  priority = 6 },
          { name = 'tags',              max_item_count = 5, priority = 5 },
          { name = 'luasnip',           max_item_count = 5, priority = 5 },
          { name = 'otter',             max_item_count = 5, priority = 5, keyword_length = 2 },
          { name = 'pandoc_references', max_item_count = 5, priority = 5, keyword_length = 2 },
          { name = 'tmux',              max_item_count = 5, priority = 1, keyword_length = 2 },
          {
            name = 'spell',
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
            },
            max_item_count = 5,
            priority = 10,
            keyword_length = 3
          },
          { name = 'nerdfont',               max_item_count = 10, priority = 1, keyword_length = 3 },
          { name = 'nvim_lsp_signature_help' },
        }, {
          -- Define the second-tier of sources; these will only
          -- appear when there is no active source from the first-tier
          { name = 'path' },
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
          { name = 'path' },
          { name = 'buffer',       max_item_count = 5, priority = 10 },
          { name = 'fuzzy_buffer', max_item_count = 5, priority = 5 },
        }, {
          { name = 'cmdline' },
        })
      })
      -- Use completion sources when backward-searching with "?"
      cmp.setup.cmdline('?', {
        -- Disable all of the prior settings for nvim-cmp
        -- (see previous note for full explanation)
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'buffer',       max_item_count = 5, priority = 10 },
          { name = 'fuzzy_buffer', max_item_count = 5, priority = 5 },
        }, {
          { name = 'cmdline' },
        })
      })
      -- Use completion sources when running commands with ":"
      require 'cmp'.setup.cmdline(':', {
        -- Disable all of the prior settings for nvim-cmp
        -- (see previous note for full explanation)
        mapping = cmp.mapping.preset.cmdline(),
        -- Use the cmdline source (i.e., all valid
        -- commands); disable the cmdline_history source (i.e.,
        -- all commands previously used in command prompt)
        -- because it might break the tab completion
        sources = cmp.config.sources({
          { name = 'cmdline', max_item_count = 10 },
        }, {
        })
      })
    end,
  },

}

-- old completion settings:

-- ["<Tab>"] = cmp.mapping(function(fallback)
--   if cmp.visible() then
--     cmp.select_next_item()
--   elseif luasnip.expand_or_jumpable() then
--     luasnip.expand_or_jump()
--   elseif has_words_before() then
--     cmp.complete()
--   else
--     fallback()
--   end
-- end, { "i", "s" }),

-- ["<C-n>"] = cmp.mapping(function(fallback)
--   if cmp.visible() then
--     cmp.select_next_item()
--   elseif luasnip.expand_or_jumpable() then
--     luasnip.expand_or_jump()
--   elseif has_words_before() then
--     cmp.complete()
--   else
--     fallback()
--   end
-- end, { "i", "s" }),
