-- vim.g.mapleader set in lua/config/lazy.lua

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

-- Window resizing (smart resize based on window position)
-- resize commands are absolute: they always increase or decrease window size in same dir.
-- I want semantics: C-Up always makes window smaller, C-Down regardless of which
--   window you're in.

--  Here's what's happening:
--  - Top window: C-Up (:resize -3) makes it smaller ✓
--  - Bottom window: C-Up (:resize -3) still makes the bottom window smaller (which means making the top window bigger) ✗

vim.keymap.set('n', '<C-Up>', function()
  if vim.fn.winnr() == vim.fn.winnr('k') then
    vim.cmd('resize -3')
  else
    vim.cmd('resize +3')
  end
end, { silent = true })

vim.keymap.set('n', '<C-Down>', function()
  if vim.fn.winnr() == vim.fn.winnr('k') then
    vim.cmd('resize +3')
  else
    vim.cmd('resize -3')
  end
end, { silent = true })

vim.keymap.set('n', '<C-Left>', function()
  if vim.fn.winnr() == vim.fn.winnr('h') then
    vim.cmd('vertical resize -5')
  else
    vim.cmd('vertical resize +5')
  end
end, { silent = true })

vim.keymap.set('n', '<C-Right>', function()
  if vim.fn.winnr() == vim.fn.winnr('h') then
    vim.cmd('vertical resize +5')
  else
    vim.cmd('vertical resize -5')
  end
end, { silent = true })

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


vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

vim.api.nvim_set_hl(0, "ExtraWhitespace", { ctermbg = "darkred", bg = "darkred" })
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
  end,
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)


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

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "vim.lsp.buf.definition()" })
-- nowait needed because of neovim's 0.11's gr* defaults
vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, { desc = "vim.lsp.buf.references()", nowait = true })
