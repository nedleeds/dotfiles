-- lua/plugins/dev/dap_python.lua
local U = require("config.util")
local PY = require("config.python")

local dap = U.safe_require("dap")

local ok_dp, dappython = pcall(require, "dap-python")
if not dap or not ok_dp or type(dappython) ~= "table" then
  return
end

dappython.setup(PY.python_for_cwd())

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
  pythonPath = function()
    local root = vim.fn.getcwd()
    return PY.python_path_for(root)
  end,
})
