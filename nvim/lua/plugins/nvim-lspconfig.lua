-- lua/plugins/lsp.lua
-- Neovim built-in LSP config (no vim.lsp.get_config dependency)

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
})

-- -------------------------
-- Common: already attached?
-- -------------------------
local function already_attached(name, bufnr)
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c.name == name then
      return true
    end
  end
  return false
end

-- =========================
-- lua_ls
-- =========================
local function lua_ls_root_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local config_dir = vim.fn.stdpath("config") -- ~/.config/nvim
  if name:sub(1, #config_dir) == config_dir then
    return config_dir
  end
  return vim.fn.getcwd()
end

-- lua_ls settings helper
local function lua_ls_settings_for(bufnr)
  local root = lua_ls_root_dir(bufnr)
  local config_dir = vim.fn.stdpath("config")

  -- 기본은 Neovim runtime 인식 + vim 전역 허용
  local s = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- Neovim runtime files 인식 (특히 vim.* 관련)
        library = {
          vim.env.VIMRUNTIME,
          config_dir,
        },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  }

  -- Neovim 설정 폴더에서는 "경고 자체를 완전히 끔"
  if root == config_dir then
    s.Lua.diagnostics.enable = false
  end

  return s
end

-- 등록(미래 버퍼용 enable용)
vim.lsp.config("lua_ls", {
  root_dir = function(bufnr, on_dir)
    on_dir(lua_ls_root_dir(bufnr))
  end,
  settings = lua_ls_settings_for(0), -- placeholder(attach 시 start settings가 우선)
})

-- =========================
-- Python root / pythonPath
-- =========================
local function py_root_dir(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then
    return vim.fn.getcwd()
  end
  local dir = vim.fs.dirname(fname)

  local root = vim.fs.find(
    { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    { upward = true, path = dir }
  )[1]

  return root and vim.fs.dirname(root) or dir
end

local function python_path_for(root_dir)
  local venv_py = root_dir .. "/.venv/bin/python"
  if vim.uv.fs_stat(venv_py) then return venv_py end

  local conda_py = root_dir .. "/.conda/bin/python"
  if vim.uv.fs_stat(conda_py) then return conda_py end

  local venv = vim.env.VIRTUAL_ENV
  if venv and #venv > 0 then
    local p = venv .. "/bin/python"
    if vim.uv.fs_stat(p) then return p end
  end

  local conda = vim.env.CONDA_PREFIX
  if conda and #conda > 0 then
    local p = conda .. "/bin/python"
    if vim.uv.fs_stat(p) then return p end
  end

  local p = vim.fn.exepath("python3")
  if p ~= nil and p ~= "" then return p end

  p = vim.fn.exepath("python")
  if p ~= nil and p ~= "" then return p end

  return "/usr/bin/python3"
end

-- =========================
-- LSP configs (registered)
-- =========================
vim.lsp.config("pyright", {
  root_dir = function(bufnr) return py_root_dir(bufnr) end,
  settings = {
    python = {
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

vim.lsp.config("ruff", {
  root_dir = function(bufnr) return py_root_dir(bufnr) end,
})

-- =========================
-- Attach on FileType
-- =========================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(args)
    local bufnr = args.buf
    if already_attached("lua_ls", bufnr) then
      return
    end

    vim.lsp.start({
      name = "lua_ls",
      cmd = { "lua-language-server" },
      root_dir = lua_ls_root_dir(bufnr),
      settings = lua_ls_settings_for(bufnr), -- ✅ 여기서 진단 off/글로벌 vim 적용
    }, { bufnr = bufnr })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(args)
    local bufnr = args.buf
    local root = py_root_dir(bufnr)

    if not already_attached("pyright", bufnr) then
      vim.lsp.start({
        name = "pyright",
        cmd = { "pyright-langserver", "--stdio" },
        root_dir = root,
        settings = {
          python = {
            pythonPath = python_path_for(root),
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

    if not already_attached("ruff", bufnr) then
      vim.lsp.start({
        name = "ruff",
        cmd = { "ruff", "server" },
        root_dir = root,
      }, { bufnr = bufnr })
    end
  end,
})

vim.lsp.enable({ "lua_ls", "pyright", "ruff" })
