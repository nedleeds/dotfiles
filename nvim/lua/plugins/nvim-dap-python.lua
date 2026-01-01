-- lua/plugins/nvim-dap-python.lua
-- =========================================================
-- nvim-dap-python (debugpy)
-- =========================================================

vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap-python" },
})

-- dap 먼저 안전 로드 (nvim-dap이 아직 안 올라왔을 수 있음)
local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  return
end

local ok_py, dappython = pcall(require, "dap-python")
if not ok_py then
  return
end

local function detect_python()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv and #venv > 0 then
    return venv .. "/bin/python"
  end

  local conda = os.getenv("CONDA_PREFIX")
  if conda and #conda > 0 then
    return conda .. "/bin/python"
  end

  return "python3"
end

dappython.setup(detect_python())

-- (선택) 런치 구성: dap.configurations 존재 보장
dap.configurations.python = dap.configurations.python or {}
table.insert(dap.configurations.python, 1, {
  type = "python",
  request = "launch",
  name = "Launch current file (stop on entry)",
  program = "${file}",
  cwd = "${workspaceFolder}",
  console = "internalConsole",
  justMyCode = false,
  stopOnEntry = true,   -- 핵심: 여기
})
