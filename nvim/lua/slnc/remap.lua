vim.g.mapleader = " "

-- TODO: decide if I keep using nerdtree or move back to netrw
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- vim.keymap.set('n', 'hs', ':split<CR>', { silent = true })

-- " Make Ctrl-C behave exactly like ESC so that InsertLeave events are fired and
-- " therefore things like multiline insert work well.
vim.api.nvim_set_keymap('i', '<C-c>', '<ESC>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>df', function()
  local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

  if confirm == 1 then
    os.remove(vim.fn.expand "%")
    vim.api.nvim_buf_delete(0, { force = true })
  end
end)

-- vim.api.nvim_add_user_command("CopyRelPath", "call setreg('+', expand('%'))", {})
vim.keymap.set('n', '<leader>cr', function()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('*', filepath)
  vim.fn.setreg('+', filepath)
end, { noremap = true, silent = true })

-- show full file path instead of relative
vim.keymap.set('n', '<C-g>', '1<C-g>', { noremap = true, silent = true })

for i = 1, 9 do
  vim.keymap.set('n', string.format('<leader>%d', i), function()
    vim.cmd(string.format('%dwincmd w', i))
  end, { noremap = true, silent = true })
end

-- Window resizing
vim.keymap.set('n', '<C-Up>', ':resize -3<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize +3<CR>', { silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -5<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +5<CR>', { silent = true })

vim.keymap.set('n', "<C-j>", '<cmd>cnext<CR>')
vim.keymap.set('n', "<C-k>", '<cmd>cprev<CR>')
vim.keymap.set('n', "<C-L>", function()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd('cclose')
      return
    end
  end
  vim.cmd('copen')
end)

-- vim.keymap.set('n', "<leader>t", ':NvimTreeToggle<CR>', { noremap = true, silent = true })
-- NvimTreeFindFile
vim.keymap.set('n', '<leader>t', function()
  local nvim_tree = require('nvim-tree.api')
  if nvim_tree.tree.is_visible() then
    nvim_tree.tree.close()
  else
    vim.cmd('NvimTreeFindFile')
  end
end, { noremap = true, silent = true })

vim.keymap.set('n', "<leader>om", function()
  vim.cmd('silent cd ~/files/projects/obsidian/main')
  vim.cmd('silent ObsidianWorkspace main')
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

vim.api.nvim_set_hl(0, "ExtraWhitespace", { ctermbg = "darkred", bg = "darkred" })
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
  end,
})


vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('trim_whitespaces', { clear = true }),
  desc = 'Trim trailing white spaces',
  pattern = '*',
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      -- Trim trailing whitespaces
      callback = function()
        -- Skip if file path contains "espanso"
        local filepath = vim.api.nvim_buf_get_name(0)
        if string.find(filepath, "espanso") then
          return
        end

        -- Save cursor position to restore later
        local curpos = vim.api.nvim_win_get_cursor(0)
        -- Search and replace trailing whitespaces
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
  end
})


vim.keymap.set('n', '<leader>nu', function()
  local title = vim.fn.input("Title: ")

  if title == "" then
    print("No title entered. Exiting.")
    return
  end

  local file_path = string.format("_unsorted/%s.md", title)
  vim.fn.system(string.format("touch '%s'", file_path))

  vim.cmd("edit " .. file_path)
end, { noremap = true, silent = true })


vim.keymap.set('n', '<leader>nn', function()
  local blogs = os.getenv("MY_BLOGS")
  local options = {}

  for i in blogs:gmatch("%S+") do
    table.insert(options, string.format("%d. %s", #options + 1, i))
  end

  -- TODO: migrate to floating windows https://neovim.io/doc/user/api.html
  local selected = vim.fn.inputlist(vim.list_extend({ "Select a domain:" }, options))

  if selected == 0 then
    print("No option selected. Exiting.")
    return
  end

  local domain = options[selected]:match("%d+%.%s(.+)")

  local title = vim.fn.input("Title: ")
  if title == "" then
    print("No title entered. Exiting.")
    return
  end

  local file_path = string.format("Projects/%s/Notes/%s.md", domain, title)
  vim.fn.system(string.format("touch '%s'", file_path))

  vim.cmd("edit " .. file_path)

  -- print("File created: " .. file_path)
end, { noremap = true, silent = true })



local function update_md_preamble()
  local file_path = vim.fn.expand('%:p')
  local file_name = vim.fn.expand('%:t:r')

  local home_dir = vim.loop.os_homedir()
  file_path = "~" .. file_path:sub(#home_dir + 1)

  -- Check if the file is in the specified paths
  local allowed_paths = {
    -- Add your allowed paths here, e.g.:
    ["~/files/projects/obsidian/main/Work/slnc.net/notes"] = true,
    ["~/files/projects/obsidian/main/Work/juanalonso.net/notes"] = true,
    ["~/files/projects/obsidian/main/Work/juan.al"] = true,
    ["~/files/projects/obsidian/main/Work/juan.yoga/notes"] = true,
  }

  local dir_path = file_path:match("(.*/)")
  if not allowed_paths[dir_path:sub(1, -2)] then -- non-blog .md
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local preamble_start, preamble_end = 0, 0

  for i, line in ipairs(lines) do
    if line == "---" then
      if preamble_start == 0 then
        preamble_start = i
      else
        preamble_end = i; break
      end
    end
  end

  if preamble_start == 0 or preamble_end == 0 then return end

  local preamble = {}
  local current_time = os.date("%Y-%m-%dT%H:%M:%S+0200")

  for i = preamble_start + 1, preamble_end - 1 do
    local key, value = lines[i]:match("^(%w+):%s*(.*)$")
    if key then
      if key == "title" then
        value = file_name
      elseif key == "lastmod" then
        value = current_time
      elseif key == "url" then
        value = "/" .. string.lower(file_name):gsub("%s+", "-") .. "/"
      end
      preamble[i - preamble_start] = string.format("%s: %s", key, value)
    end
  end
  table.insert(preamble, "---")

  vim.api.nvim_buf_set_lines(0, preamble_start, preamble_end, false, preamble)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = update_md_preamble
})

vim.keymap.set('n', '<leader>tod', function()
  local current_year = os.date("%Y")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>om", true, false, true), 'n', false)
  local fp = string.format("~/files/projects/obsidian/main/Bins/Logs/%s/daily/%s.md", current_year, os.date("%Y-%m-%d"))
  vim.cmd(string.format('e %s', fp))
end, { noremap = true, silent = true })

local function confirm_and_delete_buffer()
end

vim.keymap.set('n', '<leader>df', function()
  local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

  if confirm == 1 then
    os.remove(vim.fn.expand "%")
    vim.api.nvim_buf_delete(0, { force = true })
  end
end)


vim.keymap.set("n", "<leader>ct", function()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  local func_name = nil

  while node do
    if node:type() == "function_declaration" then
      local name_node = node:field("name")[1]
      func_name = vim.treesitter.get_node_text(name_node, 0)
      break
    end
    node = node:parent()
  end

  if not func_name or not func_name:match("^Test") then return end

  local file = vim.api.nvim_buf_get_name(0)
  if not file:match("_test%.go$") then return end

  local pkg = vim.fn.fnamemodify(file, ":h:.")
  local cmd = string.format("DEBUG=1 ENV_FILE=.env.test go test -run ^%s$ ./%s/...", func_name, pkg)
  vim.fn.setreg("+", cmd)
end, { desc = "Copy go test command for current Test function" })
