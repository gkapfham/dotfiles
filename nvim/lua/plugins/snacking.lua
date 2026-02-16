-- File: plugins/snacking.lua
-- Purpose: load and configure the snacks.nvim plugin

-- defaults for the ck semantic search picker
local ck_config = {
  mode = "--sem",
  limit = 10,
  threshold = nil,
}

-- cache for ck index status per directory
local ck_index_cache = {}

-- check whether the ck index exists for the given directory
local function ck_index_ready(cwd)
  local cached = ck_index_cache[cwd]
  if cached and (vim.uv.now() - cached.time) < 60000 then
    return cached.ready
  end
  local result = vim.system({ "ck", "--status-json", cwd }, { text = true }):wait()
  local ready = false
  if result.code == 0 then
    local ok, status = pcall(vim.json.decode, result.stdout)
    ready = ok and status and status.index_exists == true
  end
  ck_index_cache[cwd] = { ready = ready, time = vim.uv.now() }
  return ready
end

-- Define a complete implementation of the picker using the ck-tool
-- (i.e., it is called "seek" and abbreviated "ck" and available at
-- the following URL: https://beaconbay.github.io/ck/)
local function ck_picker(initial_search, overrides)
  local cfg = vim.tbl_extend("force", ck_config, overrides or {})
  local cwd = vim.uv.cwd() or "."
  if not ck_index_ready(cwd) then
    vim.notify("ck index not found. Run `ck --index .` in this directory first.", vim.log.levels.ERROR)
    return
  end
  Snacks.picker.pick({
    title = "Semantic Search (ck)",
    format = "file",
    notify = false,
    show_empty = true,
    live = true,
    supports_live = true,
    search = initial_search or "",
    ---@param opts snacks.picker.grep.Config
    finder = function(opts, ctx)
      if ctx.filter.search == "" then
        return function() end
      end
      local args = { cfg.mode, "--jsonl", "-q" }
      if cfg.limit then
        table.insert(args, "--limit")
        table.insert(args, tostring(cfg.limit))
      end
      if cfg.threshold then
        table.insert(args, "--threshold")
        table.insert(args, tostring(cfg.threshold))
      end
      table.insert(args, ctx.filter.search)
      return require("snacks.picker.source.proc").proc({
        cmd = "ck",
        args = args,
        notify = opts.notify,
        cwd = opts.cwd,
        transform = function(item)
          local ok, entry = pcall(vim.json.decode, item.text)
          if not ok or not entry or not entry.path then
            return false
          end
          item.cwd = vim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or ".") or nil
          item.file = entry.path:gsub("^%./", "")
          item.line = entry.snippet or ""
          if entry.span then
            item.pos = { tonumber(entry.span.line_start) or 1, 0 }
          end
          item.score = math.floor((entry.score or 0) * 10000)
        end,
      }, ctx)
    end,
  })
end

-- Define the visual mode function that extracts the highlighted text
-- that the user has highlighted in visual mode and pass to the ck picker
local function ck_picker_visual()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  local text = table.concat(lines, " ")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  ck_picker(text)
end

-- :SemanticSearch [mode=sem|hybrid|lex] [limit=N] [threshold=N] [query]
vim.api.nvim_create_user_command("SemanticSearch", function(cmd)
  local overrides = {}
  local words = {}
  for _, token in ipairs(vim.split(cmd.args, "%s+", { trimempty = true })) do
    local key, val = token:match("^(%w+)=(.+)$")
    if key == "mode" then
      overrides.mode = "--" .. val
    elseif key == "limit" then
      overrides.limit = tonumber(val)
    elseif key == "threshold" then
      overrides.threshold = tonumber(val)
    else
      table.insert(words, token)
    end
  end
  ck_picker(table.concat(words, " "), overrides)
end, {
  nargs = "*",
  desc = "Semantic search with ck (options: mode=sem|hybrid|lex limit=N threshold=N)",
})

-- Define a picker that uses the ast-grep tool to perform structural code search
-- (see https://ast-grep.github.io/ for more details about how ast-grep works)
local function ast_grep_picker()
  Snacks.picker.pick({
    format = "file",
    notify = false,
    show_empty = true,
    live = true,
    supports_live = true,
    ---@param opts snacks.picker.grep.Config
    finder = function(opts, ctx)
      local cmd = "ast-grep"
      local args = { "run", "--color=never", "--json=stream" }
      if vim.fn.has("win32") == 1 then
        cmd = "sg"
      end
      if opts.hidden then
        table.insert(args, "--no-ignore=hidden")
      end
      if opts.ignored then
        table.insert(args, "--no-ignore=vcs")
      end
      local pattern, pargs = Snacks.picker.util.parse(ctx.filter.search)
      table.insert(args, string.format("--pattern=%s", pattern))
      vim.list_extend(args, pargs)
      return require("snacks.picker.source.proc").proc({
        cmd = cmd,
        args = args,
        notify = opts.notify,
        cwd = opts.cwd,
        transform = function(item)
          local entry = vim.json.decode(item.text)
          if vim.tbl_isempty(entry) then
            return false
          else
            local start = entry.range.start
            item.cwd = vim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or ".") or nil
            item.file = entry.file
            item.line = entry.text
            item.pos = { tonumber(start.line) + 1, tonumber(start.column) }
          end
        end,
      }, ctx)
    end,
  })
end

