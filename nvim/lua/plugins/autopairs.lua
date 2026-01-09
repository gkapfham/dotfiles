-- File: plugins/autopairs.lua
-- Purpose: Configure the autopairs plugin

return {

  -- nvim-autopairs: automatically insert closing pairs
  -- with some disabling of certain filetypes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      npairs.setup({
        -- Enable treesitter checking but with better rules
        check_ts = true,
        ts_config = {
          lua = { "string" }, -- don't add pairs in lua string treesitter nodes
          javascript = { "template_string" },
          java = false, -- don't check treesitter on java
          tex = { "string" }, -- don't add pairs inside LaTeX strings
        },
        -- Enable checking if there's already a closing bracket on the line
        -- This prevents adding `)` when there's already one ahead
        enable_check_bracket_line = true,
        -- Only add closing pair if the next character is whitespace or a closing bracket
        -- This prevents unwanted pairs in the middle of words
        ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
        -- Enable fast wrap feature (Alt+g to move closing pair)
        fast_wrap = {
          map = "<M-g>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
        -- Enable deletion of pairs with Ctrl+h
        map_c_h = true,
        -- Enable deletion of pairs with Ctrl+w
        map_c_w = true,
      })
      -- Add rule to not pair backticks in markdown/quarto/tex
      -- (for code blocks that need ```)
      local backtick_rule = npairs.get_rule("`")
      if backtick_rule and backtick_rule[1] then
        backtick_rule[1].not_filetypes = { "markdown", "quarto", "tex" }
      end
      -- Add rule to not pair single quotes in tex (for linguistic examples)
      local quote_rule = npairs.get_rule("'")
      if quote_rule and quote_rule[1] then
        quote_rule[1].not_filetypes = { "tex" }
      end
      -- Special rule for triple backticks in markdown/quarto (fenced code blocks)
      npairs.add_rules({
        Rule("```", "```", { "markdown", "quarto" })
          :with_pair(cond.not_after_regex("```"))
          :with_move(cond.none())
          :with_cr(function()
            return true
          end),
      })
      -- Add smarter spacing rules for brackets
      -- Automatically add space between brackets in functions: func(|) -> func( | )
      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        Rule(" ", " ")
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. "  " .. brackets[1][2],
              brackets[2][1] .. "  " .. brackets[2][2],
              brackets[3][1] .. "  " .. brackets[3][2],
            }, context)
          end),
      })

      -- Python-specific rules removed
      -- Triple quote rules were causing typing delays, so we rely on
      -- standard quote pairing instead. Type """ manually for docstrings.

      -- LaTeX-specific rules for better autopairs
      npairs.add_rules({
        -- Dollar signs for inline math mode: $x = y$
        Rule("$", "$", "tex")
          :with_pair(cond.not_after_regex("\\$")) -- don't pair if escaped with backslash
          :with_move(function(opts)
            return opts.char == "$"
          end),

        -- Double dollar signs for display math mode: $$...$$
        Rule("$$", "$$", "tex"):with_pair(cond.not_after_regex("%$%$")):with_move(cond.none()),
      })
      -- Arrow key rules for JavaScript/TypeScript arrow functions
      npairs.add_rules({
        Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
          :use_regex(true)
          :set_end_pair_length(2),
      })
    end,
  },

  -- nvim-ts-autotag: automatically generate tags
  -- for html/xml paired tags, like <div></div>
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
