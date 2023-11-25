-- File: plugins/quarto.lua
-- Purpose: Configure the plugins that
-- enable the editing of a .qmd file
-- with full support from language servers

return {

    -- quarto-nvim and otter.nvim
    {
        'quarto-dev/quarto-nvim',
        event = "BufReadPost",
        dependencies = {
            { 'hrsh7th/nvim-cmp' },
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
            -- open Quarto Preview in a buffer instead of a tab
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