return {

  -- snacks.nvim
  -- small improvements to the user interface,
  -- including pickers for numerous elements,
  -- a terminal window, and a file explorer
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      git = { enabled = false },
      gh = {
        enabled = false,
        icons = {
          reactions = {
            thumbs_up = " ",
            thumbs_down = " ",
            eyes = "󰡭 ",
            confused = "󱚟 ",
            heart = "󰣐 ",
            hooray = "󱁖 ",
            laugh = "󰱱 ",
            rocket = " ",
          },
        },
        layout = {
          layout = {
            backdrop = false,
          },
        },
      },
      lazygit = { enabled = false },
      indent = {
        enabled = true,
        animate = {
          enabled = true,
          style = "up_down",
          easing = "linear",
          duration = {
            step = 10,
            total = 100,
          },
        },
        scope = {
          enabled = true,
          underline = false,
        },
      },
      input = { enabled = false },
      notifier = {
        enabled = true,
        margin = { top = 1, right = 1, bottom = 0 },
        style = "fancy",
      },
      picker = {
        enabled = true,
        ui_select = true,
        icons = {
          diagnostics = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = "  ",
          },
        },
        layout = {
          layout = {
            backdrop = false,
          },
        },
        win = {
          input = {
            keys = {},
          },
        },
        sources = {
          spelling = {
            layout = {
              layout = {
                border = "rounded",
              },
            },
          },
          icons = {
            layout = {
              layout = {
                border = "rounded",
              },
            },
          },
          command_history = {
            layout = {
              layout = {
                border = "rounded",
              },
            },
          },
          explorer = {
            layout = {
              layout = { position = "right", width = 35 },
            },
            styles = {
              zindex = 1,
            },
          },
          files = {
            layout = {
              layout = {
                backdrop = false,
              },
            },
          },
          scratch = {
            layout = {
              layout = {
                backdrop = false,
              },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = {
        enabled = false,
        treesitter = {
          blocks = {
            enabled = false,
          },
        },
      },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
    },
    keys = {
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gi",
        function()
          Snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>gI",
        function()
          Snacks.picker.gh_issue({ state = "all" })
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>gp",
        function()
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>gP",
        function()
          Snacks.picker.gh_pr({ state = "all" })
        end,
        desc = "GitHub Pull Requests (all)",
      },
      {
        "<leader>gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log_line()
        end,
        desc = "Git Log Line",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff (Hunks)",
      },
      {
        "<leader>gf",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git Log File",
      },
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<Space>0",
        function()
          Snacks.picker.explorer()
        end,
        desc = "File Explorer",
      },
      {
        "<Space>i",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Switch Buffers",
      },
      {
        "<Space>o",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = "Find Files: Hidden",
      },
      {
        "<Space>p",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files: Non-hidden",
      },
      {
        "<Space>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
      {
        "<Space>ch",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<Space>dd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Document Diagnostics",
      },
      {
        "<Space>ga",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep: All",
      },
      {
        "<Space>gr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "LSP: Goto References",
      },
      {
        "<Space>gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "LSP: Goto Definitions",
      },
      {
        "<Space>gs",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Grep: Highlighted Word",
      },
      {
        "<Space>ls",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP: Symbols",
      },
      {
        "<Space>su",
        function()
          Snacks.picker.smart()
        end,
        desc = "Find Files: Universal",
      },
      {
        "<Space>si",
        function()
          require("similar").pick()
        end,
        desc = "Find Files: Intelligence through Similarity",
      },
      {
        "<Space>si",
        function()
          require("similar").pick_visual()
        end,
        mode = "v",
        desc = "Find Files: Intelligence through Similarity",
      },
      {
        "<Space>ta",
        function()
          require("aerial").snacks_picker()
        end,
        desc = "Aerial: Symbols",
      },
      {
        "<Space>ts",
        function()
          Snacks.picker.treesitter()
        end,
        desc = "Treesitter: Symbols",
      },
      {
        "<Space>wd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "LSP: Workspace Diagnostics",
      },
      {
        "<Space>ls",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP: Symbols",
      },
      {
        "<Space>ws",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP: Workspace Symbols",
      },
      {
        "<Space>tt",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
      },
      {
        "<Space>sk",
        function()
          ck_picker()
        end,
        desc = "Semantic Search (ck)",
      },
      {
        "<Space>sk",
        function()
          ck_picker_visual()
        end,
        mode = "v",
        desc = "Semantic Search (ck)",
      },
      {
        "<Space>sg",
        function()
          ast_grep_picker()
        end,
        desc = "Grep: AST (ast-grep)",
      },
      {
        "<Space>zz",
        function()
          Snacks.picker.spelling()
        end,
        desc = "Spelling Suggestions",
      },
    },
    init = function()
      local nvim_web_devicons = require("nvim-web-devicons")
      local current_icons = nvim_web_devicons.get_icons()
      local new_icons = {}
      for key, icon in pairs(current_icons) do
        icon.color = "#a8a8a8"
        new_icons[key] = icon
      end
      nvim_web_devicons.set_icon(new_icons)
      nvim_web_devicons.set_default_icon("", "#a8a8a8")
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.indent():map("<leader>ui")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  -- snacks-bibtex.nvim
  -- BibTeX citation picker for snacks.nvim
  {
    "krissen/snacks-bibtex.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      depth = 5,
      mappings = {
        ["<C-p>"] = false,
      },
      context = {
        enabled = true,
        fallback = true,
        inherit = true,
        depth = 1,
        max_files = 100,
      },
    },
    keys = {
      {
        "<Space>tb",
        function()
          require("snacks-bibtex").bibtex()
        end,
        desc = "BibTeX citations (Snacks)",
      },
    },
  },
}
