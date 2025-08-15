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

  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#ff0000" })


  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#fca31c", bg = "#2e1c00" })
  -- vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#FF0000", bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#FFA500", bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#0000FF", bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#008000", bg = "NONE" })

  -- vim.api.nvim_set_hl(0, "LspDiagnosticsVirtualTextError", { bg = "#ff0000" })
end

--
ColorMyPencils()
