-- lua/plugins/dev/dap.lua
local U = require("config.util")
local dap = U.safe_require("dap")
local dapui = U.safe_require("dapui")
if not dap or not dapui then return end

local dapui_cfg = {
  layouts = {
    {
      elements = {
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.20 },
        { id = "watches",     size = 0.20 },
        { id = "scopes",      size = 0.35 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
      position = "bottom",
    },
  },
}

dapui.setup(dapui_cfg)

local function dapui_reset_open()
  dapui.close()
  vim.schedule(function()
    dapui.open({ reset = true })
  end)
end

dap.listeners.after.event_initialized["dapui_open"] = function()
  dapui_reset_open()
end

dap.listeners.before.event_exited["dapui_close"] = function()
  dapui.close()
end

-- Signs (기존 유지)
vim.opt.signcolumn = "yes"
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapStopped", { text = "󰓗", texthl = "DiagnosticInfo", linehl = "Visual" })
vim.fn.sign_define("DapLogPoint", { text = "󰰎", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapBreakpointRejected", { text = "󱑚", texthl = "DiagnosticError" })
