local hostname = io.popen("hostname"):read("*l")
local should_be_lazy = hostname ~= "mbpro2019" and hostname ~= "bindan"

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = should_be_lazy,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    ui = {
      enable = false
    },
    disable_frontmatter = true,
    workspaces = {
      {
        name = "dnd",
        path = "~/files/projects/obsidian/dnd",
      },
      {
        name = "main",
        path = "~/files/projects/obsidian/main",
      },
      {
        name = "ljbrain",
        path = "~/files/projects/obsidian/ljbrain",
      },
    },

    -- see below for full list of options 👇
    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
    },
  },
}
