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

local function dashboard_is_small()
  return vim.o.columns < 100 or vim.o.lines < 28
end

local dashboard_keymap_reminders = {
  { key = "<Space>ls", note = "LSP symbols" },
  { key = "<Space>ts", note = "Treesitter symbols" },
  { key = "<Space>wd", note = "Workspace diagnostics" },
}

local git_dashboard_cache = { cwd = nil, profile = nil, at = 0, text = nil }
local git_commits_cache = { cwd = nil, profile = nil, at = 0, text = nil }

local function shorten_text(text, max_len)
  if #text <= max_len then
    return text
  end
  return text:sub(1, max_len - 1) .. "…"
end

local function dashboard_size_profile()
  if vim.o.columns < 120 or vim.o.lines < 30 then
    return "compact"
  elseif vim.o.columns < 145 or vim.o.lines < 36 then
    return "normal"
  end
  return "wide"
end

local function dashboard_reminder_text()
  local profile = dashboard_size_profile()
  local lines = {}
  for _, item in ipairs(dashboard_keymap_reminders) do
    local line
    if profile == "compact" then
      line = string.format("%s -> %s", item.key, item.note)
      line = shorten_text(line, 34)
    elseif profile == "normal" then
      line = string.format("%s -> %s", item.key, item.note)
      line = shorten_text(line, 44)
    else
      line = string.format("%s -> %s", item.key, item.note)
    end
    table.insert(lines, line)
  end
  return table.concat(lines, "\n")
end

local function git_dashboard_text()
  local cwd = vim.uv.cwd() or "."
  local now = vim.uv.now()
  local profile = dashboard_size_profile()
  if
    git_dashboard_cache.cwd == cwd
    and git_dashboard_cache.profile == profile
    and git_dashboard_cache.text
    and (now - git_dashboard_cache.at) < 120000
  then
    return git_dashboard_cache.text
  end

  if vim.fn.executable("git") == 0 then
    return nil
  end

  local result = vim.system({ "git", "status", "--porcelain=v2", "--branch" }, { text = true, cwd = cwd }):wait()
  if result.code ~= 0 or not result.stdout then
    git_dashboard_cache = { cwd = cwd, at = now, text = nil }
    return nil
  end

  local branch = "detached"
  local ahead, behind = 0, 0
  local staged, changed, untracked, conflicted, renamed = 0, 0, 0, 0, 0

  for _, line in ipairs(vim.split(result.stdout, "\n", { trimempty = true })) do
    if vim.startswith(line, "# branch.head ") then
      branch = line:gsub("# branch.head ", "")
    elseif vim.startswith(line, "# branch.ab ") then
      local a, b = line:match("# branch%.ab %+(%d+) %-(%d+)")
      ahead = tonumber(a) or 0
      behind = tonumber(b) or 0
    elseif vim.startswith(line, "1 ") or vim.startswith(line, "2 ") then
      local xy = line:sub(3, 4)
      if xy:sub(1, 1) ~= "." then
        staged = staged + 1
      end
      if xy:sub(2, 2) ~= "." then
        changed = changed + 1
      end
      if vim.startswith(line, "2 ") then
        renamed = renamed + 1
      end
    elseif vim.startswith(line, "? ") then
      untracked = untracked + 1
    elseif vim.startswith(line, "u ") then
      conflicted = conflicted + 1
    end
  end

  local branch_name = branch
  local status_line
  if profile == "compact" then
    branch_name = shorten_text(branch_name, 16)
    status_line = string.format("+%d  ~%d  ?%d", staged, changed, untracked)
  elseif profile == "normal" then
    branch_name = shorten_text(branch_name, 24)
    status_line = string.format("+%d  ~%d  ?%d  !%d", staged, changed, untracked, conflicted)
  else
    branch_name = shorten_text(branch_name, 36)
    status_line =
      string.format(" %d   %d  ? %d   %d  󰑕 %d", staged, changed, untracked, conflicted, renamed)
  end

  local branch_line = string.format(" %s", branch_name)
  if ahead > 0 or behind > 0 then
    if profile == "compact" then
      branch_line = string.format("%s ↑%d↓%d", branch_line, ahead, behind)
    else
      branch_line = string.format("%s  ↑%d ↓%d", branch_line, ahead, behind)
    end
  end

  local lines = { branch_line, status_line }

  local text = table.concat(lines, "\n")
  git_dashboard_cache = { cwd = cwd, profile = profile, at = now, text = text }
  return text
end

