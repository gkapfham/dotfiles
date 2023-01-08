-- File: plugins/luasnip.lua
-- Purpose: load and configure the luasnip plugin

return {

  -- Snippet definition and insertion with luasnip
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        -- Define snippets for email messages
        ls.add_snippets("mail", {
            -- Signatures at the end of an email message
            s({trig = "tyakr", dscr = "Detailed Email Sign-Off"}, {
                t({"Thank You and Kind Regards,", "", "  Greg"}),
            }),
            s({trig = "taakr", dscr = "Detailed Email Sign-Off"}, {
                t({"Thanks Again and Kind Regards,", "", "  Greg"}),
            }),
            s({trig = "kr", dscr = "Kind Regards"}, {
                t({"Kind Regards,", "", "  Greg"}),
            }),
            s({trig = "ty", dscr = "Thank You"}, {
                t({"Thank You,", "", "  Greg"}),
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
          -- Define the type of signatures in this table
          {key = "mail",}
        )
      end,
    },
    -- Additional configuration for the luasnip plugin
    config = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

}
