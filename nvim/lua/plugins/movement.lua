-- File: plugins/movement.lua
-- Purpose: load and configure movement plugins

return {

  -- -- Leap and flit
  -- {
  --   "ggandor/leap.nvim",
  --   event = "VeryLazy",
  --   dependencies = { {"ggandor/flit.nvim", config = {
  --     multiline = true,
  --     eager_ops = true,
  --     keymaps = { f = 'f', F = 'F', t = 't', T = 'T' }
  --   } } },
  --   config = function()
  --     require("leap").add_default_mappings(true)
  --   end,
  -- },

  -- Flash.nvim for improved search and movement
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- labels = "abcdefghijklmnopqrstuvwxyz",
      labels = "asdfghjklqwertyuiopzxcvbnm",
      label = {
        -- add a label for the first match in the current window.
        -- you can always jump to the first match with `<CR>`
        current = true,
        -- show the label after the match
        after = true, ---@type boolean|number[]
        -- show the label before the match
        before = false, ---@type boolean|number[]
        -- position of the label extmark
        style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
        -- flash tries to re-use labels that were already assigned to a position,
        -- when typing more characters. By default only lower-case labels are re-used.
        reuse = "lowercase", ---@type "lowercase" | "all"
      },
      search = {
        -- search/jump in all windows
        multi_window = true,
        -- search direction
        forward = true,
        -- when `false`, find only matches in the given direction
        wrap = true,
        ---@type Flash.Pattern.Mode
        -- Each mode will take ignorecase and smartcase into account.
        -- * exact: exact match
        -- * search: regular search
        -- * fuzzy: fuzzy search
        -- * fun(str): custom function that returns a pattern
        --   For example, to only match at the beginning of a word:
        --   mode = function(str)
        --     return "\\<" .. str
        --   end,
        mode = "search",
        -- behave like `incsearch`
        incremental = false,
        filetype_exclude = { "notify", "noice" },
      },
      jump = {
        -- save location in the jumplist
        jumplist = true,
        -- jump position
        pos = "start", ---@type "start" | "end" | "range"
        -- add pattern to search history
        history = true,
        -- add pattern to search register
        register = true,
        -- clear highlight after jump
        nohlsearch = false,
        -- automatically jump when there is only one match
        autojump = false,
        continue = true,
      },
      highlight = {
        label = {
          -- add a label for the first match in the current window.
          -- you can always jump to the first match with `<CR>`
          current = true,
          -- show the label after the match
          after = true, ---@type boolean|number[]
          -- show the label before the match
          before = false, ---@type boolean|number[]
          -- position of the label extmark
          style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
          -- flash tries to re-use labels that were already assigned to a position,
          -- when typing more characters. By default only lower-case labels are re-used.
          reuse = "lowercase", ---@type "lowercase" | "all"
        },
        -- show a backdrop with hl FlashBackdrop
        backdrop = false,
        -- Highlight the search matches
        matches = true,
        -- extmark priority
        priority = 5000,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
      -- action to perform when picking a label.
      -- defaults to the jumping logic depending on the mode.
      ---@type fun(match:Flash.Match, state:Flash.State)|nil
      action = nil,
      -- initial pattern to use when opening flash
      pattern = "",
      -- You can override the default options for a specific mode.
      -- Use it with `require("flash").jump({mode = "forward"})`
      ---@type table<string, Flash.Config>
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          enabled = true, -- enable flash for search
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            -- `forward` will be automatically set to the search direction
            -- `mode` is always set to `search`
            -- `incremental` is set to `true` when `incsearch` is enabled
          },
        },
        -- options used when flash is activated through
        -- `f`, `F`, `t`, `T`, `;` and `,` motions
        char = {
          enabled = true,
          search = { wrap = false },
          highlight = { backdrop = false },
          jump = { register = false },
        },
        -- options used for treesitter selections
        -- `require("flash").treesitter()`
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
          jump = { pos = "range" },
          highlight = {
            label = { before = true, after = true, style = "inline" },
            backdrop = false,
            matches = true,
          },
        },
      },
      -- disable the prompt when using a flash key like 's'
      prompt = {
        enabled = false,
      },
    },
    -- currently not configuring treesitter mode as I don't
    -- understand how it works or how to use it
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
      },
    },
  },

  -- Display diagnostic information about different keymaps,
  -- including information about the clipboard and spelling
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      triggers = {"z"},
      triggers_nowait = {
        -- spelling
        "z=",
      },
    }
  },

  -- Bracketed
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    config = function()
      require("mini.bracketed").setup({
        buffer     = { suffix = 'b', options = {} },
        comment    = { suffix = 'e', options = {} },
        conflict   = { suffix = 'x', options = {} },
        diagnostic = { suffix = 'd', options = {} },
        file       = { suffix = 'f', options = {} },
        indent     = { suffix = 'i', options = {} },
        jump       = { suffix = 'j', options = {} },
        location   = { suffix = 'l', options = {} },
        oldfile    = { suffix = 'o', options = {} },
        quickfix   = { suffix = 'q', options = {} },
        treesitter = { suffix = 't', options = {} },
        undo       = { suffix = 'u', options = {} },
        window     = { suffix = 'w', options = {} },
        yank       = { suffix = 'y', options = {} },
      }
      )
    end,
  },

  -- Pair movement and highlighting
  -- (note could not get vim-matchup to work;
  -- it crashes when using % and gives errors
  -- suggesting a problem with treesitter integration)
  {
    "theHamsta/nvim-treesitter-pairs",
    event = "VeryLazy",
    config = function()
      require'nvim-treesitter.configs'.setup {
        pairs = {
          enable = true,
          disable = {},
          highlight_pair_events = {"CursorMoved"},
          highlight_self = false,
          goto_right_end = false,
          fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
          keymaps = {
            goto_partner = "<leader>%",
            delete_balanced = "X",
          },
          delete_balanced = {
            only_on_first_char = false,
            fallback_cmd_normal = nil,
            longest_partner = true,
          }
        }
      }
    end,
  },

  -- Marks
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = function()
      require'marks'.setup {
        default_mappings = false,
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 150,
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        -- define mappings that are different than the default
        mappings = {
          next = "]a",
          prev = "[a",
          -- Note that "delete" requires next
          -- that you give the actual mark;
          -- this means that "dma" would
          -- delete the mark called "a"
          delete = "dm",
          delete_line = "dm-",
          delete_buf = "dm<space>",
          preview = "m;",
        }
      }
    end,
  },

  -- Spider for improved word movement
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = true
      })
      vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({"n", "o", "x"}, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    end,
  },

}
