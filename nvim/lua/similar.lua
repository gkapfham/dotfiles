-- File: similar.lua
-- Purpose: compression-based text similarity search as a snacks picker.
-- Works like live grep but ranks files by semantic similarity.
-- Uses a two-phase approach: fast token cosine pre-filter, then
-- zstd dictionary compression re-ranking on top candidates.

local ffi = require("ffi")

local M = {}

ffi.cdef([[
  typedef struct ZSTD_CCtx_s ZSTD_CCtx;
  ZSTD_CCtx* ZSTD_createCCtx(void);
  size_t ZSTD_freeCCtx(ZSTD_CCtx* cctx);
  size_t ZSTD_compressBound(size_t srcSize);
  size_t ZSTD_compress(
    void* dst, size_t dstCapacity,
    const void* src, size_t srcSize,
    int compressionLevel
  );
  size_t ZSTD_compress_usingDict(
    ZSTD_CCtx* cctx,
    void* dst, size_t dstCapacity,
    const void* src, size_t srcSize,
    const void* dict, size_t dictSize,
    int compressionLevel
  );
  unsigned ZSTD_isError(size_t code);
]])

local function load_zstd()
  local ok, lib = pcall(ffi.load, "zstd")
  if ok then
    return lib
  end
  local handle = io.popen("ldd $(which zstd) 2>/dev/null | grep libzstd")
  if handle then
    local line = handle:read("*a")
    handle:close()
    local path = line:match("=>%s+(%S+)")
    if path then
      return ffi.load(path)
    end
  end
  error("similar.lua: could not find libzstd")
end

local zstd = load_zstd()

local function tokenize(text)
  local tokens = {}
  for word in text:gmatch("[%w_]+") do
    local lw = word:lower()
    tokens[lw] = (tokens[lw] or 0) + 1
  end
  return tokens
end

local function token_norm(tokens)
  local sum = 0
  for _, c in pairs(tokens) do
    sum = sum + c * c
  end
  return math.sqrt(sum)
end

--- Scan files and pre-compute token vectors for fast filtering.
--- Must be called in normal context (not async).
---@param cwd string
---@return table[]
local function scan_and_index(cwd)
  local max_size = 512 * 1024
  local paths = vim.fn.globpath(cwd, "**/*", false, true)
  local files = {}
  for _, filepath in ipairs(paths) do
    if vim.fn.isdirectory(filepath) == 0 then
      local stat = vim.uv.fs_stat(filepath)
      if stat and stat.size > 0 and stat.size <= max_size then
        local fd = vim.uv.fs_open(filepath, "r", 438)
        if fd then
          local data = vim.uv.fs_read(fd, stat.size, 0)
          vim.uv.fs_close(fd)
          if data and #data > 0 and not data:sub(1, 512):find("\0") then
            local tokens = tokenize(data)
            files[#files + 1] = {
              path = filepath,
              rel = filepath:sub(#cwd + 2),
              content = data,
              tokens = tokens,
              norm = token_norm(tokens),
            }
          end
        end
      end
    end
  end
  return files
end

--- Two-phase similarity scoring:
--- 1. Token cosine similarity to find candidates (instant)
--- 2. Zstd dictionary compression to re-rank top candidates
---@param query string
---@param files table[]
---@param top_n number
---@return table[]
local function score(query, files, top_n)
  local qtokens = tokenize(query)
  local qnorm = token_norm(qtokens)
  if qnorm == 0 then
    return {}
  end
  local candidates = {}
  for _, f in ipairs(files) do
    local dot = 0
    for word, qcount in pairs(qtokens) do
      local fcount = f.tokens[word]
      if fcount then
        dot = dot + qcount * fcount
      end
    end
    if dot > 0 then
      candidates[#candidates + 1] = {
        file = f,
        token_sim = dot / (qnorm * f.norm),
      }
    end
  end
  table.sort(candidates, function(a, b)
    return a.token_sim > b.token_sim
  end)
  local n = math.min(top_n, #candidates)
  local cctx = zstd.ZSTD_createCCtx()
  local bound = zstd.ZSTD_compressBound(#query)
  local dst = ffi.new("char[?]", bound)
  local baseline = tonumber(
    zstd.ZSTD_compress(dst, bound, query, #query, 1)
  )
  local ranked = {}
  for i = 1, n do
    local c = candidates[i]
    local size = tonumber(zstd.ZSTD_compress_usingDict(
      cctx, dst, bound,
      query, #query,
      c.file.content, #c.file.content,
      1
    ))
    local sim = math.max(0, 1 - size / baseline)
    ranked[#ranked + 1] = {
      rel = c.file.rel,
      path = c.file.path,
      sim = sim,
    }
  end
  zstd.ZSTD_freeCCtx(cctx)
  table.sort(ranked, function(a, b)
    return a.sim > b.sim
  end)
  return ranked
end

--- Open the similarity picker, optionally with initial search text.
---@param initial_search? string
function M.pick(initial_search)
  local cwd = vim.uv.cwd() or "."
  local files = scan_and_index(cwd)
  Snacks.picker({
    title = string.format("Similar Files (%d files)", #files),
    finder = function(_, ctx)
      if ctx.filter.search == "" then
        return function() end
      end
      local ranked = score(ctx.filter.search, files, 50)
      ---@async
      return function(cb)
        for _, r in ipairs(ranked) do
          local pct = string.format("%.1f%%", r.sim * 100)
          cb({
            text = pct .. " " .. r.rel,
            file = r.path,
            score = math.floor(r.sim * 10000),
            similarity = pct,
          })
        end
      end
    end,
    live = true,
    supports_live = true,
    show_empty = true,
    search = initial_search or "",
    format = function(item)
      return {
        { item.similarity .. " ", "Number" },
        { item.file, "SnacksPickerFile" },
      }
    end,
    sort = { fields = { "score:desc", "idx" } },
    layout = { layout = { backdrop = false } },
    preview = "file",
    confirm = function(picker, item)
      picker:close()
      if item and item.file then
        vim.cmd("edit " .. vim.fn.fnameescape(item.file))
      end
    end,
  })
end

function M.pick_visual()
  local lines = vim.fn.getregion(
    vim.fn.getpos("v"),
    vim.fn.getpos("."),
    { type = vim.fn.mode() }
  )
  local text = table.concat(lines, " ")
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "nx",
    false
  )
  M.pick(text)
end

return M
