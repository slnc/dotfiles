vim.opt.guicursor      = ""

vim.opt.nu             = true
vim.opt.relativenumber = true

vim.opt.tabstop        = 2
vim.opt.softtabstop    = 2
vim.opt.expandtab      = true

vim.opt.smartindent    = false

vim.opt.wrap           = false

vim.opt.conceallevel   = 0

vim.opt.swapfile       = false
vim.opt.backup         = false
vim.opt.undodir        = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile       = true

vim.opt.hlsearch       = true
vim.opt.incsearch      = true

vim.opt.termguicolors  = true

vim.opt.laststatus     = 0
vim.opt.statusline     = [[ %1*%{winnr()} %*%< %f %h%m%r%=%l,%c%V (%P) ]]
vim.opt.statusline     = " " -- [[ %1*%{winnr()} %*%< %f %h%m%r%=%l,%c%V (%P) ]]

vim.opt.listchars      = {
  tab = '>·',
  trail = '󱁐',
}
vim.opt.showmatch      = true -- when inserting a bracket, briefly jump to matching one
vim.opt.matchtime      = 1    -- tenths of a sec

vim.opt.shiftwidth     = 2
vim.opt.shortmess      = "atIoO"

vim.opt.scrolloff      = 3
vim.opt.signcolumn     = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.updatetime = 1000

vim.opt.colorcolumn = "81"
vim.opt.visualbell = true

vim.opt.winbar = "%m %f"
