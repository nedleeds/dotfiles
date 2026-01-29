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

-- cursor should appear at Nth line from TOP (e.g. n=8 => 8th line)
function M.place_cursor_nth_from_top(n)
  n = tonumber(n) or 1
  n = math.max(1, math.floor(n))

  local so = vim.wo.scrolloff
  vim.wo.scrolloff = 0

  local cur = vim.api.nvim_win_get_cursor(0) -- {lnum, col}
  local view = vim.fn.winsaveview()

  -- Make cursor line appear at nth line from top:
  -- topline = cursor_line - (n - 1)
  view.topline = math.max(1, cur[1] - (n - 1))

  vim.fn.winrestview(view)

  vim.wo.scrolloff = so
end

function M.snapshot()
  return {
    tab = vim.api.nvim_get_current_tabpage(),
    win = vim.api.nvim_get_current_win(),
    buf = vim.api.nvim_get_current_buf(),
    cursor = vim.api.nvim_win_get_cursor(0),
    view = vim.fn.winsaveview(),
  }
end

function M.restore(s)
  if not s then return false end

  if s.tab and vim.api.nvim_tabpage_is_valid(s.tab) then
    pcall(vim.api.nvim_set_current_tabpage, s.tab)
  end

  if not (s.win and vim.api.nvim_win_is_valid(s.win)) then return false end
  vim.api.nvim_set_current_win(s.win)

  if s.buf and vim.api.nvim_buf_is_valid(s.buf) then
    vim.api.nvim_win_set_buf(s.win, s.buf)
  end

  if s.cursor then pcall(vim.api.nvim_win_set_cursor, s.win, s.cursor) end
  if s.view then pcall(vim.fn.winrestview, s.view) end
  return true
end

return M
