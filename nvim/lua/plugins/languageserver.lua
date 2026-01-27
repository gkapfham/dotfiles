-- File: plugins/languageserver.lua
-- Purpose: load and configure plugins for installation
-- and use of language servers protocol (LSP) implementations

return {

  -- neodev.nvim for LSP enhancement for Lua files
  {
    "folke/neodev.nvim",
    event = "BufReadPost",
    config = function()
      require("neodev").setup()
    end,
  },

  -- nvim-lspconfig for LSP management
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      -- draw the border for the LSP floating window; since the
      -- window used for commands like :LSPInfo is driven by the
      -- NormalFloat which is now set to dark to make the GitHub
      -- Copilot chat look as nice as possible there is a need
      -- to make the border visible so that these menus are okay
      require("lspconfig.ui.windows").default_options.border = "single"
      -- draw the border for the LSP floating window that displays
      -- when requesting the documentation for source code; note
      -- that by default when you use <space>k it will display information
      -- about the source code under the cursor but do so without the box
      -- and this makes it difficult to see the information since the background
      -- is the same color and the diagnostic information
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      -- Setup LSP servers:
      -- 1) CSS
      -- 2) HTML
      -- 3) Lua
      -- 4) Markdown
      -- 5) Python
      -- 7) Go
      -- 7) LaTeX and BibTeX
      -- 8) Writing (Harper-ls)
      -- 9) YAML
      -- 10) Nix
      -- 11) Rust
      -- 12) Copilot
      -- configure cssls for CSS LSP
      local css_capabilities = vim.lsp.protocol.make_client_capabilities()
      css_capabilities.textDocument.completion.completionItem.snippetSupport = true
      vim.lsp.config("cssls", {
        capabilities = css_capabilities,
      })
      vim.lsp.enable("cssls")
      -- configure html_ls for HTML
      local html_capabilities = vim.lsp.protocol.make_client_capabilities()
      html_capabilities.textDocument.completion.completionItem.snippetSupport = true
      vim.lsp.config("html", {
        capabilities = html_capabilities,
        filetypes = { "markdown", "quarto", "html" },
      })
      vim.lsp.enable("html")
      -- configure htmx for HTML LSP
      vim.lsp.enable("htmx")
      -- configure gopls for Go LSP
      vim.lsp.enable("gopls")
      -- configure luals (with neovim support) for Lua LSP
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")
      -- configure marksman for Markdown LSP
      vim.lsp.config("marksman", {
        filetypes = { "markdown", "quarto" },
      })
      vim.lsp.enable("marksman")
      -- configure pyright for Python LSPs
      -- configure basedpyright for Python LSP (enhanced pyright fork)
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportUnusedImport = "information",
                reportUnusedVariable = "information",
              },
            },
          },
        },
      })
      vim.lsp.enable("basedpyright")
      -- configure pyright for Python LSP (disabled in favor of basedpyright)
      -- vim.lsp.config("pyright", {
      --   settings = {
      --     python = {
      --       analysis = {
      --         typeCheckingMode = "basic",
      --         autoImportCompletions = true,
      --         diagnosticSeverityOverrides = {
      --           reportUnusedImport = "information",
      --           reportUnusedVariable = "information",
      --         },
      --       },
      --     },
      --   },
      -- })
      -- vim.lsp.enable("pyright")
      -- configure pyrefly for Python LSP
      vim.lsp.enable("pyrefly")
      -- configure ruff for Python LSP
      vim.lsp.enable("ruff")
      -- configure ty for Python LSP
      vim.lsp.enable("ty")
      -- configure zuban for Python LSP
      vim.lsp.enable("zuban")
      -- configure texlab for LaTeX and BibTeX LSP
      vim.lsp.config("texlab", {
        settings = {
          texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              executable = "latexmk",
              forwardSearchAfter = false,
              onSave = false,
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 0,
            forwardSearch = {
              executable = "zathura",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = false,
            },
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false,
              spaces = 4,
              indent = "  ",
            },
          },
        },
      })
      vim.lsp.enable("texlab")
      -- configure harper_ls for writing
      vim.lsp.config("harper_ls", {
        filetypes = { "mail", "markdown", "quarto", "text" },
        settings = {
          ["harper-ls"] = {
            userDictPath = "~/.config/nvim/spell/en.utf-8.add",
            linters = {
              spell_check = false,
              spelled_numbers = false,
              an_a = true,
              sentence_capitalization = true,
              unclosed_quotes = true,
              wrong_quotes = false,
              long_sentences = false,
              repeated_words = true,
              spaces = true,
              matcher = true,
              correct_number_suffix = true,
              number_suffix_capitalization = true,
            },
          },
        },
      })
      vim.lsp.enable("harper_ls")
      -- configure yamlls for YAML LSP
      vim.lsp.enable("yamlls")
      -- configure jsonls for YAML LSP
      vim.lsp.enable("jsonls")
      -- configure nil_ls for Nix LSP
      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })
      vim.lsp.enable("nil_ls")
      -- configure rust_analzer for Rust LSP
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            assist = {
              importGranularity = "module",
              importPrefix = "self",
            },
            diagnostics = {
              enable = true,
              enableExperimental = true,
            },
            cargo = {
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
            inlayHints = {
              chainingHints = true,
              parameterHints = true,
              typeHints = true,
            },
          },
        },
      })
      -- Configure other aspects of the language servers
      -- Use toggle_lsp_diagnostics to disable the virtual_text and then
      -- to support the display of the diagnostics
      require("toggle_lsp_diagnostics").init({ start_on = true, virtual_text = false })
      -- Define customized signs for diagnostics reported by the language server;
      -- note that this will define the signs displayed in the gutter
      local internal_signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      -- Configure the display of diagnostics, especially to confirm
      -- that there is a rounded border around the diagnostic box
      -- that appears when you go to a line with a diagnostic
      vim.diagnostic.config({
        underline = true,
        virtual_text = false,
        virtual_lines = false,
        update_in_insert = true,
        float = {
          header = false,
          border = "rounded",
          focusable = true,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = internal_signs.Error,
            [vim.diagnostic.severity.WARN] = internal_signs.Warn,
            [vim.diagnostic.severity.INFO] = internal_signs.Info,
            [vim.diagnostic.severity.HINT] = internal_signs.Hint,
          },
        },
      })
    end,
    -- Keys
    keys = {
      {
        "<Space>sv",
        "<Plug>(toggle-lsp-diag-vtext)",
        desc = "Language Server: Toggle virtual text",
      },
      {
        "<Space>e",
        "<cmd> lua vim.diagnostic.open_float(0, {scope='line', border='rounded'})<CR>",
        desc = "Language Server: Display diagnostics",
      },
      {
        "<Space>k",
        "<cmd> lua vim.lsp.buf.hover()<CR>",
        desc = "Language Server: Symbol details",
      },
      {
        "<Space>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        desc = "Language Server: Perform code action",
      },
      {
        "<Space>rv",
        "<cmd> lua vim.lsp.buf.rename()<CR>",
        desc = "Language Server: Rename variable",
      },
    },
  },

  -- conform.nvim
  -- Formatting files plugin that works
  -- as a replacement for tools like null-ls.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<Space>ff",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer with conform",
      },
      {
        "<Space>ft",
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          if vim.b.disable_autoformat then
            vim.notify("Disabled format-on-save for this buffer", vim.log.levels.INFO)
          else
            vim.notify("Enabled format-on-save for this buffer", vim.log.levels.INFO)
          end
        end,
        mode = "n",
        desc = "Toggle format-on-save for buffer",
      },
    },
    opts = {
      -- define formatters
      formatters_by_ft = {
        javascript = { "prettierd" },
        tex = { "latexindent" },
        lua = { "stylua" },
        python = { "ruff" },
        markdown = { "mdformat" },
        nix = { "nixfmt" },
      },
      -- set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        -- Disable with a buffer-local variable
        if vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500 }
      end,
      -- customize formatters
      formatters = {
        shfmt = {
          append_args = { "-i", "2" },
        },
        latexindent = {
          prepend_args = { "-y=defaultIndent: '  '" },
        },
        stylua = {
          inherit = false,
          command = "stylua",
          args = {
            "--search-parent-directories",
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--stdin-filepath",
            "$FILENAME",
            "-",
          },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- symbol-usage.nvim displays symbol usage information in virtual text;
  -- after trying several approaches, this package seems to be the fastest
  -- and the most configurable and lead to the least amount of on-screen
  -- jumping when the source code and/or the references change
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    config = function()
      local SymbolKind = vim.lsp.protocol.SymbolKind
      local function text_format(symbol)
        local res = {}
        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""
        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, { "󰌹 ", "SymbolUsageRef" })
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
        end
        if symbol.definition then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, { "󰳽 ", "SymbolUsageDef" })
          table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
        end
        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
          table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
        end
        if stacked_functions_content ~= "" then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, { " ", "SymbolUsageImpl" })
          table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
        end
        return res
      end
      require("symbol-usage").setup({
        disable = {
          -- lsp = { "pyrefly", "pyright", "ty" },
          -- lsp = { "basedpyright", "ty", "zuban" },
          -- lsp = { "pyrefly", "ty", "zuban" },
          lsp = { "pyrefly", "basedpyright", "zuban" },
        },
        kinds = {
          SymbolKind.Function,
          SymbolKind.Method,
          SymbolKind.Struct,
          SymbolKind.Interface,
          SymbolKind.Class,
        },
        references = {
          enabled = true,
          include_declaration = true,
        },
        implementation = {
          enabled = true,
        },
        definition = {
          enabled = true,
        },
        vt_position = "end_of_line",
        text_format = text_format,
      })
    end,
    keys = {
      -- Toggle symbols usage
      {
        "<Space>sd",
        "<cmd> lua require('symbol-usage').toggle() <CR>",
        desc = "Language Server: Disable symbols usage",
      },
    },
  },
}
