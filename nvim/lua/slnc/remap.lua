vim.g.mapleader = " "

-- TODO: decide if I keep using nerdtree or move back to netrw
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- vim.keymap.set('n', 'hs', ':split<CR>', { silent = true })
