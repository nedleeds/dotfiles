-- =========================================================
-- nvim-dap + nvim-dap-ui (robust config)
-- =========================================================

-- 1) Plugins
vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
})

-- 2) Load modules safely
local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  return
end

local ok_dapui, dapui = pcall(require, "dapui")
if not ok_dapui then
  return
end

-- 3) dap-ui setup config
local dapui_cfg = {
  layouts = {
    {
      -- 원하는 순서대로 "위 -> 아래" 배치됩니다.
      -- 예: breakpoints -> stacks -> watches -> scopes
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
  -- close만으로는 기존 창이 재활용되는 경우가 있어, reset로 강제 재생성합니다.
  dapui.close()
  vim.schedule(function()
    dapui.open({ reset = true })
  end)
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  -- 덮어쓰기 방지 + 레이아웃/순서 강제
  dapui.setup(dapui_cfg)
  dapui_reset_open()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- =========================================================
-- DAP signs (Nerd Font)
-- =========================================================
vim.opt.signcolumn = "yes"

vim.fn.sign_define("DapBreakpoint", {
  text = "󰧟",
  texthl = "DiagnosticError",
})

vim.fn.sign_define("DapBreakpointCondition", {
  text = "",
  texthl = "DiagnosticWarn",
})

vim.fn.sign_define("DapStopped", {
  text = "󰓗",
  texthl = "DiagnosticInfo",
  linehl = "Visual",
})

vim.fn.sign_define("DapLogPoint", {
  text = "󰰍",
  texthl = "DiagnosticInfo",
})

vim.fn.sign_define("DapBreakpointRejected", {
  text = "󰅙",
  texthl = "DiagnosticError",
})

-- =========================================================
-- (Optional) Quick sanity check command
-- =========================================================
-- You can run:
-- :lua print(vim.inspect(require("dapui").config.layouts))
-- to confirm the layouts are applied.