local function git_commits_text()
  local cwd = vim.uv.cwd() or "."
  local now = vim.uv.now()
  local profile = dashboard_size_profile()
  if
    git_commits_cache.cwd == cwd
    and git_commits_cache.profile == profile
    and git_commits_cache.text
    and (now - git_commits_cache.at) < 120000
  then
    return git_commits_cache.text
  end

  if vim.fn.executable("git") == 0 then
    return nil
  end

  local limit = profile == "compact" and 3 or (profile == "normal" and 4 or 5)
  local result = vim.system({ "git", "log", "--oneline", "--no-decorate", "-n", tostring(limit) }, { text = true, cwd = cwd }):wait()
  if result.code ~= 0 or not result.stdout then
    git_commits_cache = { cwd = cwd, at = now, text = nil }
    return nil
  end

  local lines = {}
  for _, line in ipairs(vim.split(result.stdout, "\n", { trimempty = true })) do
    local hash, msg = line:match("^(%w+)%s+(.*)$")
    if hash and msg then
      local short_hash = hash:sub(1, 7)
      local display_msg = shorten_text(msg, profile == "compact" and 24 or (profile == "normal" and 34 or 46))
      table.insert(lines, string.format("%s %s", short_hash, display_msg))
    end
  end

  local text = table.concat(lines, "\n")
  git_commits_cache = { cwd = cwd, profile = profile, at = now, text = text }
  return text
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
      image = { enabled = false },
      dashboard = {
        enabled = true,
        width = 60,
        pane_gap = 4,
        sections = {
          {
            section = "header",
            enabled = function()
              return not dashboard_is_small()
            end,
          },
          {
            section = "keys",
            icon = "󰌌 ",
            title = "Dashboard Keymaps",
            indent = 2,
            gap = 0,
            padding = 1,
          },
          function()
            if dashboard_is_small() or #dashboard_keymap_reminders == 0 then
              return nil
            end
            return {
              pane = 1,
              icon = "󰌌 ",
              title = "Keymap Reminders",
              {
                text = {
                  { dashboard_reminder_text(), hl = "Normal" },
                },
              },
              indent = 2,
              padding = 1,
            }
          end,
          {
            pane = 1,
            section = "startup",
            enabled = function()
              return not dashboard_is_small()
            end,
          },
          function()
            if dashboard_is_small() then
              return nil
            end
            local cwd = vim.uv.cwd() or vim.fn.getcwd()
            local profile = dashboard_size_profile()
            local max_len = profile == "compact" and 34 or (profile == "normal" and 44 or 56)
            local display_cwd = shorten_text(cwd, max_len)
            return {
              pane = 2,
              icon = " ",
              title = "Working Directory",
              {
                text = {
                  { display_cwd, hl = "Normal" },
                },
              },
              indent = 2,
              padding = 1,
            }
          end,
          function()
            if dashboard_is_small() then
              return nil
            end
            local profile = dashboard_size_profile()
            local recent_limit = profile == "compact" and 4 or (profile == "normal" and 6 or 8)
            local project_limit = profile == "compact" and 2 or (profile == "normal" and 5 or 7)
            return {
              {
                pane = 2,
                icon = " ",
                title = "Recent Files",
                section = "recent_files",
                indent = 2,
                padding = 1,
                limit = recent_limit,
              },
              {
                pane = 2,
                icon = " ",
                title = "Projects",
                section = "projects",
                indent = 2,
                padding = 1,
                limit = project_limit,
              },
            }
          end,
          function()
            if dashboard_is_small() then
              return nil
            end
            local text = git_dashboard_text()
            if not text then
              return nil
            end
            return {
              pane = 2,
              icon = " ",
              title = "Git Summary",
              {
                text = {
                  { text, hl = "Normal" },
                },
              },
              indent = 2,
              padding = 1,
            }
          end,
          function()
            if dashboard_is_small() then
              return nil
            end
            local text = git_commits_text()
            if not text then
              return nil
            end
            return {
              pane = 2,
              icon = " ",
              title = "Last Commits",
              {
                text = {
                  { text, hl = "Normal" },
                },
              },
              indent = 2,
              padding = 1,
            }
          end,
        },
        preset = {
          header = table.concat({
            [[ ▀█  █▀▀▄ █▀▀▄ █▀▀█ █   █ █▀▀█ ▀▀█▀▀ █▀▀]],
            [[  █  █  █ █  █ █  █ █   █ █▄▄█   █   █▀▀]],
            [[ ▀▀▀ ▀  ▀ ▀  ▀ ▀▀▀▀  ▀▀▀  ▀  ▀   ▀   ▀▀▀]],
            [[        "working is relaxing for me"      ]],
          }, "\n"),
          keys = {
            {
              icon = "󰈞 ",
              key = "f",
              desc = "Find Files",
              action = ":lua Snacks.dashboard.pick('files')",
            },
            {
              icon = "󰱼 ",
              key = "g",
              desc = "Live Grep",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = " ",
              key = "m",
              desc = "Smart Files",
              action = ":lua Snacks.picker.smart()",
            },
            {
              icon = "󱍓 ",
              key = "i",
              desc = "Similar Files",
              action = ":lua require('similar').pick()",
            },
            {
              icon = " ",
              key = "p",
              desc = "Browse Projects",
              action = ":lua Snacks.picker.projects()",
            },
            { icon = " ", key = "z", desc = "Search Notes", action = ":ZkNotes" },
            { icon = "󰵁 ", key = "n", desc = "Recents Notes", action = ":ZkRecents" },
            { icon = "󰊢 ", key = "s", desc = "Git Status", action = ":Git status" },
            {
              icon = " ",
              key = "c",
              desc = "Coding Agent",
              action = ":lua require('sidekick.cli').toggle({ filter = { installed = true } })",
            },
            { icon = "󰒲 ", key = "l", desc = "Plugin manager", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit Neovim", action = ":qa" },
          },
        },
      },
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
        "<Space>db",
        function()
          Snacks.dashboard()
        end,
        desc = "Snacks: Dashboard",
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
