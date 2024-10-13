return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ensure_installed = {
          "codelldb",
          "jedi_language_server",
          "ruff",
          "debugpy",
          "html",
          "htmlhint",
          "dockerls",
          "docker_compose_language_service",
          "hadolint",
          "eslint",
          "jsonls",
          "bashls",
          "dockerls",
          "docker_compose_language_service",
          "jsonls",
          "bashls",
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
          "eslint",
          "jsonls",
          "bashls",
          "jedi_language_server",
          "ruff",
          "clangd",
          "html",
          "dockerls",
          "docker_compose_language_service",
        },
      })
    end,
  },

  -- lspconfig 설정
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- 공통 on_attach 함수
      local on_attach = function(client, bufnr)
        -- 자동 포맷팅 설정
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = true })
            end,
          })
        end

        -- 기본 LSP 키맵 설정
        local opts = { noremap = true, silent = true }
        local buf_set_keymap = vim.api.nvim_buf_set_keymap
        buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      end

      -- LSP 서버 설정
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.jedi_language_server.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.ruff.setup({
        filetypes = { "python" },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.eslint.setup({
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
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "htm" },
        init_options = {
          provideFormatter = true,
        },
      })
      -- Dockerfile LSP 서버 설정
      lspconfig.dockerls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Docker Compose LSP 서버 설정
      lspconfig.docker_compose_language_service.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  },
}
