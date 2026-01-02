-- lua/plugins/dev/dap_python.lua
local U = require("config.util")
local PY = require("config.python")

local dap = U.safe_require("dap")
local dappython = U.safe_require("dap-python")
if not dap or not dappython then return end

-- debugpy 실행용 python (대체로 cwd 기준이 합리적)
dappython.setup(PY.python_for_cwd())

-- launch 구성 보강: 실행 대상 python도 workspace 기준으로 일관화
dap.configurations.python = dap.configurations.python or {}

table.insert(dap.configurations.python, 1, {
  type = "python",
  request = "launch",
  name = "Launch current file (stop on entry)",
  program = "${file}",
  cwd = "${workspaceFolder}",
  console = "internalConsole",
  justMyCode = false,
  stopOnEntry = true,

  -- 핵심: workspaceFolder 루트 기준 pythonPath
  pythonPath = function()
    local root = vim.fn.getcwd()
    return PY.python_path_for(root)
  end,
})
