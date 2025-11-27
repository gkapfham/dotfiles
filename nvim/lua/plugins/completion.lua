-- File: plugins/completion.lua
-- Purpose: Configure the nvim-cmp plugin
-- and all of the plugins that enhance it

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
  gemini = "󱙨",
  codestral = "󱙨",
  Boolean = "",
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
  KeywordConditional = "󰌋",
  KeywordDirective = "󰌋",
  KeywordException = "󰌋",
  KeywordImport = "󰌋",
  KeywordOperator = "󰌋",
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
  None = "󰋶",
  Number = "󰆙",
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
  MarkupList = "",
  MarkupRawBlock = "󰒔",
  MarkupStrong = "",
  PunctuationSpecial = "",
  VariableMember = "󰫧",
}

-- Define the has_words_before function used in the
-- integration between luasnip and nvim-cmp; note
-- that this function must exist for other code in
-- this file to work correctly
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  -- local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- local line, col = (table.unpack or unpack)(vim.api.nvim_win_get_cursor(0))
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line, col = cursor[1], cursor[2]
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

-- }}}

return {

  -- yanky.nvim
  -- Use the yanky plugin for clipboard management
  -- including highlighting, text objects, integration
  -- with the completion engine, and telescope integration
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    config = function()
      require("yanky").setup({
        ring = {
          history_length = 100,
          storage = "shada",
          storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db",
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
      vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
    end,
  },

  -- -- supermaven-nvim
  -- -- Use the Supermaven completion engine;
  -- -- note that it provides built-int support
  -- -- for nvim-cmp and thus it is easy to integrate
  -- -- into this setup. Using free tier for now.
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   event = "InsertEnter",
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       -- Disable the default keymaps and settings
  --       -- that would normally make virtual text appear;
  --       -- not using those since Supermaven integrates
  --       -- with nvim-cmp and that is primary approach
  --       disable_inline_completion = true,
  --       disable_keymaps = true
  --     })
  --   end,
  -- },

  -- minuet-ai.nvim
  -- Enable interaction with code completion
  -- models like Codestral and Gemini
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    config = function()
      require("minuet").setup({
        provider = "codestral",
        provider_options = {
          codestral = {
            optional = {
              max_tokens = 256,
              -- stop = { '\n\n' },
            },
          },
        }
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
      -- Setup the plugin using a default configuration
      -- that will disable the use of the standard features
      -- of the copilot plugin because they are going to
      -- be used through the nvim-cmp completion system
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        -- Define the filetypes for which the copilot
        -- plugin will be enabled or disabled
        filetypes = {
          markdown = true,
          yaml = false,
          help = false,
          gitcommit = true,
          gitrebase = true,
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

  -- sidekick.nvim
  -- Use the sidekick plugin to provide
  -- a terminal interface to run CLI tools
  -- that provided coding agents
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      signs = {
        enabled = true,
        icon = " ",
      },
      cli = {
        win = {
          keys = {
            prompt = { "<Space>sp", "prompt", mode = "n", desc = "insert prompt or context" },
          },
          wo = {},
          bo = {},
          layout = "float",
          float = {
            height = 0.75,
            width = 0.8,
          },
        },
        mux = {
          backend = "zellij",
          enabled = true,
        },
        tools = {
          opencode = {
            cmd = { "npx", "opencode-ai@latest" },
          },
          amp = {
            cmd = { "amp" },
          },
          toad = {
            cmd = { "toad", "acp", "npx opencode-ai@latest acp", "--project-dir", "." },
          },
          priorcode = {
            cmd = { "npx", "opencode-ai@0.15.30" },
          }
        },
      },
      ui = {
        icons = {
          attached          = " ",
          started           = " ",
          installed         = " ",
          missing           = " ",
          external_attached = "󱫄 ",
          external_started  = "󱫁 ",
          terminal_attached = " ",
          terminal_started  = " ",
        }
      },
    },
    keys = {
      {
        "<Space>so",
        function() require("sidekick.cli").toggle({ filter = { installed = true } }) end,
        desc = "Sidekick: Toggle CLI",
      },
      {
        "<Space>ss",
        function() require("sidekick.cli").select({ filter = { installed = true } }) end,
        desc = "Sidekick: Select CLI",
      },
      {
        "<Space>st",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Sidekick: Send This Content to CLI",
      },
      {
        "<Space>sv",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Sidekick: Send Visual Selection to CLI",
      },
      {
        "<Space>sp",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick: Select Prompt for CLI",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
    },
  },

  -- render-markdown.nvim
  -- Better rendering of markdown files
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup({
        enabled = true,
        completions = { lsp = { enabled = true } },
        file_types = { 'codecompanion', 'markdown', 'quarto', },
        heading = {
          width = "block",
        },
        code = {
          enabled = true,
        },
      })
    end
  },

  -- codecompanion.nvim for chatting with
  -- LLMs through GitHub Copilot models
  {
    "olimorris/codecompanion.nvim",
    tag = "v17.33.0",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    config = function()
      require("codecompanion").setup({
        memory = {
          agents = {
            description = "Memory files for autonomous agents",
            files = {
              "AGENTS.md",
            },
          },
        },
        strategies = {
          chat = {
            adapter = "copilot",
            roles = {
              llm = function(adapter)
                return " CodeCompanion (" .. adapter.formatted_name .. ")"
              end,
              user = " Gregory Kapfhammer",
            },
            opts = {
              completion_provider = "cmp",
            }
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          }
        },
        display = {
          diff = {
            enabled = true,
            provider = "inline",
            provider_opts = {
              inline = {
                layout = "float",
                diff_signs = {
                  signs = {
                    text = "▌",
                    reject = "",
                    highlight_groups = {
                      addition = "DiagnosticOk",
                      deletion = "DiagnosticError",
                      modification = "DiagnosticWarn",
                    },
                  },
                  -- Super Diff options
                  icons = {
                    accepted = " ",
                    rejected = " ",
                  },
                  colors = {
                    accepted = "DiagnosticOk",
                    rejected = "DiagnosticError",
                  },
                },
                opts = {
                  context_lines = 5,
                  dim = 0,
                  full_width_removed = true,
                  show_keymap_hints = true,
                  show_removed = true,
                },
              },
            },
          },
          chat = {
            -- show the settings
            show_settings = false,
            -- change the default icons
            icons = {
              buffer_pin = " ",
              buffer_watch = "󰡫 ",
            },
            -- alter the sizing of the debug window
            debug_window = {
              ---@return number|fun(): number
              width = vim.o.columns - 5,
              ---@return number|fun(): number
              height = vim.o.lines - 2,
            },
            -- options to customize the UI of the chat buffer
            window = {
              layout = "float",
              position = nil,
              border = "rounded",
              height = 0.75,
              width = 0.8,
              relative = "editor",
              full_height = true,
              sticky = false,
              opts = {
                breakindent = true,
                cursorcolumn = false,
                cursorline = false,
                foldcolumn = "0",
                linebreak = true,
                list = false,
                numberwidth = 1,
                signcolumn = "no",
                spell = false,
                wrap = true,
              },
            },
            -- customize how tokens are displayed
            token_count = function(tokens, adapter)
              return "󰣁 " .. tokens .. " tokens"
            end,
          },
        },
      })
    end,
    keys = {
      {
        "<Space>co",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "CodeCompanionChat: Toggle",
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
    -- "hrsh7th/nvim-cmp",
    "hrsh7th/nvim-cmp",
    -- url = "https://github.com/iguanacucumber/magazine.nvim",
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
      "tzachar/cmp-fuzzy-buffer",
      "tzachar/fuzzy.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    -- Configure the nvim-cmp plugin
    config = function()
      -- Configure standard completion for menus so that it supports
      -- completion for multiple tools and configurations
      vim.cmd([[set completeopt=menu,menuone,noselect,noinsert,popup]])
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      -- Configure the dictionary plugin
      -- Note: spell is disabled by default in spelling.lua
      -- and can be toggled on/off with <leader>ss as needed
      -- vim.opt.spell = true
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
          completion = cmp.config.window.bordered({ max_height = 100 }),
          documentation = cmp.config.window.bordered(),
        },
        -- Define the performance characteristics for nvim-cmp
        -- Favor the quick delivery of a minimal number of completions
        performance = {
          throttle = 0,
          fetching_timeout = 50,
          debounce = 10,
          async_budget = 1,
          filtering_context_budget = 1,
          confirm_resolve_timeout = 50,
          max_view_entries = 100
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
              otter = "󰌨 Otter",
              pandoc_references = " Pandoc",
              rg = " Filter",
              tags = " Tags",
              treesitter = " Tree",
              tmux = " Tmux",
              luasnip = " Snippet",
              look = " Spell",
              spell = " Spell",
              copilot = " Copilot",
              minuet = " Minuet",
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
          { name = 'treesitter', max_item_count = 10, priority = 10 },
          { name = 'nvim_lsp',   max_item_count = 10, priority = 10 },
          { name = 'copilot',    max_item_count = 10, priority = 10 },
          { name = 'minuet',     max_item_count = 10, priority = 10 },
          -- { name = 'supermaven', max_item_count = 10, priority = 8 },
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
          { name = 'fuzzy_buffer',      max_item_count = 5, priority = 6 },
          { name = 'cmp_yanky',         max_item_count = 5, priority = 6 },
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
          {
            name = 'path',
            option = {
              get_cwd = function()
                return vim.fn.getcwd()
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
          { name = 'buffer',       max_item_count = 15, priority = 10 },
          { name = 'fuzzy_buffer', max_item_count = 15, priority = 5 },
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
          { name = 'buffer',       max_item_count = 15, priority = 10 },
          { name = 'fuzzy_buffer', max_item_count = 15, priority = 5 },
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
          { name = 'cmdline', max_item_count = 25 },
        }, {
        })
      })
    end,
  },

}
