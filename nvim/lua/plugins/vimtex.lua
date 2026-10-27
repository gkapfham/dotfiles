-- File: plugins/vimtex.lua
-- Purpose: configure LaTeX editing support: plugins for tex files plus a
-- standalone forward synctex search that replaces the vimtex viewer feature

-- Note about error in vimtex workflow:
-- (1) Open LaTeX main document in nvim
-- (2) Start to compile the document with ,ll
-- (3) Zathura opens the document correctly
-- (4) Make a single change to the document
-- (5) Error: Zathura closes the document
-- (6) Start the preview of document with ,lv
-- (7) Zathura opens document correctly
-- All remaining edits now work correctly
-- Same error is evident if running latexmk separately

-- ============================================================================
-- Standalone forward synctex search
--
-- The vimtex plugin is no longer compatible with the installed version of
-- Neovim, so the plugin itself is disabled (see the commented-out
-- configuration below). This standalone implementation preserves the one
-- feature that is still used: forward synctex search. Pressing ,lv (i.e.
-- <localleader>lv) while editing a .tex file makes Zathura jump to (and
-- highlight) the PDF location that corresponds to the current cursor line in
-- Neovim.
--
-- How it works: Zathura reads the .synctex.gz file that is generated next to
-- the PDF when the document is compiled with synctex support. The command
--
--   zathura --synctex-forward=LINE:COL:SOURCE.TEX FILE.pdf
--
-- asks Zathura (over D-Bus) to perform the search in the already-running
-- instance that has FILE.pdf open; if no instance has the PDF open, Zathura
-- opens the PDF in a new instance.
--
-- A %!TEX root directive (e.g. "%!TEX root =./paper.tex") is honored, so
-- forward search works from \input-ed subfiles: the directive names the main
-- document whose PDF (same directory, same basename) is used.
--
-- Requirements:
--   * The document must be compiled with synctex support, e.g.
--     latexmk -pdf -synctex=1 paper.tex
--   * The PDF must live next to the main .tex file with the same basename
--   * The command and keymap are only registered when a .tex file is opened;
--     nothing is set up at Neovim startup
-- ============================================================================

-- Scan the given lines for a %!TEX root directive that names the main
-- document. Returns the declared path (with trailing whitespace stripped)
-- or nil.
local function find_root_in_lines(lines)
  for _, line in ipairs(lines) do
    local root = line:match("^%%%s*!%s*[Tt][Ee]?[Xx]%s+root%s*=%s*(%S+)")
    if root ~= nil then
      return root:gsub("%s+$", "")
    end
  end
  return nil
end

