local M = {}

-- :messages -> bottom split
function M.open_messages_split()
  local out = vim.fn.execute("messages")

  vim.cmd("botright split | resize 12")

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)

  vim.api.nvim_buf_set_name(buf, "Messages")
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "messages"

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(out, "\n"))
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true

  vim.cmd("normal! G")
end

-- Snacks notifications -> bottom split (newline-safe)
function M.open_snacks_notifications_split()
  if not (_G.Snacks and Snacks.notifier and Snacks.notifier.get_history) then
    vim.notify("Snacks.notifier.get_history() is not available", vim.log.levels.WARN)
    return
  end

  local hist = Snacks.notifier.get_history()

  vim.cmd("botright split | resize 12")

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)

  vim.api.nvim_buf_set_name(buf, "SnacksNotifications")
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "log"

  local lines = {}
  for _, it in ipairs(hist or {}) do
    local msg  = tostring(it.msg or it.message or ""):gsub("\r", "")
    local lvl  = tostring(it.level or it.lvl or "")
    local time = tostring(it.time or it.ts or "")

    local header = string.format("%s %-5s ", time, lvl)
    local parts = vim.split(msg, "\n", { plain = true })

    if #parts == 0 then
      table.insert(lines, header)
    else
      table.insert(lines, header .. parts[1])
      for i = 2, #parts do
        table.insert(lines, string.rep(" ", #header) .. parts[i])
      end
    end
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true

  vim.cmd("normal! G")
end

return M
