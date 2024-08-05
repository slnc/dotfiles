function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	-- 0 global space, every window
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#ff0000" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#ff0000", bg = '#ff0000' })
end

ColorMyPencils()
