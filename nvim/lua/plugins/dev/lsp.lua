-- lua/plugins/dev/lsp.lua
local U = require("config.util")
local PY = require("config.python")
local CMP = require("plugins.dev.cmp")

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
      cmd = { "lua-language-server" },
      root_dir = lua_ls_root_dir(bufnr),
      settings = lua_ls_settings_for(bufnr),
      capabilities = CMP.capabilities,
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
        capabilities = CMP.capabilities,
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
      "/opt/homebrew/opt/llvm/bin/clangd",
      "--background-index",
      "--clang-tidy",
      "--completion-style=detailed",
      "--header-insertion=iwyu",
      "--fallback-style=llvm",
    }

    if ccdir then
      table.insert(cmd, "--compile-commands-dir=" .. ccdir)
    end

    vim.lsp.start({
      name = "clangd",
      cmd = cmd,
      root_dir = root,
      capabilities = CMP.capabilities,
    }, { bufnr = bufnr })
  end,
})


-- Zig (zls)
local function zig_root_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fs.dirname(name)
  if not dir then
    return vim.fn.getcwd()
  end

  -- build.zig / build.zig.zon / .git 를 루트 마커로 사용
  local root = vim.fs.root(dir, { "build.zig", "build.zig.zon", ".git" })
  return root or dir
end

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "zig",
  callback = function(args)
    local bufnr = args.buf
    if U.is_client_attached("zls", bufnr) then return end

    local root = zig_root_dir(bufnr)

    -- 당신이 빌드한 zig 우선 사용 (없으면 PATH의 zig로 fallback)
    local zig_exe = vim.fn.expand("~/bin/zig")
    if vim.fn.executable(zig_exe) ~= 1 then
      zig_exe = vim.fn.exepath("zig")
    end

    vim.lsp.start({
      name = "zls",
      cmd = { "zls" },
      capabilities = CMP.capabilities,
      root_dir = root,
      settings = {
        zls = {
          zig_exe_path = zig_exe,
          -- 아래 옵션들은 zls 버전에 따라 지원 여부가 다를 수 있습니다.
          -- enable_inlay_hints = true,
          -- warn_style = true,
        },
      },
    }, { bufnr = bufnr })
  end,
})

-- TypeScript / JavaScript (tsserver via typescript-language-server)
local function ts_root_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fs.dirname(name) or vim.fn.getcwd()

  -- 프로젝트 루트 마커 (필요시 추가/삭제)
  local root = vim.fs.root(dir, {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    "deno.json",
    "deno.jsonc",
    ".git",
  })

  return root or dir
end

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
  },
  callback = function(args)
    local bufnr = args.buf
    if U.is_client_attached("tsserver", bufnr) then return end

    local root = ts_root_dir(bufnr)

    vim.lsp.start({
      name = "tsserver",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = root,
      capabilities = CMP.capabilities,

    }, { bufnr = bufnr })
  end,
})

