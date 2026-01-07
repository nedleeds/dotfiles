-- lua/config/clangd.lua
local M = {}

local function normalize_bufnr(bufnr)
  if type(bufnr) ~= "number" or bufnr <= 0 then
    return vim.api.nvim_get_current_buf()
  end
  return bufnr
end

function M.cpp_root_dir(bufnr)
  bufnr = normalize_bufnr(bufnr)

  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then
    return vim.fn.getcwd()
  end

  local dir = vim.fs.dirname(fname)

  local root = vim.fs.find(
    { "compile_commands.json", ".clangd", "compile_flags.txt", "CMakeLists.txt", "Makefile", ".git" },
    { upward = true, path = dir }
  )[1]

  return root and vim.fs.dirname(root) or dir
end

function M.compile_commands_dir(root_dir)
  if vim.uv.fs_stat(root_dir .. "/compile_commands.json") then
    return root_dir
  end

  local candidates = {
    root_dir .. "/build",
    root_dir .. "/out/build",
    root_dir .. "/cmake-build-debug",
    root_dir .. "/cmake-build-release",
  }

  for _, d in ipairs(candidates) do
    if vim.uv.fs_stat(d .. "/compile_commands.json") then
      return d
    end
  end

  return nil
end

vim.g.dap_codelldb_path =
  vim.fn.expand("~/.local/share/codelldb/extension/adapter/codelldb")

return M
