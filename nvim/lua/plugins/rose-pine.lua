-- return	{ "rose-pine/neovim", name = "rose-pine" }
return	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "moon",
				disable_italics = true,
				disable_background = true,
				disable_float_background = true,
			})
			-- vim.cmd.colorscheme "rose-pine"
		end,
	}
