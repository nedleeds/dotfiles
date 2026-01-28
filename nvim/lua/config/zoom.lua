-- lua/config/window_zoom.lua (example)
local wz = {
  active = false,
  tab = nil,
  win = nil,
  layout_cmd = nil,
}

local function tabid()
  return vim.api.nvim_get_current_tabpage()
end

-- Find a window in the current tab whose buffer matches a filetype
local function find_win_by_ft(ft)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabid())) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_is_valid(buf) then
        if vim.bo[buf].filetype == ft then
          return win
        end
      end
    end
  end
  return nil
end

-- After restoring, keep DAP REPL usable
local function ensure_dap_repl_height(min_h)
  local repl_win = find_win_by_ft("dap-repl")
  if not repl_win then return end
  local cur = vim.api.nvim_win_get_height(repl_win)
  if cur < min_h then
    pcall(vim.api.nvim_win_set_height, repl_win, min_h)
  end
end

local function zoom_on()
  wz.tab = tabid()
  wz.win = vim.api.nvim_get_current_win()
  wz.layout_cmd = vim.fn.winrestcmd()
  wz.active = true

  -- Maximize current window inside the tab
  vim.cmd("wincmd |")
  vim.cmd("wincmd _")
end

local function zoom_off()
  if not wz.active then return end

  local tab = wz.tab
  local win = wz.win
  local layout_cmd = wz.layout_cmd

  -- reset state early
  wz.active = false
  wz.tab, wz.win, wz.layout_cmd = nil, nil, nil

  if not (tab and layout_cmd and vim.api.nvim_tabpage_is_valid(tab)) then
    return
  end

  local function restore_once()
    pcall(vim.api.nvim_set_current_tabpage, tab)
    pcall(vim.cmd, layout_cmd)

    -- Normalize sizes (prevents "one window gets crushed" outcomes)
    pcall(vim.cmd, "wincmd =")

    -- Keep REPL readable if present
    ensure_dap_repl_height(12)

    if win and vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_set_current_win, win)
    end
  end

  -- Do it now, and once again after redraw/layout churn (DAP UI is async-ish)
  restore_once()
  vim.schedule(restore_once)
end

local function toggle()
  if wz.active then
    zoom_off()
  else
    zoom_on()
  end
end

-- Safety: if tab changes, just drop zoom state (don’t try to restore stale layouts)
vim.api.nvim_create_autocmd({ "TabLeave" }, {
  callback = function()
    if wz.active then
      wz.active = false
      wz.tab, wz.win, wz.layout_cmd = nil, nil, nil
    end
  end,
})

return { toggle = toggle }
