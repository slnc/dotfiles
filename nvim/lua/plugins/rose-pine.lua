-- return	{ "rose-pine/neovim", name = "rose-pine" }
return {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
                require("rose-pine").setup({
                        variant = "moon",
                        disable_italics = false,
                        disable_background = false,
                        disable_float_background = true,
                        highlight_groups = {
                                -- ColorColumn = { bg = 'black' },

                                -- Blend colours against the "base" background
                                -- CursorLine = { bg = 'foam', blend = 10 },
                                StatusLine = { fg = 'love', bg = 'love', blend = 10 },
                        }
                })
                -- vim.cmd.colorscheme "rose-pine"
        end,
}
