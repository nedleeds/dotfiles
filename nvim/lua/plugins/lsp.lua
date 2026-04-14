return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  config = function()
    local servers = {
      lua_ls = {
        filetypes = { "lua" },
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        settings  = {
          Lua = {
            runtime    = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace  = { checkThirdParty = false },
          },
        },
      },
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp" },
      },
      jsonls = {
        filetypes = { "json", "jsonc" },
      },
      cssls = {
        filetypes = { "css", "scss", "less" },
      },
      html = {
        filetypes = { "html" },
      },
      eslint = {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      pyright = {
        filetypes = { "python" },
        settings  = {
          python = {
            pythonPath = (function()
              local venv = os.getenv("VIRTUAL_ENV")
              return venv and (venv .. "/bin/python") or vim.fn.exepath("python3")
            end)(),
            analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true },
          },
        },
      },
    }

    for name, opts in pairs(servers) do
      vim.lsp.config(name, opts)
      vim.lsp.enable(name)
    end

  end,
}
