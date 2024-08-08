require('telescope').setup {
        defaults = {
                file_ignore_patterns = {
                        "node_modules"
                },
                pickers = {



                },
        },
        vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--smart-case',
                '--hidden',
        },
        pickers = {
                find_files = {
                        hidden = true
                },
                grep_string = {
                        additional_args = { "--hidden" }
                },
                live_grep = {
                        additional_args = { "--hidden" }
                },
        },
}

local builtin = require('telescope.builtin')
local find_cmd = { 'rg', '--files', '--hidden', '-g', '!.git' }
vim.keymap.set('n', '<leader>pf',
        function() builtin.find_files({ find_command = find_cmd }) end, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = "grep_string" })
-- require("telescope.builtin").find_files { find_command = { "rg", "--hidden" } }
