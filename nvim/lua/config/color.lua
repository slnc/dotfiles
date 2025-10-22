function SetColors(color)
  vim.cmd.colorscheme(color or "rose-pine")

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  vim.api.nvim_set_hl(0, "QuickFixLine", { bg = "black", fg = "orange" })

  vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#2d5a2d" })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = "#4a4a2d" })
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#8a683f" })

  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#ff0000" })

  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#cf8619", bg = "#2e1c00" })
end

SetColors()
