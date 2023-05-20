-- Work with Quarto files
return {

  {
    'quarto-dev/quarto-nvim',
    event = "BufReadPost",
    dependencies = {
        { 'hrsh7th/nvim-cmp'  },
        { 'jmbuhr/otter.nvim' },
    },
    config = function()
        require('quarto').setup {
            closePreviewOnExit = true,
            lspFeatures = {
                enabled = true,
                languages = { 'r', 'python', 'bash' },
                chunks = 'curly',
                diagnostics = {
                    enabled = true,
                    triggers = { "BufWritePost" }
                },
                completion = {
                    enabled = true
                }
            }
        }
        -- Function to open Quarto Preview in a buffer instead of a tab
        vim.cmd [[
            function! QuartoPreview()
                :w!
                :terminal quarto preview %:p --to html
                :call feedkeys('<Esc>')
                :bprev
            endfunction
        ]]
        vim.keymap.set('n', '<localleader>P', ':call QuartoPreview() <CR>')
    end
  },

  -- send code from python/r/qmd documets to a terminal or REPL
  -- like ipython, R, bash
  {
    'jpalardy/vim-slime',
    init = function()
      Quarto_is_in_python_chunk = function()
        require 'otter.tools.functions'.is_otter_language_context('python')
      end

      vim.cmd [[
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk
      return ["%cpaste -q", "\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      return a:text
      end
      endfunction
      ]]

      local function mark_terminal()
        vim.g.slime_last_channel = vim.b.terminal_job_id
        vim.print(vim.g.slime_last_channel)
      end

      local function set_terminal()
        vim.b.slime_config = { jobid = vim.g.slime_last_channel }
      end

      vim.b.slime_cell_delimiter = "#%%"

      -- slime, neovvim terminal
      vim.g.slime_target = "neovim"
      vim.g.slime_python_ipython = 1

      -- -- slime, tmux
      -- vim.g.slime_target = 'tmux'
      -- vim.g.slime_bracketed_paste = 1
      -- vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }

      local function toggle_slime_tmux_nvim()
        if vim.g.slime_target == 'tmux' then
          pcall(function()
            vim.b.slime_config = nil
            vim.g.slime_default_config = nil
          end
          )
          -- slime, neovvim terminal
          vim.g.slime_target = "neovim"
          vim.g.slime_bracketed_paste = 0
          vim.g.slime_python_ipython = 1
        elseif vim.g.slime_target == 'neovim' then
          pcall(function()
            vim.b.slime_config = nil
            vim.g.slime_default_config = nil
          end
          )
          -- -- slime, tmux
          vim.g.slime_target = 'tmux'
          vim.g.slime_bracketed_paste = 1
          vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }
        end
      end

      -- require 'which-key'.register({
      --   ['<leader>cm'] = { mark_terminal, 'mark terminal' },
      --   ['<leader>cs'] = { set_terminal, 'set terminal' },
      --   ['<leader>ct'] = { toggle_slime_tmux_nvim, 'toggle tmux/nvim terminal' },
      -- })

    end
  },

  -- paste an image to markdown from the clipboard
  -- :PasteImg,
  { 'ekickx/clipboard-image.nvim' },

}
