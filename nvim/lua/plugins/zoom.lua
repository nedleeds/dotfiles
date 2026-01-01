-- =========================================================
-- Stable Window Zoom (same tab, no plugin)
-- =========================================================

local wz = {
  active = false,
  restore_cmd = nil,
  tab = nil,
}

local function tabid()
  return vim.api.nvim_get_current_tabpage()
end

local function zoom_on()
  wz.tab = tabid()
  wz.restore_cmd = vim.fn.winrestcmd() -- 현재 탭의 레이아웃 저장
  wz.active = true

  -- 현재 윈도우를 탭 내에서 최대화
  vim.cmd("wincmd |")
  vim.cmd("wincmd _")
end

local function zoom_off()
  wz.active = false

  if wz.restore_cmd and wz.tab and vim.api.nvim_tabpage_is_valid(wz.tab) then
    pcall(vim.api.nvim_set_current_tabpage, wz.tab)
    pcall(vim.cmd, wz.restore_cmd)
  end

  wz.restore_cmd = nil
  wz.tab = nil
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
