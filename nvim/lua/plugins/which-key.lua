vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local wk = require("which-key")

wk.setup({
    preset = "modern",
    delay = 300,
    win = {
        border = "rounded",
    },
})

-- 그룹 이름만 등록 (실제 키맵은 각 파일에서 vim.keymap.set으로)
wk.add({
    { "<leader>b", group = "버퍼" },
    { "<leader>f", group = "찾기" },
    { "<leader>c", group = "코드" },
    { "<leader>r", group = "리팩토링" },
})
