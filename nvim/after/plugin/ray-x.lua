-- require('go').setup()
-- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--         pattern = "*.go",
--         callback = function()
--                 require('go.format').goimports()
--         end,
--         group = format_sync_grp,
-- })


-- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
-- autocmd BufWritePre (InsertLeave?) <buffer> lua vim.lsp.buf.formatting_sync(nil,500)
-- vim.lsp.buf.formatting_sync(nil, 500)

-- local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--         pattern = "*.go",
--         callback = function()
--                 require('go.format').goimports()
--         end,
--         group = format_sync_grp,
-- })
