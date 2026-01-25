vim.api.nvim_create_autocmd("User", {
  pattern = "FugitiveIndex",
  callback = function()
    vim.keymap.set('n', '<CR>', 'dv', {
      buffer = true,
      remap = true,
      desc = "Show vertical diff view on Enter"
    })
    -- Override default commit mapping to use --quiet flag
    vim.keymap.set('n', 'cc', ':Git commit --quiet<CR>', {
      buffer = true,
      desc = "Commit (quiet)"
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

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.cmd('silent! normal! g`"zv')
  end,
})

<<<<<<< HEAD
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     if vim.bo.buftype == "" and not vim.bo.binary then
--       local n = vim.api.nvim_buf_line_count(0)
--       local last = vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1]
--       if last ~= "" then vim.api.nvim_buf_set_lines(0, n, n, false, { "" }) end
--     end
--   end,
-- })
||||||| parent of fcc6235 (backup)
=======
-- Autocreate dirs on write
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("Mkdir", { clear = true }),
  callback = function(args)
    local file = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(file) == 0 then
      vim.fn.mkdir(file, "p")
    end
  end,
})
>>>>>>> fcc6235 (backup)
