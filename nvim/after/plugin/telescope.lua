local lga_actions = require("telescope-live-grep-args.actions")
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
  -- TODO: find out why the mappings don't work
  -- extensions = {
  --   live_grep_args = {
  --     auto_quoting = true, -- enable/disable auto-quoting
  --     -- define mappings, e.g.
  --     mappings = {         -- extend mappings
  --       i = {
  --         ["<C-k>"] = lga_actions.quote_prompt(),
  --         ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
  --         -- freeze the current list and start a fuzzy search in the frozen list
  --         ["<C-space>"] = lga_actions.to_fuzzy_refine,
  --       },
  --     },
  --     -- ... also accepts theme settings, for example:
  --     -- theme = "dropdown", -- use dropdown theme
  --     -- theme = { }, -- use own theme spec
  --     -- layout_config = { mirror=true }, -- mirror preview pane
  --   }
  -- }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', function()
  builtin.find_files()
end, {})
vim.keymap.set("n", "<leader>of", builtin.oldfiles, {})
-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
vim.keymap.set("n", "<leader>lg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set("n", "<leader>rlg", require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" })
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set('n', '<leader>gs', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "grep_string" })
