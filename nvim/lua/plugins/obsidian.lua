local hostname = io.popen("hostname"):read("*l")
local drivers = {
  ["codex"] = true,
  ["mbpro2019j"] = true,
  ["mbpro2019j.local"] = true,
  ["phobos"] = true,
}

if not drivers[hostname] then
  return {}
end

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = "false",
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
    "nvim-lua/plenary.nvim",
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
        name = "ljbrain",
        path = "~/files/projects/obsidian/ljbrain",
      },
      {
        name = "main",
        path = "~/files/projects/obsidian/main",
      },
    },

    daily_notes = {
      folder = string.format("Bins/Logs/%s/daily", os.date("%Y")),
      date_format = "%Y-%m-%d",
    },

    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
    },
  },
}
