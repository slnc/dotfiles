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


lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  -- lsp.default_keymaps({buffer = bufnr})
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
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
  if vim.bo[bufnr].filetype == "solidity" then
    format_options.formatOptions.tabSize = 4
    format_options.formatOptions.printWidth = 120 -- Set line length to 120
  end

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
    ['tsserver'] = { 'javascript', 'typescript' },
    -- Add other servers and filetypes as needed
    ['solidity_ls'] = {}, -- This disables formatting for Solidity
  }
})


-- here you can setup the language servers
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'tsserver',
    'solidity_ls',
    'dockerls',
    'eslint',
  },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

local lspconfig = require('lspconfig')
lspconfig.pylsp.setup {
  filetypes = { "python" },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false }, -- temp
        flake8 = { enabled = false },      -- temp
        pylint = { enabled = false },      -- temp
        rope_completion = { enabled = true },
      }
    }
  }
}

-- https://github.com/radleylewis/nvim/blob/c2f43182c705cf2e7a0e2c109616866a382a8399/lua/plugins/nvim-lspconfig.lua#L12
-- local on_attach = require("util.lsp").on_attach
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.solidity_ls.setup({
  capabilities = capabilities,
  -- on_attach = on_attach,
  filetypes = { "solidity" },
  root_dir = lspconfig.util.root_pattern("hardhat.config.*", ".git"),
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    solidity = {
      formatter = {
        lineLength = 120
      }
    }
  }
})

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
