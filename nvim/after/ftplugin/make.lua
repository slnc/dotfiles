-- Use tabs instead of spaces in Makefiles
-- Using BufEnter autocmd to override editorconfig (which runs on BufReadPost)
vim.api.nvim_create_autocmd("BufEnter", {
  buffer = 0,
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 0
  end,
})
