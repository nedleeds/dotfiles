-- lua/config/lsp.lua
local M = {}

-- ---------------------------------------------------------
-- Capabilities (cmp-nvim-lsp 있으면 자동 반영)
-- ---------------------------------------------------------
function M.make_capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok and type(cmp_lsp.default_capabilities) == "function" then
    caps = cmp_lsp.default_capabilities(caps)
  end
  return caps
end

-- ---------------------------------------------------------
-- Root helpers
-- ---------------------------------------------------------
function M.root_from_markers(start_dir, markers)
  local root = vim.fs.root(start_dir, markers)
  return root or start_dir
end

function M.buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.dirname(name) or vim.fn.getcwd()
end

-- Lua LS: config 폴더 내 lua 파일이면 config_dir를 루트로
function M.lua_ls_root_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local config_dir = vim.fn.stdpath("config")
  if name:sub(1, #config_dir) == config_dir then
    return config_dir
  end

  local dir = M.buf_dir(bufnr)
  return M.root_from_markers(dir, { ".luarc.json", ".luarc.jsonc", ".git" })
end

function M.lua_ls_settings_for(bufnr)
  local root = M.lua_ls_root_dir(bufnr)
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

  -- Neovim 설정 repo에 대해서만 diagnostics 끄는 기존 로직 유지
  if root == config_dir then
    s.Lua.diagnostics.enable = false
  end

  return s
end

function M.zig_root_dir(bufnr)
  local dir = M.buf_dir(bufnr)
  return M.root_from_markers(dir, { "build.zig", "build.zig.zon", ".git" })
end

function M.ts_root_dir(bufnr)
  local dir = M.buf_dir(bufnr)
  return M.root_from_markers(dir, {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    "deno.json",
    "deno.jsonc",
    ".git",
  })
end

-- ---------------------------------------------------------
-- Start helper (중복 제거)
-- ---------------------------------------------------------
function M.start(bufnr, spec, opts)
  opts = opts or {}
  opts.bufnr = bufnr
  return vim.lsp.start(spec, opts)
end


return M
