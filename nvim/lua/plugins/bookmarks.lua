return {
  "MattesGroeger/vim-bookmarks",
  keys = {
    { "<leader>ba", "<cmd>BookmarkToggle<cr>",   desc = "Bookmark add/toggle" },
    { "<leader>br", "<cmd>BookmarkClearAll<cr>", desc = "Bookmark remove all" },
    { "<leader>bl", "<cmd>BookmarkShowAll<cr>",  desc = "Bookmark list" },
    { "]b", desc = "Next bookmark" },
    { "[b", desc = "Prev bookmark" },
  },
  init = function()
    vim.g.bookmark_sign                = "\xef\x82\x97"  -- nf-fa-bookmark-o (outline, U+F097)
    vim.g.bookmark_highlight_lines     = 0
    vim.g.bookmark_auto_save           = 1
    vim.g.bookmark_save_per_working_dir = 1
  end,
  config = function()
    -- sign 하이라이트: 컬러스킴 로드 후 덮어쓴다
    vim.api.nvim_set_hl(0, "BookmarkSign", { fg = "#3fb950", bold = true })  -- GitHub Dark green

    -- vim-bookmarks의 bm#next/prev 는 현재 파일 내부만 탐색하므로,
    -- 모든 북마크 파일을 순회하는 cross-file 이동으로 교체한다.
    local function all_bookmarks()
      -- { file, line } 전체 목록을 파일 → 줄 순으로 정렬
      local list = {}
      for _, file in ipairs(vim.fn["bm#all_files"]()) do
        for _, line in ipairs(vim.fn["bm#all_lines"](file)) do
          table.insert(list, { file = file, line = tonumber(line) })
        end
      end
      table.sort(list, function(a, b)
        return a.file == b.file and a.line < b.line or a.file < b.file
      end)
      return list
    end

    local function jump(dir)
      local list = all_bookmarks()
      if #list == 0 then
        vim.notify("No bookmarks", vim.log.levels.INFO)
        return
      end

      local cur_file = vim.api.nvim_buf_get_name(0)
      local cur_line = vim.api.nvim_win_get_cursor(0)[1]

      -- dir == 1: next, dir == -1: prev
      local target
      if dir == 1 then
        -- 현재 위치보다 뒤에 있는 첫 번째 북마크, 없으면 wrap
        for _, bm in ipairs(list) do
          if bm.file > cur_file or (bm.file == cur_file and bm.line > cur_line) then
            target = bm
            break
          end
        end
        if not target then target = list[1] end
      else
        -- 현재 위치보다 앞에 있는 마지막 북마크, 없으면 wrap
        for i = #list, 1, -1 do
          local bm = list[i]
          if bm.file < cur_file or (bm.file == cur_file and bm.line < cur_line) then
            target = bm
            break
          end
        end
        if not target then target = list[#list] end
      end

      if target.file ~= cur_file then
        vim.cmd("edit " .. vim.fn.fnameescape(target.file))
      end
      vim.api.nvim_win_set_cursor(0, { target.line, 0 })
      vim.cmd("normal! zz^")
    end

    vim.keymap.set("n", "]b", function() jump(1)  end, { desc = "Next bookmark" })
    vim.keymap.set("n", "[b", function() jump(-1) end, { desc = "Prev bookmark" })
  end,
}
