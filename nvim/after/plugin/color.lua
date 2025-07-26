function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  -- 0 global space, every window
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  -- Quickfix highlighting
  vim.api.nvim_set_hl(0, "QuickFixLine", { bg = "black", fg = "orange" })

  -- Fugitive diff highlighting
  vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#2d5a2d" })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = "#4a4a2d" })
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#8a683f" })
end

--
ColorMyPencils()
