return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ensure_installed = {
          "codelldb",
          "pyright",
          "ruff",
          "debugpy",
          "html",
          "htmlhint",
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tsserver",
          "jsonls",
          "bashls",
          "pyright",
          "ruff",
          "clangd",
          "html",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      local on_attach = function(client, bufnr)
        -- auto formatting when press :w
        if client.server_capabilities.documentFormattingProvider then
          vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })")
        end

        -- local buf_set_keymap = vim.api.nvim_buf_set_keymap
        -- local opts = { noremap = true, silent = true }
        -- buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        -- buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        -- buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      end

      -- LSP 서버 설정
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        -- on_attach = on_attach,
      })
      lspconfig.pyright.setup({
        filetypes = { "python" },
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.ruff.setup({
        filetypes = { "python" },
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "htm" },
        init_options = {
          provideFormatter = true, -- 포맷터 제공 여부
        },
        settings = {},
      })

      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      -- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
