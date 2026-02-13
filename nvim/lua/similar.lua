-- File: similar.lua
-- Purpose: compression-based text similarity search as a snacks picker.
-- Works like live grep but ranks files by semantic similarity.
-- Uses token cosine similarity for scoring, with zstd dictionary
-- compression as a re-ranking boost for longer queries.

local ffi = require("ffi")

local M = {}

-- Cache for file index to avoid rescanning on every picker open
local file_cache = {
  cwd = nil,
  files = nil,
  mtime = 0,
}

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

--- Tokenize text into lowercase word frequencies.
---@param text string
---@return table<string, number>
local function tokenize(text)
  local tokens = {}
  for word in text:gmatch("[%w_]+") do
    local lw = word:lower()
    tokens[lw] = (tokens[lw] or 0) + 1
  end
  return tokens
end

--- Compute the L2 norm of a token frequency vector.
---@param tokens table<string, number>
---@return number
local function token_norm(tokens)
  local sum = 0
  for _, c in pairs(tokens) do
    sum = sum + c * c
  end
  return math.sqrt(sum)
end

--- Scan files and pre-compute token vectors for fast similarity.
--- Uses caching to avoid rescanning on every picker open.
---@param cwd string
---@param force? boolean Force rescan even if cache is valid
---@return table[]
local function scan_and_index(cwd, force)
  -- Check cache validity (same directory, less than 30 seconds old)
  local now = vim.uv.now()
  if not force and file_cache.cwd == cwd and file_cache.files and (now - file_cache.mtime) < 30000 then
    return file_cache.files
  end

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

  -- Update cache
  file_cache.cwd = cwd
  file_cache.files = files
  file_cache.mtime = now

  return files
end

--- Compute similarity scores for all files against a query.
--- Uses token cosine similarity as the primary score, with
--- optional zstd compression re-ranking for longer queries.
---@param query string
---@param files table[]
---@return table[]
local function score(query, files)
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
        rel = f.rel,
        path = f.path,
        sim = dot / (qnorm * f.norm),
        content = f.content,
      }
    end
  end

  table.sort(candidates, function(a, b)
    return a.sim > b.sim
  end)

  -- For longer queries, use zstd compression to re-rank top candidates
  if #query >= 30 and #candidates > 0 then
    local top_n = math.min(20, #candidates)
    local cctx = zstd.ZSTD_createCCtx()
    local bound = zstd.ZSTD_compressBound(#query)
    local dst = ffi.new("char[?]", bound)
    local baseline = tonumber(
      zstd.ZSTD_compress(dst, bound, query, #query, 1)
    )
    for i = 1, top_n do
      local c = candidates[i]
      local size = tonumber(zstd.ZSTD_compress_usingDict(
        cctx, dst, bound,
        query, #query,
        c.content, #c.content,
        1
      ))
      local csim = math.max(0, 1 - size / baseline)
      if csim > 0 then
        c.sim = c.sim * 0.5 + csim * 0.5
      end
    end
    zstd.ZSTD_freeCCtx(cctx)
    table.sort(candidates, function(a, b)
      return a.sim > b.sim
    end)
  end

  -- Drop content references before returning
  for _, c in ipairs(candidates) do
    c.content = nil
  end
  return candidates
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

      -- Return async iterator that does scoring inside it
      ---@async
      return function(cb)
        local ranked = score(ctx.filter.search, files)

        -- Limit to top 100 results for faster UI rendering
        local max_results = math.min(100, #ranked)
        for i = 1, max_results do
          local r = ranked[i]
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

--- Clear the file cache to force a rescan on next picker open
function M.clear_cache()
  file_cache.cwd = nil
  file_cache.files = nil
  file_cache.mtime = 0
end

-- CLI mode: nvim -l similar.lua <directory> <query>
if _G.arg and _G.arg[1] then
  local dir = _G.arg[1]
  local query = _G.arg[2]
  if not query then
    print("Usage: nvim -l similar.lua <directory> <query>")
    vim.cmd("cquit 1")
    return M
  end
  dir = vim.fn.fnamemodify(dir, ":p"):gsub("/$", "")
  if vim.fn.isdirectory(dir) == 0 then
    print("Error: " .. dir .. " is not a directory")
    vim.cmd("cquit 1")
    return M
  end
  local files = scan_and_index(dir)
  local ranked = score(query, files)
  local show = math.min(20, #ranked)
  print(string.format(
    'Query: "%s" | %d files | %d matches\n', query, #files, #ranked
  ))
  for i = 1, show do
    print(string.format("  %5.1f%%  %s", ranked[i].sim * 100, ranked[i].rel))
  end
  if #ranked > show then
    print(string.format("\n  ... and %d more", #ranked - show))
  end
end

return M