-- Scan the current buffer for a %!TEX root directive. The whole buffer is
-- scanned so that unsaved changes and unusual placements are honored.
local function find_root_in_buffer()
  return find_root_in_lines(vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

-- Scan the first lines of the given file for a %!TEX root directive.
local function find_root_in_file(file)
  local lines = vim.fn.readfile(file, "", 100)
  if lines == nil then
    return nil
  end
  return find_root_in_lines(lines)
end

-- True if the given .tex file \input or \include the given basename, with or
-- without a path prefix (e.g. \input{sections/conclusions}).
local function file_includes(file, base)
  local lines = vim.fn.readfile(file)
  if lines == nil then
    return false
  end
  for _, line in ipairs(lines) do
    if line:match("\\[Ii]nput%s*%{.*" .. base .. "[.}]")
      or line:match("\\[Ii]nclude%s*%{.*" .. base .. "[.}]") then
      return true
    end
  end
  return false
end

-- Resolve a %!TEX root path against the given base file to an existing
-- absolute file. The path is tried relative to the directory of the file
-- containing the directive, then relative to the working directory (some
-- editors write root paths relative to the project root), and finally by
-- walking upward from the base directory.
local function resolve_root(root, basefile)
  local candidates = {
    vim.fs.normalize(vim.fs.dirname(basefile) .. "/" .. root),
    vim.fs.normalize(vim.fn.getcwd() .. "/" .. root),
  }
  local parent = vim.fs.dirname(basefile)
  while vim.fs.dirname(parent) ~= parent do
    table.insert(candidates, vim.fs.normalize(parent .. "/" .. root))
    parent = vim.fs.dirname(parent)
  end
  for _, candidate in ipairs(candidates) do
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
    -- Allow a root path that omits the .tex extension
    if not vim.endswith(candidate, ".tex") and vim.fn.filereadable(candidate .. ".tex") == 1 then
      return candidate .. ".tex"
    end
  end
  return nil
end

-- Find the main document for the current .tex buffer. A %!TEX root directive
-- in the buffer is used if present. Otherwise the buffer's directory and its
-- parents are searched for a .tex file that declares a %!TEX root directive
-- or that \input/\include the current file; the first such file is treated
-- as the main document. Returns the absolute main .tex path or nil.
local function find_main_tex(texfile)
  local base = vim.fs.basename(texfile):gsub("%.tex$", "")
  local dir = vim.fs.dirname(texfile)
  while true do
    for _, file in ipairs(vim.fn.glob(dir .. "/*.tex", false, true)) do
      if vim.fs.normalize(file) ~= texfile then
        local other_root = find_root_in_file(file)
        if other_root ~= nil then
          local resolved = resolve_root(other_root, file)
          if resolved ~= nil then
            return resolved
          end
        elseif file_includes(file, base) then
          return file
        end
      end
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

-- Locate the PDF compiled from the main document of the current .tex buffer.
-- Returns the absolute PDF path or nil plus an error message.
local function find_pdf()
  local texfile = vim.api.nvim_buf_get_name(0)
  if texfile == "" or not vim.endswith(texfile, ".tex") then
    return nil, "current buffer is not a .tex file"
  end
  -- Use the %!TEX root directive when present so that forward search from an
  -- \input-ed subfile maps to the root document; otherwise discover the main
  -- file from the project structure, falling back to the current buffer.
  local root_tex = nil
  local declared = find_root_in_buffer()
  if declared ~= nil then
    root_tex = resolve_root(declared, texfile)
    if root_tex == nil then
      return nil, string.format("%%!TEX root cannot be resolved: %s", declared)
    end
  else
    root_tex = find_main_tex(texfile) or texfile
  end
  local pdffile = root_tex:gsub("%.tex$", ".pdf")
  if not vim.endswith(pdffile, ".pdf") then
    pdffile = pdffile .. ".pdf"
  end
  if vim.fn.filereadable(pdffile) == 0 then
    return nil, string.format("PDF not found: %s (compile the document first)", pdffile)
  end
  local synctexfile = pdffile:gsub("%.pdf$", ".synctex.gz")
  if vim.fn.filereadable(synctexfile) == 0 then
    return nil, string.format("synctex data not found: %s (compile with -synctex=1)", synctexfile)
  end
  return pdffile
end

-- Perform the forward synctex search for the current cursor position.
local function forward_search()
  if vim.fn.executable("zathura") == 0 then
    vim.notify("Synctex: the zathura program is not installed", vim.log.levels.WARN)
    return
  end
  local pdffile, err = find_pdf()
  if pdffile == nil then
    vim.notify("Synctex: " .. err, vim.log.levels.WARN)
    return
  end
  -- The line and column are 1-indexed, as required by synctex, and the
  -- character column is used because synctex positions are character based.
  -- The input file is the current buffer: synctex maps the cursor position of
  -- whichever file is being edited (the root or an \input-ed subfile).
  local position = string.format(
    "%d:%d:%s",
    vim.fn.line("."),
    vim.fn.charcol("."),
    vim.api.nvim_buf_get_name(0)
  )
  vim.fn.jobstart(
    { "zathura", "--synctex-forward=" .. position, pdffile },
    { detach = true }
  )
end

-- Register the buffer-local command and keymap for the forward synctex search
-- in the given buffer. The keybinding ,lv is the default vimtex mapping for
-- this feature. Both only exist inside .tex buffers.
local function setup(bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "SynctexForward", forward_search, {
    force = true,
    desc = "Forward synctex search: jump to the current line in Zathura",
  })
  vim.keymap.set("n", "<localleader>lv", "<cmd>SynctexForward<CR>", {
    buffer = bufnr,
    desc = "Forward synctex search: jump to the current line in Zathura",
  })
end

-- Defer all registration until a .tex file is actually opened, so that this
-- feature costs nothing at Neovim startup. Both the tex and plaintex
-- filetypes are covered: Neovim detects a .tex file without LaTeX markers as
-- plaintex, while the sentence-chopper setup above forces plaintex to tex.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function(args)
    setup(args.buf)
  end,
})

