-- lua/config/python.lua
local M = {}

function M.py_root_dir(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then return vim.fn.getcwd() end
  local dir = vim.fs.dirname(fname)

  local root = vim.fs.find(
    { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    { upward = true, path = dir }
  )[1]

  return root and vim.fs.dirname(root) or dir
end

function M.python_path_for(root_dir)
  local candidates = {
    root_dir .. "/.venv/bin/python",
    root_dir .. "/.conda/bin/python",
  }

  for _, p in ipairs(candidates) do
    if vim.uv.fs_stat(p) then return p end
  end

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

-- “현재 작업 루트” 기준 기본 python (DAP의 setup용으로 적당)
function M.python_for_cwd()
  return M.python_path_for(vim.fn.getcwd())
end

return M
