vim.pack.add({ "https://github.com/RRethy/vim-illuminate" })

require("illuminate").configure({
  delay = 150,
  providers = { "lsp", "treesitter", "regex" },
  filetypes_denylist = {
    "minifiles",
    "qf",
    "help",
    "checkhealth",
    "toggleterm",
  },
  under_cursor = true,        -- 커서 아래 단어도 하이라이팅
  large_file_cutoff = 10000,  -- 이 줄 수 넘으면 비활성 (Hi6 대형 파일 대비)
})

-- 같은 단어 사이 이동
vim.keymap.set("n", "]]", function() require("illuminate").goto_next_reference() end, { desc = "다음 참조" })
vim.keymap.set("n", "[[", function() require("illuminate").goto_prev_reference() end, { desc = "이전 참조" })
