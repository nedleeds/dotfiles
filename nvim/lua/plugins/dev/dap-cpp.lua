-- lua/plugins/dev/dap-cpp.lua
local ok, dap = pcall(require, "dap")
if not ok then return end

-- =========================================================
-- YOU MUST SET THIS (codelldb executable path)
-- =========================================================
local CODELLDB = vim.g.dap_codelldb_path or ""

local function assert_codelldb()
  if CODELLDB == "" then
    vim.notify("[dap-cpp] vim.g.dap_codelldb_path is empty", vim.log.levels.ERROR)
    return false
  end
  if vim.fn.filereadable(CODELLDB) ~= 1 then
    vim.notify("[dap-cpp] codelldb not found: " .. CODELLDB, vim.log.levels.ERROR)
    return false
  end
  return true
end

local function is_executable(path)
  if not path or path == "" then return false end
  local st = vim.uv.fs_stat(path)
  if not st or st.type ~= "file" then return false end
  if vim.fn.has("win32") == 1 then return true end
  return vim.fn.getfperm(path):find("x") ~= nil
end

-- 프로젝트에 맞게 후보를 더 추가하세요.
local function pick_program()
  local cwd = vim.fn.getcwd()
  local candidates = {
    cwd .. "/build/app",
    cwd .. "/build/main",
    cwd .. "/build/bin/app",
    cwd .. "/build/bin/main",
    cwd .. "/a.out",
  }

  for _, p in ipairs(candidates) do
    if is_executable(p) then return p end
  end

  return vim.fn.input("Path to executable: ", cwd .. "/build/", "file")
end

-- =========================================================
-- Adapter: codelldb
-- =========================================================
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = CODELLDB,
    args = { "--port", "${port}" },
  },
}

-- =========================================================
-- Configurations: C/C++
-- =========================================================
dap.configurations.cpp = {
  {
    name = "Launch (codelldb)",
    type = "codelldb",
    request = "launch",
    program = function()
      if not assert_codelldb() then return nil end
      return pick_program()
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    name = "Attach (codelldb)",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.c = dap.configurations.cpp
