return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
    { 'nvim-lua/plenary.nvim' },
  },
  config = function()
    local telescope = require("telescope")

    -- Lua patterns for filtering results (applied by Telescope)
    local file_ignore_patterns = {
      "%.egg%-info",
      "%.pyc$",
      "%.git/",
      "%.trash/",
      "%.venv/",
      "__pycache__/",
      "node_modules/",
      "%.dvc/"
    }

    -- Ripgrep glob args for find_files command
    local rg_glob_args = {
      "-g", "!*.egg-info",
      "-g", "!*.pyc",
      "-g", "!.git",
      "-g", "!.trash",
      "-g", "!.venv",
      "-g", "!__pycache__",
      "-g", "!node_modules",
      "-g", "!.dvc"
    }

    -- first setup telescope
    telescope.setup({
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
          find_command = vim.list_extend({ 'rg', '--files', '--hidden' }, rg_glob_args)
        },
        grep_string = {
          additional_args = vim.list_extend({ "--hidden", "--smart-case" }, rg_glob_args)
        },
        live_grep = {
          additional_args = vim.list_extend({ "--hidden", "--smart-case" }, rg_glob_args)
        },
      },
    })

    -- then load the extension
    telescope.load_extension("live_grep_args")

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>f', function()
      builtin.find_files()
    end, {})
    vim.keymap.set("n", "<leader>gf", builtin.git_status, {})
    -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
    vim.keymap.set("n", "<leader>lg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    vim.keymap.set("n", "<leader>of", builtin.oldfiles, {})
    vim.keymap.set("n", "<leader>rl", require("telescope.builtin").resume,
      { noremap = true, silent = true, desc = "Resume" })
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set("x", "<leader>p", [["_dP]])
    vim.keymap.set('n', '<leader>gs', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "grep_string" })
  end
}
