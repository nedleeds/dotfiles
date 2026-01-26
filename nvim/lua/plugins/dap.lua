local function apply_dap_signs()
  local define = vim.fn.sign_define
  define("DapBreakpoint",          { text = "󰧟", texthl = "DiagnosticError" })
  define("DapBreakpointCondition", { text = "",  texthl = "DiagnosticWarn"  })
  define("DapStopped",             { text = "󰓗", texthl = "DiagnosticInfo", linehl = "Visual" })
  define("DapLogPoint",            { text = "󰰍", texthl = "DiagnosticInfo" })
  define("DapBreakpointRejected",  { text = "󰅙", texthl = "DiagnosticError" })
end

local function setup_python_configs()
  local PY = require("config.python")
  local dap = require("dap")
  local dappython = require("dap-python")

  dappython.setup(PY.python_for_cwd())

  dap.configurations.python = dap.configurations.python or {}

  local function has(name)
    for _, c in ipairs(dap.configurations.python) do
      if c.name == name then return true end
    end
    return false
  end

  local cfg_name = "Launch current file (stop on entry)"
  if not has(cfg_name) then
    table.insert(dap.configurations.python, 1, {
      type = "python",
      request = "launch",
      name = cfg_name,
      program = "${file}",
      cwd = "${workspaceFolder}",
      console = "internalConsole",
      justMyCode = false,
      stopOnEntry = true,
      pythonPath = function()
        return PY.python_path_for(vim.fn.getcwd())
      end,
    })
  end
end

local function setup_codelldb_configs()
  local dap = require("dap")

  local function codelldb_path()
    return vim.g.dap_codelldb_path or ""
  end

  local function is_executable(path)
    if not path or path == "" then return false end
    local st = vim.uv.fs_stat(path)
    if not st or st.type ~= "file" then return false end
    if vim.fn.has("win32") == 1 then return true end
    return vim.fn.getfperm(path):find("x") ~= nil
  end

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

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path(),
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.cpp = dap.configurations.cpp or {}
  dap.configurations.c = dap.configurations.c or {}

  local function ensure_cfg(lang)
    local list = dap.configurations[lang]
    local function has(name)
      for _, c in ipairs(list) do
        if c.name == name then return true end
      end
      return false
    end

    if not has("Launch (codelldb)") then
      table.insert(list, 1, {
        name = "Launch (codelldb)",
        type = "codelldb",
        request = "launch",
        program = pick_program,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      })
    end

    if not has("Attach (codelldb)") then
      table.insert(list, 2, {
        name = "Attach (codelldb)",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      })
    end
  end

  ensure_cfg("cpp")
  ensure_cfg("c")
end

return {
  -- Core
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>",  function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
    },
    config = function()
      require("dap")
      apply_dap_signs()
      vim.opt.signcolumn = "yes"
    end,
  },

  -- UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      apply_dap_signs()

      dapui.setup({
        layouts = {
          {
            position = "left",
            size = 40,
            elements = {
              { id = "scopes",      size = 0.40 },
              { id = "watches",     size = 0.20 },
              { id = "stacks",      size = 0.20 },
              { id = "breakpoints", size = 0.20 },
            },
          },
          {
            position = "bottom",
            size = 12,
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
          },
        },
      })

      -- Auto open/close (VSCode style)
      dap.listeners.after.event_initialized["dapui_auto_open"] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated["dapui_auto_close"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_auto_close"] = function()
        dapui.close()
      end
    end,
  },

  -- Python
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap")
      apply_dap_signs()
      setup_python_configs()
    end,
  },

  -- C/C++
  {
    "mfussenegger/nvim-dap",
    ft = { "c", "cpp", "objc", "objcpp" },
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = function()
      require("dap")
      apply_dap_signs()
      setup_codelldb_configs()
    end,
  },
}
