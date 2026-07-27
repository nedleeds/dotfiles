local M = {}

local weekdays = { "일", "월", "화", "수", "목", "금", "토" }

function M.open()
  local t = os.date("*t")
  local wday = weekdays[t.wday]
  local dir = string.format("D:/00_Notes/daily/%d/%d월", t.year, t.month)
  local date = string.format("%04d-%02d-%02d(%s)", t.year, t.month, t.day, wday)
  local path = string.format("%s/%s.md", dir, date)

  vim.fn.mkdir(dir, "p")

  local is_new = vim.fn.filereadable(path) == 0

  -- 저장 안 된 변경이 있으면 :edit 이 실패하므로 pcall 로 감싼다
  local ok = pcall(vim.cmd.edit, vim.fn.fnameescape(path))
  if not ok then
    vim.notify("현재 버퍼를 먼저 저장하세요 (:w)", vim.log.levels.WARN)
    return
  end

  if is_new then
    local template = {
      "# " .. date,
      "",
      "## 할 일",
      "- [ ] ",
      "",
      "## 타임테이블",
      "- 08:00 ",
      "",
      "## 메모",
      "",
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
    vim.api.nvim_win_set_cursor(0, { 4, 6 })
  end
end

return M
