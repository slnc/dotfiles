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
-- vim.opt.laststatus     = 2
-- vim.opt.statusline     = [[ %1*%{winnr()} %*%< %f %h%m%r%=%l,%c%V (%P) ]]
vim.opt.statusline     = " "

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

vim.opt.winbar = " %{winnr()} %< %f %h%m%r%=%l,%c%V (%P)"

-- Clipboard / copy-paste
-- vim.opt.clipboard = "unnamedplus"
-- Copy to system clipboar only on yanking, not cutting or replacing
vim.keymap.set({ 'n', 'v' }, 'y', '"+y', { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.colorcolumn = "100"
  end,
})


local function flicker_current_line()
  if vim.bo.buftype ~= "" then return end
  vim.wo.cursorline = true
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(0) and vim.bo.buftype == "" then
      vim.wo.cursorline = false
    end
  end, 350)
end


-- local function flicker_current_line()
--   vim.wo.cursorline = true
--   vim.defer_fn(function()
--     vim.wo.cursorline = false
--   end, 350)
-- end
--
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  callback = flicker_current_line,
})
