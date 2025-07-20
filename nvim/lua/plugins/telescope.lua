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

    -- first setup telescope
    telescope.setup({
      -- your config
    })

    -- then load the extension
    telescope.load_extension("live_grep_args")
  end
}
