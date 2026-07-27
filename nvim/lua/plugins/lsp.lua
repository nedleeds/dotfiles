vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

local msvc_include = table.concat({
    [[C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\INCLUDE]],
    [[C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\ATLMFC\INCLUDE]],
    [[C:\Program Files (x86)\Windows Kits\8.1\include\shared]],
    [[C:\Program Files (x86)\Windows Kits\8.1\include\um]],
    [[C:\Program Files (x86)\Windows Kits\8.1\include\winrt]],
}, ";")

-- ── 서버 설정 ────────────────────────────────────────────────
local servers = {
    lua_ls = {
        filetypes = { "lua" },
        on_attach = function(client)
            client.server_capabilities.semanticTokensProvider = nil
        end,
        settings = {
            Lua = {
                runtime     = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace   = { checkThirdParty = false },
            },
        },
    },

    clangd = {
        cmd = {
            "C:/Program Files/LLVM/bin/clangd.exe",
            "--background-index",
            "--clang-tidy",
            "--cross-file-rename",
            "--log=error",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        cmd_env = { INCLUDE = msvc_include },
    },

    pyright = {
        filetypes = { "python" },
        settings = {
            python = {
                pythonPath = (function()
                    local venv = os.getenv("VIRTUAL_ENV")
                    if venv then
                        return venv .. "\\Scripts\\python.exe"
                    end
                    return vim.fn.exepath("python")
                end)(),
                analysis = {
                    autoSearchPaths        = true,
                    useLibraryCodeForTypes = true,
                    typeCheckingMode       = "basic",
                },
            },
        },
    },

    yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        file = { "yaml", "yaml.docker-compose" },
        settings = {
            yaml = {
                validate = true,
                completion = true,
                hover = true,
            },
        }
    }
}

for name, opts in pairs(servers) do
    vim.lsp.config(name, opts)
    vim.lsp.enable(name)
end

local function center()
  vim.api.nvim_create_autocmd("CursorMoved", {
    once = true,
    callback = function()
      vim.cmd.normal({ "zz", bang = true })
    end,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- map은 여기서 정의됨 (콜백 안)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
    end

    -- 따라서 map 호출도 전부 여기 안에 있어야 함
    map("gd", function() vim.lsp.buf.definition(); center() end,      "go definition")
    map("gD", function() vim.lsp.buf.declaration(); center() end,     "go declaration")
    map("gi", function() vim.lsp.buf.implementation(); center() end,  "go implementation")
    map("gt", function() vim.lsp.buf.type_definition(); center() end, "go type definition")
    map("gr", vim.lsp.buf.references, "get references")
    map("K",  vim.lsp.buf.hover,      "hover related doc")
    map("<leader>rn", vim.lsp.buf.rename,      "rename")
    map("<leader>ca", vim.lsp.buf.code_action, "code action")
  end,   -- ← 콜백 끝
}) 

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].quickfix == 0 then
      -- quickfix 창이 아닌 곳으로 진입 = 점프해 온 것
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    vim.keymap.set("n", "<CR>", "<CR>zz", {
      buffer = args.buf,
      desc = "이동 후 중앙 정렬",
    })
  end,
})

