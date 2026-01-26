local M = {}

function M.safe_require(mod)
  local ok, m = pcall(require, mod)
  if ok then return m end
  return nil
end

function M.augroup(name)
  return vim.api.nvim_create_augroup("dhl_" .. name, { clear = true })
end

function M.is_client_attached(name, bufnr)
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c.name == name then return true end
  end
  return false
end

return M
