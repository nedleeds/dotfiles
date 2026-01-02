-- lua/plugins/dev/lsp.lua
local U = require("config.util")
local PY = require("config.python")

-- lua_ls root / settings (기존 로직 유지)
local function lua_ls_root_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local config_dir = vim.fn.stdpath("config")
  if name:sub(1, #config_dir) == config_dir then
    return config_dir
  end
  return vim.fn.getcwd()
end

local function lua_ls_settings_for(bufnr)
  local root = lua_ls_root_dir(bufnr)
  local config_dir = vim.fn.stdpath("config")

  local s = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = { vim.env.VIMRUNTIME, config_dir },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  }

  if root == config_dir then
    s.Lua.diagnostics.enable = false
  end

  return s
end

local grp = U.augroup("lsp_attach")

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "lua",
  callback = function(args)
    local bufnr = args.buf
    if U.is_client_attached("lua_ls", bufnr) then return end

    vim.lsp.start({
      name = "lua_ls",
      cmd = { "lua-language-server" },
      root_dir = lua_ls_root_dir(bufnr),
      settings = lua_ls_settings_for(bufnr),
    }, { bufnr = bufnr })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "python",
  callback = function(args)
    local bufnr = args.buf
    local root = PY.py_root_dir(bufnr)
    local py = PY.python_path_for(root)

    if not U.is_client_attached("pyright", bufnr) then
      vim.lsp.start({
        name = "pyright",
        cmd = { "pyright-langserver", "--stdio" },
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
      }, { bufnr = bufnr })
    end

    if not U.is_client_attached("ruff", bufnr) then
      vim.lsp.start({
        name = "ruff",
        cmd = { "ruff", "server" },
        root_dir = root,
      }, { bufnr = bufnr })
    end
  end,
})
