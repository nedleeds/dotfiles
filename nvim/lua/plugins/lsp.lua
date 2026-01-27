return {
  {
    dir = vim.fn.stdpath("config"),
    name = "dhl-lsp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local U = require("config.util")
      local PY = require("config.python")
      local CLANG = require("config.clangd")
      local LSP = require("config.lsp")

      local capabilities = LSP.make_capabilities()

      local grp = U.augroup("lsp_attach")
      vim.g.__lsp_attach_grp = grp


      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      -- ---------------------------------------------------------
      -- Lua (lua_ls)
      -- ---------------------------------------------------------
      vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = "lua",
        callback = function(args)
          local bufnr = args.buf
          if U.is_client_attached("lua_ls", bufnr) then return end

          LSP.start(bufnr, {
            name = "lua_ls",
            cmd = { "lua-language-server" },
            root_dir = LSP.lua_ls_root_dir(bufnr),
            settings = LSP.lua_ls_settings_for(bufnr),
            capabilities = capabilities,
          })
        end,
      })

      -- ---------------------------------------------------------
      -- Python (pyright + ruff)
      -- ---------------------------------------------------------
      vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = "python",
        callback = function(args)
          local bufnr = args.buf
          local root = PY.py_root_dir(bufnr)
          local py = PY.python_path_for(root)

          if not U.is_client_attached("pyright", bufnr) then
            LSP.start(bufnr, {
              name = "pyright",
              cmd = { "pyright-langserver", "--stdio" },
              capabilities = capabilities,
              root_dir = root,
              settings = {
                python = {
                  pythonPath = py,
                  analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    reportUnusedImport = "none",
                    reportUnusedVariable = "none",
                    reportOptionalSubscript = "none",
                    reportOptionalMemberAccess = "none",
                    reportOptionalCall = "none",
                    diagnosticMode = "openFilesOnly",
                  },
                },
              },
            })
          end

          if not U.is_client_attached("ruff", bufnr) then
            LSP.start(bufnr, {
              name = "ruff",
              cmd = { "ruff", "server" },
              root_dir = root,
            })
          end
        end,
      })

      -- ---------------------------------------------------------
      -- C/C++ (clangd)
      -- ---------------------------------------------------------
      vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function(args)
          local bufnr = args.buf
          if U.is_client_attached("clangd", bufnr) then return end

          local root = CLANG.cpp_root_dir(bufnr)
          local ccdir = CLANG.compile_commands_dir(root)

          -- OS별 clangd 경로 선택
          local clangd_exe
          if vim.fn.has("win32") == 1 then
            clangd_exe = "clangd.exe.bat"

            -- PATH에 clangd가 잡히면 그걸 우선 사용하고 싶다면:
            -- local p = vim.fn.exepath("clangd")
            -- if p ~= "" then clangd_exe = p end
          else
            clangd_exe = "/opt/homebrew/opt/llvm/bin/clangd"
          end

          local cmd = {
            clangd_exe,
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--fallback-style=llvm",
          }

          if ccdir then
            table.insert(cmd, "--compile-commands-dir=" .. ccdir)
          end

          LSP.start(bufnr, {
            name = "clangd",
            cmd = cmd,
            root_dir = root,
            capabilities = capabilities,
          })
        end,
      })

      -- ---------------------------------------------------------
      -- Zig (zls)
      -- ---------------------------------------------------------
      vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = "zig",
        callback = function(args)
          local bufnr = args.buf
          if U.is_client_attached("zls", bufnr) then return end

          local root = LSP.zig_root_dir(bufnr)

          local zig_exe = vim.fn.expand("~/bin/zig")
          if vim.fn.executable(zig_exe) ~= 1 then
            zig_exe = vim.fn.exepath("zig")
          end

          LSP.start(bufnr, {
            name = "zls",
            cmd = { "zls" },
            capabilities = capabilities,
            root_dir = root,
            settings = {
              zls = {
                zig_exe_path = zig_exe,
              },
            },
          })
        end,
      })

      -- ---------------------------------------------------------
      -- TypeScript / JavaScript (tsserver)
      -- ---------------------------------------------------------
      vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        callback = function(args)
          local bufnr = args.buf
          if U.is_client_attached("tsserver", bufnr) then return end

          local root = LSP.ts_root_dir(bufnr)

          LSP.start(bufnr, {
            name = "tsserver",
            cmd = { "typescript-language-server", "--stdio" },
            root_dir = root,
            capabilities = capabilities,
          })
        end,
      })
    end,
  },
}
