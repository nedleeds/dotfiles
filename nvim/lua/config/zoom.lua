local wz = {
  active = false,
  tab = nil,
  win = nil,
  layout_cmd = nil, -- winrestcmd (layout)
  sizes = nil,      -- per-window { [winid] = { w=, h= } }
}

local function tabid()
  return vim.api.nvim_get_current_tabpage()
end

local function snapshot_sizes()
  local t = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabid())) do
    if vim.api.nvim_win_is_valid(win) then
      t[win] = {
        w = vim.api.nvim_win_get_width(win),
        h = vim.api.nvim_win_get_height(win),
      }
    end
  end
  return t
end

local function restore_sizes(sizes)
  if not sizes then return end
  -- winrestcmd로 “레이아웃(분할 구조)”을 맞춘 뒤,
  -- 각 윈도우의 실제 너비/높이를 다시 강제.
  for win, s in pairs(sizes) do
    if vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_win_set_width, win, s.w)
      pcall(vim.api.nvim_win_set_height, win, s.h)
    end
  end
end

local function zoom_on()
  wz.tab = tabid()
  wz.win = vim.api.nvim_get_current_win()

  -- 레이아웃 + 정확한 크기 둘 다 저장
  wz.layout_cmd = vim.fn.winrestcmd()
  wz.sizes = snapshot_sizes()

  wz.active = true

  vim.cmd("wincmd |")
  vim.cmd("wincmd _")
end

local function zoom_off()
  if not wz.active then return end
  wz.active = false

  local tab = wz.tab
  local win = wz.win
  local layout_cmd = wz.layout_cmd
  local sizes = wz.sizes

  -- 상태 정리
  wz.tab, wz.win, wz.layout_cmd, wz.sizes = nil, nil, nil, nil

  if not (tab and layout_cmd and vim.api.nvim_tabpage_is_valid(tab)) then
    return
  end

  local function apply_restore()
    pcall(vim.api.nvim_set_current_tabpage, tab)
    pcall(vim.cmd, layout_cmd)

    -- 레이아웃 복원 직후에 사이즈를 강제 복원
    restore_sizes(sizes)

    if win and vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_set_current_win, win)
    end
  end

  -- “여러 번”이 아니라, 두 단계(즉시 + schedule 1회)만.
  -- (많은 환경에서 defer 10ms까지는 과합니다. 오히려 결과를 흔듭니다.)
  apply_restore()
  vim.schedule(apply_restore)
end

local function toggle()
  if wz.active then
    zoom_off()
  else
    zoom_on()
  end
end

-- 탭 이동/윈도우 구조 변형 시 상태 정리(안전장치)
vim.api.nvim_create_autocmd({ "TabLeave", "WinClosed" }, {
  callback = function()
    if wz.active then
      wz.active = false
      wz.tab, wz.win, wz.layout_cmd, wz.sizes = nil, nil, nil, nil
    end
  end,
})

return {
  toggle = toggle,
}
