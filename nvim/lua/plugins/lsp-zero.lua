return {
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      local lsp = require('lsp-zero')
      lsp.extend_lspconfig()

      local cmp = require('cmp')

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "vim.lsp.buf.definition()" })
      vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end,
        { desc = "vim.lsp.buf.references()", nowait = true })

      lsp.on_attach(function(client, bufnr)
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
      end)

      lsp.format_on_save({
        format_opts = { async = false, timeout_ms = 10000 },
        servers = {
          ['lua_ls'] = { 'lua' },
          ['pylsp'] = { 'python' },
          -- ['gopls'] = { 'go' },
          ['ts_ls'] = { 'javascript', 'typescript' },
        }
      })

      local autocmd_group = vim.api.nvim_create_augroup("PythonFormat", { clear = true })
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

      require('mason').setup({})

      local lspconfig = require('lspconfig')

      lspconfig.pylsp.setup({
        filetypes = { "python" },
        settings = {
          pylsp = {
            plugins = {
              -- one of these commented out plugins is very slow
              -- flake8 = { enabled = true, maxLineLength = 120 },
              pycodestyle = { maxLineLength = 140 },
              pylint = { enabled = true },
              -- rope_completion = { enabled = true },
            }
          }
        }
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            format = {
              enable = true,
              -- DO NOT SUBMIT: not effective
              defaultConfig = { indent_style = "space", indent_size = "2" },
            },
            diagnostics = { globals = { 'vim' } },
          },
        },
      })

      lspconfig.gopls.setup({
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            semanticTokens = true,
            staticcheck = true,
            gofumpt = true,
            ["ui.inlayhint.hints"] = { constantValues = true, functionTypeParameters = true },
          },
        },
      })

      lspconfig.ts_ls.setup({
        filetypes = {
          "javascript", "javascript.jsx", "javascriptreact",
          "typescript", "typescript.tsx", "typescriptreact",
        }
      })

      lsp.setup()
    end
  },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  { 'L3MON4D3/LuaSnip' },
}
