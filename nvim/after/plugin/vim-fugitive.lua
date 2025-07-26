vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

vim.api.nvim_create_autocmd("User", {
  pattern = "FugitiveIndex",
  callback = function()
    vim.keymap.set('n', '<CR>', 'dv', {
      buffer = true,
      remap = true,
      desc = "Show vertical diff view on Enter"
    })
  end,
  group = vim.api.nvim_create_augroup("CustomFugitiveMappings", { clear = true })
})