return {

  -- vim-sentence-chopper
  -- Break up paragraphs in LaTeX
  {
    ft = "tex",
    "Konfekt/vim-sentence-chopper",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        autocmd BufNewFile,BufRead *.tex set filetype=tex
        " Disable syntax highlighting provided by vimtex plugin
        let g:vimtex_syntax_enabled = 0
        " Conceal option
        set conceallevel=1
        let g:tex_conceal='abdmgs'
        " Use tex over plaintex
        let g:tex_flavor = 'tex'
        " Required by the vimtex plugin
        set hidden
        " Use latexindent to break up paragraphs
        " This yields commands like "grip" for formatting with latexindent
        " It is still possible to use commands like "gwip" for paragraph formatting
        nmap gr <plug>(ChopSentences)
        xmap gr <plug>(ChopSentences)
        " Pass options to latexindent
        " Note that latexindent will reference the ~/.indentconfig.yaml
        " file which will point to the ~/.chopsentences.yaml file
        " let g:latexindent_options = '-m -r'
        " Do not use a space after the comment string symbol in LaTeX
        augroup latexcomments
        autocmd!
        autocmd FileType tex setlocal commentstring=%%s
        augroup END
        ]])
    end,
  },

  -- -- vimtex
  -- -- Support compilation and forward search
  -- -- using Zathura (which I cannot get to
  -- -- work through the exclusive use of the
  -- -- texlab language server)
  -- {
  --   "lervag/vimtex",
  --   event = "InsertEnter",
  --   ft = "tex",
  --   config = function()
  --     vim.cmd([[
  --       autocmd BufNewFile,BufRead *.tex set filetype=tex
  --       " Configure vimtex
  --       let g:vimtex_syntax_enabled = 0
  --       " --> Do not fold
  --       let g:vimtex_fold_enabled = 0
  --       " --> Do not open quickfix for warnings
  --       let g:vimtex_quickfix_open_on_warning = 0
  --       " --> Do not show the help message
  --       " let g:vimtex_index_show_help = 0
  --       " --> Use zathura for the PDF viewer
  --       " let g:vimtex_view_method = 'sioyek'
  --       let g:vimtex_view_method = 'zathura'
  --       " --> Use the nvr program (Neovim-remote)
  --       "     to facilitate communication between
  --       "     Neovim and the Zathura PDF viewer
  --       let g:vimtex_compiler_progname = 'nvr'
  --       " Configure the latexmk compiler; especially
  --       " turning off the callback as this seems to
  --       " generate error messages when compiling
  --       " and using the zathura program.
  --       let g:vimtex_compiler_latexmk = {
  --       \ 'build_dir' : '',
  --       \ 'callback' : 0,
  --       \ 'continuous' : 1,
  --       \ 'executable' : 'latexmk',
  --       \ 'hooks' : [],
  --       \ 'options' : [
  --       \   '-verbose',
  --       \   '-file-line-error',
  --       \   '-synctex=1',
  --       \   '-interaction=nonstopmode',
  --       \ ],
  --       \}
  --       " Define mapping to generate and view the table of contents
  --       " nnoremap <leader>lt :VimtexTocToggle<cr>
  --       " Define mapping to run a "single-shot" compilation
  --       " Note that this is especially useful when the LaTeX
  --       " document requires a long background compilation
  --       " that is so expensive to always run that if limits
  --       " the ability to use the text editor interactively
  --       " nnoremap <Space>ll :VimtexCompileSS<cr>
  --       " Disable syntax highlighting provided by vimtex plugin
  --       let g:vimtex_syntax_enabled = 0
  --       " Conceal option
  --       set conceallevel=1
  --       let g:tex_conceal='abdmgs'
  --       " Use tex over plaintex
  --       let g:tex_flavor = 'tex'
  --       " Required by the vimtex plugin
  --       set hidden
  --       " Use latexindent to break up paragraphs
  --       " This yields commands like "grip" for formatting with latexindent
  --       " It is still possible to use commands like "gwip" for paragraph formatting
  --       nmap gr <plug>(ChopSentences)
  --       xmap gr <plug>(ChopSentences)
  --       " Pass options to latexindent
  --       " Note that latexindent will reference the ~/.indentconfig.yaml
  --       " file which will point to the ~/.chopsentences.yaml file
  --       " let g:latexindent_options = '-m -r'
  --       " Do not use a space after the comment string symbol in LaTeX
  --       augroup latexcomments
  --       autocmd!
  --       autocmd FileType tex setlocal commentstring=%%s
  --       augroup END
  --       ]])
  --   end,
  --   keys = {
  --     { "<Space>ll", "<cmd> VimtexCompileSS <CR>", desc = "Vimtex: Single-shot Compile" },
  --   },
  -- },
}
