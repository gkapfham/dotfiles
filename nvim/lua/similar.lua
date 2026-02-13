-- File: similar.lua
-- Purpose: compression-based text similarity search as a snacks picker.
-- Works like live grep but ranks files by how well their content
-- compresses the query, using zstd dictionary compression via LuaJIT FFI.

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

local function compress_with_dict(cctx, query, dict)
  local bound = zstd.ZSTD_compressBound(#query)
  local dst = ffi.new("char[?]", bound)
  local result = zstd.ZSTD_compress_usingDict(cctx, dst, bound, query, #query, dict, #dict, 1)
  if zstd.ZSTD_isError(result) ~= 0 then
    return #query
  end
  return tonumber(result)
end

local function compress_baseline(query)
  local bound = zstd.ZSTD_compressBound(#query)
  local dst = ffi.new("char[?]", bound)
  local result = zstd.ZSTD_compress(dst, bound, query, #query, 1)
  if zstd.ZSTD_isError(result) ~= 0 then
    return #query
  end
  return tonumber(result)
end

--- Read all text files under cwd into memory.
--- Must be called in normal context (not async).
---@param cwd string
---@return { path: string, rel: string, content: string }[]
local function scan_files(cwd)
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
            files[#files + 1] = {
              path = filepath,
              rel = filepath:sub(#cwd + 2),
              content = data,
            }
          end
        end
      end
    end
  end
  return files
end

--- Open the similarity picker, optionally with initial search text.
---@param initial_search? string
function M.pick(initial_search)
  local cwd = vim.uv.cwd() or "."
  local files = scan_files(cwd)
  Snacks.picker({
    title = string.format("Similar Files (%d files)", #files),
    finder = function(_, ctx)
      if ctx.filter.search == "" then
        return function() end
      end
      local query = ctx.filter.search
      local baseline = compress_baseline(query)
      local cctx = zstd.ZSTD_createCCtx()
      local ranked = {}
      for _, f in ipairs(files) do
        local size = compress_with_dict(cctx, query, f.content)
        local sim = math.max(0, 1 - size / baseline)
        if sim > 0 then
          ranked[#ranked + 1] = { rel = f.rel, path = f.path, sim = sim }
        end
      end
      zstd.ZSTD_freeCCtx(cctx)
      table.sort(ranked, function(a, b)
        return a.sim > b.sim
      end)
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
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  local text = table.concat(lines, " ")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  M.pick(text)
end

return M
