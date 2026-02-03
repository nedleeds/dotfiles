local function apply_dap_signs()
  local define = vim.fn.sign_define
  define("DapBreakpoint",          { text = "", texthl = "DiagnosticError" })
  define("DapBreakpointCondition", { text = "󰺕", texthl = "DiagnosticWarn"  })
  define("DapStopped",             { text = "󰓗", texthl = "DiagnosticInfo", linehl = "Visual" })
  define("DapLogPoint",            { text = "󰰍", texthl = "DiagnosticInfo" })
  define("DapBreakpointRejected",  { text = "󰅙", texthl = "DiagnosticError" })
end

-- ✅ CodeLLDB 경로: long string로 이스케이프 문제 방지
local CODELLDB_EXE = [[C:\Users\Admin\AppData\Local\bin\codelldb\extension\adapter\codelldb.exe]]
vim.g.dap_codelldb_path = CODELLDB_EXE

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

-- ✅ 여러 번 호출되어도 안전하게 1회만 초기화
local codelldb_inited = false

local function setup_codelldb_configs()
  if codelldb_inited then return end
  codelldb_inited = true

  local dap = require("dap")

  local function is_executable(path)
    if not path or path == "" then return false end
    local st = vim.uv.fs_stat(path)
    if not st or st.type ~= "file" then return false end
    if vim.fn.has("win32") == 1 then return true end
    return vim.fn.getfperm(path):find("x") ~= nil
  end

  local function path_join(...)
    local sep = (vim.fn.has("win32") == 1) and "\\" or "/"
    return table.concat({ ... }, sep)
  end

  local function is_file(p)
    if not p or p == "" then return false end
    local st = vim.uv.fs_stat(p)
    return st and st.type == "file"
  end

  local function list_subdirs(base_dir)
    local dirs = vim.fn.globpath(base_dir, "*/", false, true) or {}
    table.sort(dirs, function(a, b) return a:lower() < b:lower() end)
    return dirs
  end

  local function pick_hi6_main_exe()
    local base_dir = "D:\\01_Hi6"
    local rel_exe = path_join("build", "vs12", "bin", "Debug", "hi6_main.exe")

    return coroutine.create(function(co)
      local ok, fzf = pcall(require, "fzf-lua")
      if not ok then
        vim.notify("fzf-lua not found. Install/enable fzf-lua.", vim.log.levels.ERROR)
        coroutine.resume(co, "")
        return
      end

      local dirs = list_subdirs(base_dir)
      if #dirs == 0 then
        vim.notify("No subdirectories under: " .. base_dir, vim.log.levels.ERROR)
        coroutine.resume(co, "")
        return
      end

      fzf.fzf_exec(dirs, {
        prompt = "Hi6 project> ",
        actions = {
          ["default"] = function(selected)
            local dir = selected and selected[1] or nil
            if not dir or dir == "" then
              coroutine.resume(co, "")
              return
            end

            dir = dir:gsub("/", "\\"):gsub("\\+$", "")
            local exe = path_join(dir, rel_exe)

            if is_file(exe) then
              coroutine.resume(co, exe)
            else
              vim.notify("Not found: " .. exe, vim.log.levels.WARN)
              local manual = vim.fn.input("Path to executable: ", exe, "file")
              coroutine.resume(co, manual)
            end
          end,
          ["esc"] = function()
            coroutine.resume(co, "")
          end,
        },
        winopts = { height = 0.35, width = 0.70 },
      })
    end)
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

  -- ✅ 여기서 진짜로 존재 검증
  if vim.uv.fs_stat(CODELLDB_EXE) == nil then
    vim.notify("codelldb.exe not found: " .. CODELLDB_EXE, vim.log.levels.ERROR)
    return
  end

  -- ✅ CodeLLDB adapter: 전역 변수 말고 절대경로로 하드 고정
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = CODELLDB_EXE,
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.cpp = dap.configurations.cpp or {}
  dap.configurations.c   = dap.configurations.c   or {}

  local function ensure_cfg(lang)
    local list = dap.configurations[lang] or {}
    dap.configurations[lang] = list

    local function has(name)
      for _, c in ipairs(list) do
        if c.name == name then return true end
      end
      return false
    end

    if not has("Launch hi6_main.exe (fzf)") then
      table.insert(list, 1, {
        name = "Launch hi6_main.exe (fzf)",
        type = "codelldb",
        request = "launch",
        program = pick_hi6_main_exe,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      })
    end

    if not has("Launch (codelldb)") then
      table.insert(list, 2, {
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
      table.insert(list, 3, {
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
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "ibhagwan/fzf-lua",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<F5>",
        function()
          local ft = vim.bo.filetype
          if ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp" then
            setup_codelldb_configs()
          elseif ft == "python" then
            setup_python_configs()
          end
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      apply_dap_signs()
      vim.opt.signcolumn = "yes"

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

      dap.listeners.after.event_initialized["dapui_auto_open"] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated["dapui_auto_close"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_auto_close"] = function()
        dapui.close()
      end

      -- filetype별 DAP config를 autocmd로 설정
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          setup_codelldb_configs()
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python" },
        callback = function()
          setup_python_configs()
        end,
      })
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    dependencies = { "mfussenegger/nvim-dap" },
  },
}
