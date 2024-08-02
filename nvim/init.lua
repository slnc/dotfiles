-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour (taken from nvim-tree)
vim.opt.termguicolors = true


-- TODO: do I need these?
-- set runtimepath^=~/.vim runtimepath+=~/.vim/after
-- let &packpath = &runtimepath
-- source ~/.vimrc

require("slnc")
require("config.lazy")
