-- File: plugins/spelling.lua
-- Purpose: Configure the spelling plugin and
-- the commands that control spelling

return {

  -- Spellrotate
  {
    "tweekmonster/spellrotate.vim",
    event = "BufReadPre",
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
      " Enable spell checking with two dictionaries
      set spell spelllang=en_us,en_gb
      " Disable spell checking in source code
      au BufNewFile,BufRead,BufEnter *.c      set nospell
      au BufNewFile,BufRead,BufEnter *.h      set nospell
      au BufNewFile,BufRead,BufEnter *.cpp    set nospell
      au BufNewFile,BufRead,BufEnter *.hpp    set nospell
      au BufNewFile,BufRead,BufEnter *.java   set nospell
      au BufNewFile,BufRead,BufEnter *.py     set nospell
      au BufNewFile,BufRead,BufEnter *.sh     set nospell
      au BufNewFile,BufRead,BufEnter *.xml    set nospell
      au BufNewFile,BufRead,BufEnter *.sql    set nospell
      au BufNewFile,BufRead,BufEnter *.bib    set nospell
      au BufNewFile,BufRead,BufEnter *.lua    set nospell
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
