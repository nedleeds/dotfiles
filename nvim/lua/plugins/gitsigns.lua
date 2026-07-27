vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  signs = {
    add          = { text = "┃" },
    change       = { text = "┃" },
    delete       = { text = "_" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
    untracked    = { text = "┆" },
  },

  current_line_blame = true,
  current_line_blame_opts = {
    virt_text_pos = "eol",
    delay = 300,
  },
  current_line_blame_formatter = "<abbrev_sha> <author>, <author_time:%Y-%m-%d> - <summary>",
  preview_config = { border = "rounded" },

  on_attach = function(bufnr)
    local gs = require("gitsigns")

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- 이동 (diff 모드에서는 기본 ]c/[c 동작 유지)
    map("n", "]c", function()
      if vim.wo.diff then vim.cmd.normal({ "]c", bang = true })
      else gs.nav_hunk("next") end
    end, "다음 hunk")

    map("n", "[c", function()
      if vim.wo.diff then vim.cmd.normal({ "[c", bang = true })
      else gs.nav_hunk("prev") end
    end, "이전 hunk")

    -- hunk 조작
    map("n", "<leader>hs", gs.stage_hunk,   "hunk 스테이징")
    map("n", "<leader>hr", gs.reset_hunk,   "hunk 되돌리기")
    map("n", "<leader>hS", gs.stage_buffer, "버퍼 전체 스테이징")
    map("n", "<leader>hR", gs.reset_buffer, "버퍼 전체 되돌리기")

    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "선택 영역 스테이징")

    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "선택 영역 되돌리기")

    -- 미리보기 / 정보
    map("n", "<leader>hp", gs.preview_hunk,        "hunk 미리보기")
    map("n", "<leader>hi", gs.preview_hunk_inline, "hunk 인라인 미리보기")
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "blame")
    map("n", "<leader>hd", gs.diffthis, "diff (인덱스 대비)")
    map("n", "<leader>hD", function() gs.diffthis("~") end, "diff (이전 커밋 대비)")

    -- 목록
    map("n", "<leader>hq", gs.setqflist, "hunk 목록 (현재 버퍼)")
    map("n", "<leader>hQ", function() gs.setqflist("all") end, "hunk 목록 (전체)")

    -- 토글
    map("n", "<leader>tw", gs.toggle_word_diff,          "word diff 토글")

    -- 텍스트 오브젝트
    map({ "o", "x" }, "ih", gs.select_hunk, "hunk 선택")
  end,
})
