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
        -- Open Quarto Preview in a buffer instead of a tab
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

}
