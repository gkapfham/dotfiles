-- File: plugins/tagmanagement.lua
-- Purpose: generate, save, and use tags;
-- note that other plugins like telescope
-- use these automatically generated tags

return {

  -- Gutentags;
  -- This works correctly for most files;
  -- yet, it does not work for Quarto markdown
  -- files and other "non-standard file types"
  {
    "ludovicchabant/vim-gutentags",
    event = "BufReadPre",
    config = function()
      vim.g.gutentags_ctags_exclude = {
        '*.git', '*.svg', '*.hg',
        'build',
        'dist',
        '*sites/*/files/*',
        'bin',
        'node_modules',
        'bower_components',
        'cache',
        'compiled',
        'docs',
        'example',
        'bundle',
        'vendor',
        '*-lock.json',
        '*.lock',
        '*bundle*.js',
        '*build*.js',
        '.*rc*',
        '*.json',
        '*.min.*',
        '*.map',
        '*.bak',
        '*.zip',
        '*.pyc',
        '*.class',
        '*.sln',
        '*.Master',
        '*.csproj',
        '*.tmp',
        '*.csproj.user',
        '*.cache',
        '*.pdb',
        'tags*',
        'cscope.*',
        '*.exe', '*.dll',
        '*.mp3', '*.ogg', '*.flac',
        '*.swp', '*.swo',
        '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
        '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
        '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      }
      vim.g.gutentags_add_default_project_roots = false
      vim.g.gutentags_project_root = { 'package.json', '.git' }
      vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/ctags/')
      vim.g.gutentags_generate_on_new = true
      vim.g.gutentags_generate_on_missing = true
      vim.g.gutentags_generate_on_write = true
      vim.g.gutentags_generate_on_empty_buffer = true
      vim.g.gutentags_file_list_command = "rg --files"
    end,
  },

}
