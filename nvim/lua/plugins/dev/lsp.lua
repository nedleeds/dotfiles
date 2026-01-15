local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-8" }

-- lua/plugins/dev/lsp.lua
local U = require("config.util")
local PY = require("config.python")

-- Windows 로컬 LSP 바이너리 우선 사용 (없으면 PATH fallback)
local uv = vim.uv or vim.loop

local function path_join(...)
  local parts = { ... }
  return table.concat(parts, "\\")
end

local APPS = path_join(vim.env.LOCALAPPDATA, "nvim", "lsp-server")

local function exists(p)
  return p and uv.fs_stat(p) ~= nil
end

-- candidate 목록 중 "처음으로 존재하는 경로"를 채택, 없으면 fallback(원래 커맨드)
local function pick_cmd(candidates, fallback)
  for _, p in ipairs(candidates) do
    if exists(p) then
      return p
    end
  end
  return fallback
end

-- pyright: npm 로컬 설치 위치 케이스들
local PYRIGHT_BIN = pick_cmd({
  path_join(APPS, "pyright", "pyright-langserver.cmd"),
}, "pyright-langserver")

-- ruff: 로컬로 둘 경우 예시(아래 설치 가이드 참고)
local RUFF_BIN = pick_cmd({
  path_join(APPS, "ruff", "ruff.exe"),
}, "ruff")

vim.g.ruff_bin = RUFF_BIN

-- lua-language-server: 로컬로 둘 경우 예시(아래 설치 가이드 참고)
local LUA_LS_BIN = pick_cmd({
  path_join(APPS, "lua-language-server", "bin", "lua-language-server.exe"),
}, "lua-language-server")

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
vim.g.__lsp_attach_grp = grp

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "lua",
  callback = function(args)
    local bufnr = args.buf
    if U.is_client_attached("lua_ls", bufnr) then return end

    vim.lsp.start({
      name = "lua_ls",
      cmd = { LUA_LS_BIN },
      root_dir = lua_ls_root_dir(bufnr),
      capabilities = capabilities,
      settings = lua_ls_settings_for(bufnr),
    }, { bufnr = bufnr })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "python",
  callback = function(args)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    local bufnr = args.buf
    local root = PY.py_root_dir(bufnr)
    local py = PY.python_path_for(root)

    if not U.is_client_attached("pyright", bufnr) then
      vim.lsp.start({
        name = "pyright",
        cmd = { PYRIGHT_BIN, "--stdio" },
        root_dir = root,
        capabilities = capabilities,
        settings = {
          python = {
            pythonPath = py,
            analysis = {
              pythonVersion = "3.8",
              pythonPlatform = "Windows",
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
        cmd = { RUFF_BIN, "server" },
        capabilities = capabilities,
        root_dir = root,
      }, { bufnr = bufnr })
    end
  end,
})

local CLANG = require("config.clangd")

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function(args)
    local bufnr = args.buf
    if U.is_client_attached("clangd", bufnr) then return end

    local root = CLANG.cpp_root_dir(bufnr)
    local ccdir = CLANG.compile_commands_dir(root)

    local cmd = {
      "C:\\Program Files\\LLVM\\bin\\clangd.exe.bat",
    }

    if ccdir then
      table.insert(cmd, "--compile-commands-dir=" .. ccdir)
    end

    vim.lsp.start({
      name = "clangd",
      cmd = cmd,
      root_dir = root,
    }, { bufnr = bufnr })
  end,
})
