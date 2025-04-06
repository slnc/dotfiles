local file_ignore_patterns = {
  "-g", "!node_modules",
  "-g", "!.venv",
  "-g", "!.git",
  "-g", "!.trash",
  "-g", "!*.egg-info",
  "-g", "!*.pyc",
  "-g", "!__pycache__",
  "-g", "!.dvc"
}

require('telescope').setup {
  defaults = {
    file_ignore_patterns = file_ignore_patterns,
    pickers = {},
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
      hidden = true,
      find_command = vim.list_extend({ 'rg', '--files', '--hidden' }, file_ignore_patterns)
    },
    grep_string = {
      additional_args = vim.list_extend({ "--hidden", "--smart-case" }, file_ignore_patterns)
    },
    live_grep = {
      additional_args = vim.list_extend({ "--hidden", "--smart-case" }, file_ignore_patterns)
    },
  },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', function()
  builtin.find_files()
end, {})
vim.keymap.set("n", "<leader>of", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set('n', '<leader>gs', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "grep_string" })
