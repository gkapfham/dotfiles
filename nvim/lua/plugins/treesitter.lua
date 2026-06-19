-- File: plugins/treesitter.lua
-- Purpose: load and configure Tree-sitter
-- for highlighting, indentation, and text objects

local parsers = {
  "bash",
  "bibtex",
  "c",
  "comment",
  "css",
  "csv",
  "diff",
  "gitattributes",
  "git_config",
  "gitcommit",
  "gitignore",
  "go",
  "html",
  "java",
  "javascript",
  "json",
  "json5",
  "latex",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "mermaid",
  "nix",
  "python",
  "query",
  "regex",
  "rust",
  "scss",
  "svelte",
  "tmux",
  "toml",
  "tsx",
  "typescript",
  "typst",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
  "zsh",
}

local function select_textobject(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end

local function treesitter_cli_supported()
  if vim.fn.executable("tree-sitter") == 0 then
    return false
  end
  local version = vim.trim(vim.fn.system({ "tree-sitter", "--version" }))
  local major, minor, patch = version:match("(%d+)%.(%d+)%.(%d+)")
  if not major then
    return false
  end
  major, minor, patch = tonumber(major), tonumber(minor), tonumber(patch)
  if major > 0 then
    return true
  end
  if minor > 26 then
    return true
  end
  return minor == 26 and patch >= 1
end

-- incremental selection treesitter/lsp
vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

return {

  -- nvim-treesitter
  -- Tree-sitter queries and parser management
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local treesitter = require("nvim-treesitter")
      if treesitter_cli_supported() then
        local installed = treesitter.get_installed()
        local missing = vim.tbl_filter(function(parser)
          return not vim.list_contains(installed, parser)
        end, parsers)
        if #missing > 0 then
          treesitter.install(missing)
        end
      else
        vim.notify_once(
          "Tree-sitter parser installation skipped: tree-sitter CLI 0.26.1+ is required for nvim-treesitter on Neovim 0.12.",
          vim.log.levels.WARN
        )
      end
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" or vim.bo[args.buf].filetype == "toml" then
            return
          end
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
      -- make sure that quarto files use the markdown
      -- parser for treesitter (there is no parser for quarto);
      -- note that this is important to set because, without
      -- it, the preview feature in Snacks.nvim's pickers for
      -- .qmd files will not display syntax highlighting correctly
      vim.treesitter.language.register("markdown", "quarto")
    end,
  },

  -- nvim-treesitter-textobjects
  -- Text objects backed by Tree-sitter queries
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          include_surrounding_whitespace = false,
        },
      })
    end,
    keys = {
      { "ab", select_textobject("@block.outer"), mode = { "v", "x", "o" }, desc = "Tree-sitter: block outer" },
      { "ib", select_textobject("@block.inner"), mode = { "v", "x", "o" }, desc = "Tree-sitter: block inner" },
      { "af", select_textobject("@function.outer"), mode = { "v", "x", "o" }, desc = "Tree-sitter: function outer" },
      { "if", select_textobject("@function.inner"), mode = { "v", "x", "o" }, desc = "Tree-sitter: function inner" },
      {
        "ac",
        select_textobject("@conditional.outer"),
        mode = { "v", "x", "o" },
        desc = "Tree-sitter: conditional outer",
      },
      {
        "ic",
        select_textobject("@conditional.inner"),
        mode = { "v", "x", "o" },
        desc = "Tree-sitter: conditional inner",
      },
      { "am", select_textobject("@comment.outer"), mode = { "v", "x", "o" }, desc = "Tree-sitter: comment outer" },
      { "im", select_textobject("@comment.inner"), mode = { "v", "x", "o" }, desc = "Tree-sitter: comment inner" },
      { "al", select_textobject("@loop.outer"), mode = { "v", "x", "o" }, desc = "Tree-sitter: loop outer" },
      { "il", select_textobject("@loop.inner"), mode = { "v", "x", "o" }, desc = "Tree-sitter: loop inner" },
      { "as", select_textobject("@statement.outer"), mode = { "v", "x", "o" }, desc = "Tree-sitter: statement outer" },
    },
  },

  -- matchparen.nvim
  -- highlight matching parentheses
  {
    "monkoose/matchparen.nvim",
    event = "VeryLazy",
    config = function()
      require("matchparen").setup({
        -- Set to `false` to disable at matchpren at startup
        -- Enable matchparen manually with `:MatchParenEnable`
        enabled = true,
        -- Highlight group of the matched brackets
        -- Change it to any other or adjust colors of "MathParen" highlight group
        -- in your colorscheme to your liking
        hl_group = "MatchParen",
        skip_folds = true,
        -- Debounce time in milliseconds for rehighlighting brackets
        -- Set to 0 to disable debouncing
        -- debounce_time = 60,
      })
    end,
  },

  -- targets.vim
  -- provides additional text objects
  -- not already supported by the capture
  -- groups for nvim-treesitter-textobjects
  -- (e.g., * and ** in Quarto or Markdown)
  {
    "wellle/targets.vim",
    event = "VeryLazy",
  },
}
