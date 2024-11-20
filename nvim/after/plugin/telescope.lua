require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".venv",
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
      additional_args = { "--hidden", "--smart-case", "-f", "!.git", "-f", "!.venv", "-f", "!.trash" }
    },
    live_grep = {
      additional_args = { "--hidden", "--smart-case" }
    },
  },
}

local builtin = require('telescope.builtin')
local find_cmd = { 'rg', '--files', '--hidden', '-g', '!.git', "-f", "!.venv", '-g', '!.trash' }
vim.keymap.set('n', '<leader>f',
  function() builtin.find_files({ find_command = find_cmd }) end, {})
vim.keymap.set("n", "<leader>of", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set("x", "<leader>p", [["_dP]]) -- del to blackhole register, then paste default register
vim.keymap.set('n', '<leader>gs', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = "grep_string" })
-- require("telescope.builtin").find_files { find_command = { "rg", "--hidden" } }
