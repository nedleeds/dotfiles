local M = {}

-- Windows path helpers
local function norm(p)
  return (p:gsub("/", "\\"))
end

local function is_win()
  return vim.loop.os_uname().version:match("Windows") ~= nil
end

local function path_join(a, b)
  if a:sub(-1) == "\\" then return a .. b end
  return a .. "\\" .. b
end

local function file_exists(p)
  return vim.fn.filereadable(p) == 1
end

local function dir_exists(p)
  return vim.fn.isdirectory(p) == 1
end

local function unique_sorted(list)
  local seen, out = {}, {}
  for _, v in ipairs(list) do
    if v and v ~= "" and not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  table.sort(out)
  return out
end

-- Get ancestors: cwd, parent, grandparent... up to max_up (inclusive of cwd)
local function ancestors(start_dir, max_up)
  local dirs = {}
  local dir = norm(start_dir)
  for _ = 1, max_up do
    table.insert(dirs, dir)
    local parent = norm(vim.fn.fnamemodify(dir, ":h"))
    if parent == dir or parent == "" then break end
    dir = parent
  end
  return dirs
end

-- Bounded-depth scan to find venv python.exe under each ancestor
local function scan_for_pythons(root, max_depth)
  local results = {}

  local function scan(dir, depth)
    if depth > max_depth then return end

    local candidates = {
      path_join(dir, ".venv\\Scripts\\python.exe"),
      path_join(dir, "venv\\Scripts\\python.exe"),
      path_join(dir, ".env\\Scripts\\python.exe"),
    }

    for _, c in ipairs(candidates) do
      c = norm(c)
      if file_exists(c) then table.insert(results, c) end
    end

    local ok, iter = pcall(vim.fs.dir, dir)
    if not ok then return end

    for name, type_ in iter do
      if type_ == "directory" then
        if name ~= ".git"
          and name ~= "node_modules"
          and name ~= ".venv"
          and name ~= "venv"
          and name ~= ".env"
        then
          scan(path_join(dir, name), depth + 1)
        end
      end
    end
  end

  scan(norm(root), 0)
  return results
end

-- fzf-lua picker
local function pick_with_fzf(items, on_choice)
  local ok, fzf = pcall(require, "fzf-lua")
  if ok and fzf and fzf.fzf_exec then
    fzf.fzf_exec(items, {
      prompt = "Python> ",
      previewer = false,

      -- ✅ 여기서 창 크기 줄이기
      winopts = {
        height = 0.35,   -- 화면의 35%
        width  = 0.45,   -- 화면의 45%
        row    = 0.5,    -- 세로 중앙
        col    = 0.5,    -- 가로 중앙
        border = "rounded",
      },

      actions = {
        ["default"] = function(selected)
          local choice = selected and selected[1]
          if choice and choice ~= "" then
            on_choice(choice)
          end
        end,
      },
    })
    return
  end

  vim.ui.select(items, { prompt = "Python Interpreter" }, function(choice)
    if choice then on_choice(choice) end
  end)
end

-- Get active LSP client's root_dir (pyright root is the workspace root we care about)
local function get_client_root(name)
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if c.name == name and c.config and c.config.root_dir then
      return norm(c.config.root_dir)
    end
  end
  return nil
end

local function ensure_dir(p)
  if vim.fn.isdirectory(p) == 0 then
    vim.fn.mkdir(p, "p")
  end
end

-- Save/load selected interpreter per-workspace (VSCode style)
local function workspace_state_dir(root)
  return path_join(root, ".nvim")
end

local function workspace_interpreter_file(root)
  return path_join(workspace_state_dir(root), "python_interpreter.txt")
end

local function save_interpreter(root, python)
  local dir = workspace_state_dir(root)
  ensure_dir(dir)
  vim.fn.writefile({ python }, workspace_interpreter_file(root))
end

local function load_interpreter(root)
  local p = workspace_interpreter_file(root)
  if file_exists(p) then
    local lines = vim.fn.readfile(p)
    return lines and lines[1] or nil
  end
  return nil
end

