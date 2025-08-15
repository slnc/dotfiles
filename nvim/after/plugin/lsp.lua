local lsp = require('lsp-zero')

-- lsp.ensure_installed("recommended")
--
-- lsp.ensure_installed({
-- })
--

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-n>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-p>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})


vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "vim.lsp.buf.definition()" })
-- nowait needed because of 0.11's gr* defaults
vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, { desc = "vim.lsp.buf.references()", nowait = true })

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  -- lsp.default_keymaps({buffer = bufnr})
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

  -- if n LSPs active, order is non-deterministic:
  -- https://lsp-zero.netlify.app/v3.x/language-server-configuration.html#enable-format-on-save
  lsp.default_keymaps({ buffer = bufnr })

  -- DO NOT SUBMIT: make this work, t's not being recognized
  local format_options = {
    tabSize = 4,
    insertSpaces = true,
    trimTrailingWhitespace = true,
    insertFinalNewline = true,
    trimFinalNewlines = true,
    formatOptions = {
      insertSpaces = true,
      tabSize = 4,
    },
    textDocumentFormat = {
      formatOptions = {
        tabSize = 4,
        insertSpaces = true,
        trimTrailingWhitespace = true,
        insertFinalNewline = true,
        trimFinalNewlines = true,
      }
    },
    documentFormattingProvider = true,
    documentRangeFormattingProvider = true,
  }

  -- Apply formatting options to specific file types
  -- if vim.bo[bufnr].filetype == "solidity" then
  --   format_options.formatOptions.tabSize = 4
  --   format_options.formatOptions.printWidth = 120 -- Set line length to 120
  -- end

  -- lsp.buffer_autoformat(format_options)
end)

-- if n LSPs active, order is non-deterministic:
-- https://lsp-zero.netlify.app/v3.x/language-server-configuration.html#enable-format-on-save
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  -- DO NOT SUBMIT fix max line length
  -- lsp.buffer_autoformat()
end)

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['lua_ls'] = { 'lua' },
    ['pylsp'] = { 'python' },
    -- ['gopls'] = { 'go' },
    -- ['tsserver'] = { 'javascript', 'typescript' },
  }
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.py" },
  desc = "Auto-format Python files after saving",
  callback = function()
    local fileName = vim.api.nvim_buf_get_name(0)
    vim.cmd(":silent !autoflake --remove-all-unused-imports --remove-unused-variables -i " .. fileName)
    vim.cmd(":silent !black --preview -q " .. fileName)
    vim.cmd(":silent !isort --profile black --float-to-top -q " .. fileName)
  end,
  group = autocmd_group,
})



-- here you can setup the language servers

require('mason').setup({})

local lspconfig = require('lspconfig')

-- I prefer to configure this myself
-- require('mason-lspconfig').setup({
--   ensure_installed = {
--     'lua_ls',
--     'pylsp',
--     -- 'tsserver',
--     -- 'dockerls',
--     -- 'eslint',
--   },
--   handlers = {
--     function(server_name)
--       require('lspconfig')[server_name].setup({})
--     end,
--
--     ["pylsp"] = function()
--       lspconfig.pylsp.setup {
--         -- All your custom settings are now here!
--         settings = {
--           pylsp = {
--             plugins = {
--               pycodestyle = {
--                 maxLineLength = 140,
--               },
--               pylint = { enabled = true },
--             }
--           }
--         }
--       }
--     end,
--   },
-- })

lspconfig.pylsp.setup {
  filetypes = { "python" },
  settings = {
    pylsp = {
      plugins = {
        -- one of these commented out plugins is very slow
        -- flake8 = {
        --   enabled = true,
        --   maxLineLength = 120,
        -- },
        pycodestyle = {
          maxLineLength = 140,
        },
        pylint = { enabled = true },
        -- rope_completion = { enabled = true },
      }
    }
  }
}

-- https://github.com/radleylewis/nvim/blob/c2f43182c705cf2e7a0e2c109616866a382a8399/lua/plugins/nvim-lspconfig.lua#L12
-- local on_attach = require("util.lsp").on_attach

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      format = {
        enable = true,
        -- Put format options here
        -- NOTE: the value should be String!
        -- DO NOT SUBMIT: not effective
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
    },
  },
}

lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      semanticTokens = true,
      staticcheck = true,
      gofumpt = true,
      ["ui.inlayhint.hints"] = {
        compositeLiteralFields = true,
        constantValues = true,
        -- parameterNames = true,
        functionTypeParameters = true,
      },
    },
  },
})
