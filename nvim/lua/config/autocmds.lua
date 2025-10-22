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

local function flicker_current_line()
  if vim.bo.buftype ~= "" then return end

  vim.wo.cursorline = true
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(0) and vim.bo.buftype == "" then
      vim.wo.cursorline = false
    end
  end, 250)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  callback = flicker_current_line,
})
