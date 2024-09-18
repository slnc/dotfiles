local hostname = io.popen("hostname"):read("*l")
local drivers = {
  ["mbpro2019j.local"] = true,
  ["mbpro2019j"] = true,
  ["codex"] = true,
  ["bindan"] = true,
}

if not drivers[hostname] then
  return {}
end

local current_year = os.date("%Y")

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

    daily_notes = {
      folder = string.format("Bins/Logs/%s/daily", current_year),
      date_format = "%Y-%m-%d",
    },

    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
    },
  },
}
