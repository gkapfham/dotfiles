-- File: plugins/quarto.lua
-- Purpose: Configure the plugins that
-- enable the editing of a .qmd file
-- with full support from language servers

return {

    -- molten-nvim
    {
        "benlubas/molten-nvim",
        event = "VeryLazy",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        build = ":UpdateRemotePlugins",
        config = function()
            vim.g.molten_output_win_max_height = 12
            vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
                { desc = "evaluate operator", silent = true })
            vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>",
                { desc = "open output window", silent = true })
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
        end,
    },

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
                    },
                },
                codeRunner = {
                    enabled = true,
                    default_method = "molten",
                },
            }
            -- set keymaps for running code cells; this
            -- relies on the existence and configuration
            -- of molten as the quarto runner
            local runner = require("quarto.runner")
            vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
            vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
            vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
            vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
            vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
            vim.keymap.set("n", "<localleader>RA", function()
                runner.run_all(true)
            end, { desc = "run all cells of all languages", silent = true })
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
            -- make pyodide use the treesitter parser for python
            vim.treesitter.language.register("python", "pyodide")
        end
    },

}
