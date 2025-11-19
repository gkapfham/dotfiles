-- File: plugins/spelling.lua
-- Purpose: Configure the spelling plugin and
-- the commands that control spelling

return {

  -- Spellrotate
  {
    "tweekmonster/spellrotate.vim",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
      " Configure the spelling files;
      " note that this is not ideal because
      " the Makefile for my dotfiles deletes
      " this directory and then moves comments
      set spellfile+=~/.config/nvim/spell/en.utf-8.add
      set spellfile+=.extra.utf-8.add
      " Correct spelling mistakes from insert mode when typing
      " Reference:
      " https://stackoverflow.com/questions/5312235/how-do-i-correct-vim-spelling-mistakes-quicker
      " Note that this mapping does not seem to work for all filetypes
      inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
      " Disable spell checking by default
      set nospell
      " Set the spell languages for when it is enabled
      set spelllang=en_us,en_gb
      " Enable spell checking for specific filetypes
      augroup enablespell
        autocmd!
        autocmd FileType markdown setlocal spell
        autocmd FileType mail setlocal spell
        autocmd FileType yaml setlocal spell
        autocmd FileType json setlocal spell
      augroup END
      " Disable spell checking in quickfix
      augroup quickfixnospell
        autocmd!
        autocmd FileType qf setlocal nospell
      augroup END
      " Disable spell checking in git
      augroup gitnospell
        autocmd!
        autocmd FileType git setlocal nospell
      augroup END
      ]])
    end,
  },

}