-- Write pyrightconfig.json in workspace root
local function write_pyright_config(project_root, python_exe)
  local cfg_path = path_join(project_root, "pyrightconfig.json")
  local python = norm(python_exe)
  local venv = python:gsub("\\Scripts\\python%.exe$", "")

  local cfg

  -- Prefer venvPath/venv when venv is inside project_root
  local pr = norm(project_root)
  if venv:sub(1, #pr) == pr then
    local rel = venv:sub(#pr + 2) -- skip "\"
    local venv_name = rel:match("([^\\]+)") or ".venv"
    cfg = { venvPath = ".", venv = venv_name }
  else
    -- If venv is outside the project, pin pythonPath
    cfg = { pythonPath = python }
  end

  local json = vim.json.encode(cfg)
  vim.fn.writefile({ json }, cfg_path)
end

local function restart_pyright(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- 0) 이미 pyright가 붙어있으면 일단 중지(중복 attach 방지)
  local stopped = false
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c.name == "pyright" then
      -- ✅ force stop(true) 대신 graceful stop()
      c.stop()
      stopped = true
    end
  end

  -- 1) Windows/Node(pyright) 종료 정리 시간을 충분히 줌
  local delay = stopped and 500 or 0  -- ✅ 150ms -> 500ms 권장(필요시 800ms)

  vim.defer_fn(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if ok and lspconfig.pyright and lspconfig.pyright.manager then
      -- ✅ 다시 attach
      lspconfig.pyright.manager.try_add_wrapper(bufnr)
    else
      -- fallback: 버퍼를 다시 읽어서 autostart 트리거
      vim.cmd("silent! edit")
    end

    -- 2) Diagnostics/UI 갱신 트리거(선택)
    pcall(vim.diagnostic, "reset", nil, bufnr)
    pcall(vim.cmd, "silent! doautocmd BufEnter")
  end, delay)
end

local function apply_env_and_restart(python_exe)
  local python = norm(python_exe)
  local venv = python:gsub("\\Scripts\\python%.exe$", "")

  if dir_exists(venv) then
    vim.env.VIRTUAL_ENV = venv
    vim.env.PATH = norm(path_join(venv, "Scripts")) .. ";" .. (vim.env.PATH or "")
    vim.g.python3_host_prog = python
  end

  restart_pyright(0)
end

-- Apply interpreter to the current workspace (save + pyrightconfig + env + restart)
local function apply_for_workspace(root, python)
  if not root or root == "" then return end
  if not python or python == "" then return end

  local py = norm(python)
  if not file_exists(py) then
    vim.notify("Saved interpreter not found:\n" .. py, vim.log.levels.WARN)
    return
  end

  save_interpreter(root, py)
  write_pyright_config(root, py)
  apply_env_and_restart(py)

  vim.notify("Workspace interpreter set:\n" .. root .. "\n" .. py, vim.log.levels.INFO)
end

-- Public: pick interpreter and apply to workspace root (pyright root)
function M.pick_pyright_interpreter(opts)
  opts = opts or {}
  local max_up = opts.max_up or 3
  local max_depth = opts.max_depth or 2

  if not is_win() then
    vim.notify("This snippet is Windows-oriented (Scripts/python.exe). Adapt paths for Unix.", vim.log.levels.WARN)
  end

  local cwd = norm(vim.fn.getcwd())
  local dirs = ancestors(cwd, max_up)

  local found = {}
  for _, d in ipairs(dirs) do
    local pythons = scan_for_pythons(d, max_depth)
    vim.list_extend(found, pythons)
  end

  found = unique_sorted(found)
  if #found == 0 then
    vim.notify("No venv python.exe found under cwd + ancestors. Try increasing max_up/max_depth.", vim.log.levels.WARN)
    return
  end

  pick_with_fzf(found, function(choice)
    local root = get_client_root("pyright") or cwd
    apply_for_workspace(root, choice)
  end)
end

-- Auto-apply saved interpreter on enter/dir change (VSCode feel)
local function auto_apply_if_saved()
  local root = get_client_root("pyright")
  if not root or root == "" then return end

  local saved = load_interpreter(root)
  if saved and saved ~= "" and file_exists(saved) then
    -- Ensure pyright reads correct config at correct root
    write_pyright_config(root, saved)
    apply_env_and_restart(saved)
  end
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    pcall(auto_apply_if_saved)
  end,
})

-- User command
vim.api.nvim_create_user_command("PyrightPickInterpreter", function(cmd)
  local args = cmd.fargs
  local max_up = tonumber(args[1] or "") or 3
  local max_depth = tonumber(args[2] or "") or 2
  M.pick_pyright_interpreter({ max_up = max_up, max_depth = max_depth })
end, { nargs = "*", desc = "Pick Python interpreter for Pyright (scan cwd + ancestors)" })

return M
