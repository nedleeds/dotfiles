-- =========================================================
-- Stable Window Zoom (same tab, no plugin)
-- =========================================================

local wz = {
  active = false,
  restore_cmd = nil,
  tab = nil,
  win = nil,  -- 추가: zoom 시작한 윈도우로 포커스 복귀
}

local function tabid()
  return vim.api.nvim_get_current_tabpage()
end

local function zoom_on()
  wz.tab = tabid()
  wz.win = vim.api.nvim_get_current_win()
  wz.restore_cmd = vim.fn.winrestcmd() -- 현재 탭의 레이아웃 저장
  wz.active = true

  -- 현재 윈도우를 탭 내에서 최대화
  vim.cmd("wincmd |")
  vim.cmd("wincmd _")
end

local function zoom_off()
  wz.active = false

  local restore_cmd = wz.restore_cmd
  local tab = wz.tab
  local win = wz.win

  -- 상태는 먼저 정리(중복 호출 방지)
  wz.restore_cmd = nil
  wz.tab = nil
  wz.win = nil

  if not (restore_cmd and tab and vim.api.nvim_tabpage_is_valid(tab)) then
    return
  end

  local function apply_restore()
    -- 탭 복귀
    pcall(vim.api.nvim_set_current_tabpage, tab)
    -- 레이아웃 복원
    pcall(vim.cmd, restore_cmd)
    -- 포커스 복귀(가능하면)
    if win and vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_set_current_win, win)
    end
  end

  -- 1) 즉시 복원
  apply_restore()

  -- 2) 다음 tick에 한 번 더 복원 (DAP UI 등 후속 리사이즈 덮어쓰기 방지)
  vim.schedule(function()
    apply_restore()
  end)

  -- 3) 아주 짧게 defer 해서 마지막으로 한 번 더 (환경에 따라 필요)
  vim.defer_fn(function()
    apply_restore()
  end, 10)
end

local function toggle()
  if wz.active then
    zoom_off()
  else
    zoom_on()
  end
end

-- 레이아웃이 바뀌면 상태 정리
vim.api.nvim_create_autocmd({ "WinNew", "WinClosed", "TabEnter" }, {
  callback = function()
    if wz.active and wz.tab ~= tabid() then
      wz.active = false
      wz.restore_cmd = nil
      wz.tab = nil
    end
  end,
})

-- ⭐ 핵심: 외부에서 쓸 함수 export
return {
  toggle = toggle,
}
