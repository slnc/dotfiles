require('telescope').setup{
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
}

-- require("telescope.builtin").find_files { find_command = { "rg", "--hidden" } }

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}) end, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
