-- File: plugins/movement.lua
-- Purpose: load and configure movement plugins

-- Specialized treesitter movement, note that this
-- assumes that treesitter is enabled and working {{{

-- movement
vim.keymap.set({ "n", "v" }, "<C-k>", "<cmd>Treewalker Up<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-j>", "<cmd>Treewalker Down<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-h>", "<cmd>Treewalker Left<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>Treewalker Right<cr>", { silent = true })

-- swapping
vim.keymap.set("n", "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true })
vim.keymap.set("n", "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true })
vim.keymap.set("n", "<C-S-h>", "<cmd>Treewalker SwapLeft<cr>", { silent = true })
vim.keymap.set("n", "<C-S-l>", "<cmd>Treewalker SwapRight<cr>", { silent = true })

-- }}}

return {

  -- flash.nvim
  -- movements based on marking letters through both motions and search
  -- supports textual content and treesitter nodes; do not use the
  -- provided search functionality because you can trigger one of
  -- the labels as you continue to search, causing problems
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      jump = {
        continue = false,
        history = true,
        register = true,
        nohlsearch = true,
      },
      label = {
        style = "eol",
      },
      highlight = {
        backdrop = false,
      },
      prompt = {
        enabled = false,
      },
      modes = {
        treesitter = {
          highlight = {
            backdrop = false,
          },
          label = { before = true, after = true, style = "eol" },
        },
        search = {
          enabled = false,
        },
        char = {
          highlight = {
            backdrop = false,
          },
          jump_labels = false,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<c-s>",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({ search = { mode = "fuzzy" } })
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- nvim-spider enhances the default word motions
  -- by supporting, for instance, subword movement
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = true,
        consistentOperatorPending = false,
        subwordMovement = true,
        customPatterns = {},
      })
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")
    end,
  },

  -- mini.bracketed
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    config = function()
      require("mini.bracketed").setup({
        buffer = { suffix = "b", options = {} },
        comment = { suffix = "e", options = {} },
        conflict = { suffix = "x", options = {} },
        -- this default now creates lua errors every
        -- time I try to use it; instead, making the
        -- mappings inside of this config function
        diagnostic = { suffix = "d", options = {} },
        file = { suffix = "f", options = {} },
        indent = { suffix = "i", options = {} },
        jump = { suffix = "j", options = {} },
        location = { suffix = "l", options = {} },
        oldfile = { suffix = "o", options = {} },
        quickfix = { suffix = "q", options = {} },
        -- treesitter = { suffix = "t", options = {} },
        undo = { suffix = "u", options = {} },
        window = { suffix = "w", options = {} },
        yank = { suffix = "y", options = {} },
      })
      -- redefine the mappings for diagnostics to avoid lua errors
      -- vim.keymap.set({ "n" }, "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
      -- vim.keymap.set({ "n" }, "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
    end,
  },

  {
    "aaronik/treewalker.nvim",
    event = "VeryLazy",
    -- optional (see options below)
    -- opts = { ... },
  },

  -- marks.nvim
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = function()
      require("marks").setup({
        default_mappings = false,
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 150,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        -- define mappings that are different than the default
        mappings = {
          next = "]a",
          prev = "[a",
          -- note that "delete" requires next
          -- that you give the actual mark;
          -- this means that "dma" would
          -- delete the mark called "a"
          delete = "dm",
          delete_line = "dm-",
          delete_buf = "dm<space>",
          preview = "m;",
        },
      })
    end,
  },
}
