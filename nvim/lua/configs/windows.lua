local M = {}

M.win_index = {}
local hint_wins = {}

function M.update_win_index()
  M.win_index = {}
  local count = vim.fn.winnr("$")
  for i = 1, count do
    local win = vim.fn.win_getid(i)
    if vim.api.nvim_win_is_valid(win) then
      M.win_index[i] = win
    end
  end
end

function M.goto_win(idx)
  M.update_win_index()
  local win = M.win_index[idx]
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  end
end

function M.show_win_hints()
  M.update_win_index()
  for i, win in ipairs(M.win_index) do
    local win_width = vim.api.nvim_win_get_width(win)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { " " .. i .. " " })
    local hint_win = Snacks.win({
      buf      = buf,
      relative = "win",
      win      = win,
      row      = 0,
      col      = win_width - 4,
      width    = 3,
      height   = 1,
      focusable = false,
      wo       = { winhl = "Normal:WinHintsFloat" },
    })
    table.insert(hint_wins, hint_win.win)
  end
end

function M.hide_win_hints()
  for _, win in ipairs(hint_wins) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  hint_wins = {}
end

return M
