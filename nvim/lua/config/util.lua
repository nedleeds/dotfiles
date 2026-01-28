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

function M.smart_close_window()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)

  local bt = vim.bo[buf].buftype

  -- -------------------------------------------------
  -- special windows: always just close
  -- (dap, help, terminal, snacks, floats, etc)
  -- -------------------------------------------------
  if bt ~= "" then
    pcall(vim.api.nvim_win_close, win, true)
    return
  end

  -- -------------------------------------------------
  -- normal windows
  -- -------------------------------------------------
  local wins = vim.api.nvim_tabpage_list_wins(0)

  if #wins > 1 then
    pcall(vim.api.nvim_win_close, win, false)
    return
  end

  if #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd("tabclose")
    return
  end

  vim.cmd("qa")
end

return M
