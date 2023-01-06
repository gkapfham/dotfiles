-- File: Languageserver.lua
-- Purpose: load and configure plugins that control the interface

return {

  -- lspconfig
  {
    "VonHeikemen/lsp-zero.nvim",
    event = "BufReadPre",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = { automatic_installation = true } },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function(plugin)
      local lsp = require("lsp-zero")
      lsp.preset("recommended")
      -- Install these servers
      lsp.ensure_installed({
        "tsserver",
        "eslint",
        "sumneko_lua",
        "pyright"
      })
      -- Pass arguments to a language server
      lsp.configure("tsserver", {
        on_attach = function(client, bufnr)
          print("hello tsserver")
        end,
        settings = {
          completions = {
            completeFunctionCalls = true
          }
        }
      })

    lsp.set_preferences({
      suggest_lsp_servers = true,
      setup_servers_on_start = true,
      set_lsp_keymaps = true,
      configure_diagnostics = true,
      cmp_capabilities = false,
      manage_nvim_cmp = false,
      call_servers = 'local',
      sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
      }
    })
          -- Configure lua language server for neovim
          lsp.nvim_workspace()
          lsp.setup()
        end,

  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>sm", "<cmd>Mason<cr>", desc = "Mason" } },
    ensure_installed = {
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
    },
    config = function(plugin)
      require("mason").setup()
      local mr = require("mason-registry")
      for _, tool in ipairs(plugin.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

}
