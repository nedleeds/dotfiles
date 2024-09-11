-- 기본 키맵 설정
local keymaps = vim.keymap
local opts = { noremap = true, silent = true }

keymaps.set("n", "<M-A-j>", "<Esc>:m .+1<cr>==", { desc = "Move down" })
keymaps.set("n", "<M-A-k>", "<Esc>:m .-2<cr>==", { desc = "Move up" })

-- increment / Decrement
keymaps.set("n", "+", "<C-a>")
keymaps.set("n", "-", "<C-x>")

-- select all
keymaps.set("n", "<C-a>", "ggVG")

-- jumplist
keymaps.set("n", "<C-m>", "<C-i>", opts)

-- new tab
keymaps.set("n", "te", ":tabedit<Return>", opts)
keymaps.set("n", "<tab>", ":tabnext<Return>", opts)
keymaps.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- split windows
keymaps.set("n", "ss", ":split<Return>", opts)
keymaps.set("n", "sv", ":vsplit<Return>", opts)

-- resize windows
keymaps.set("n", "<C-w><left>", "<C-w><")
keymaps.set("n", "<C-w><right>", "<C-w>>")
keymaps.set("n", "<C-w><up>", "<C-w>=")
keymaps.set("n", "<C-w><down>", "<C-w>-")

vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- 일반 모드에서 다음과 이전 진단으로 이동
keymaps.set("n", "<C-0>", vim.diagnostic.goto_next, opts)
keymaps.set("n", "<C-9>", vim.diagnostic.goto_prev, opts)

-- Diagnostic 결과 창에서 ESC로 닫기 설정
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "diagnostic" },
  callback = function()
    -- ESC로 결과 창 닫기
    vim.keymap.set("n", "<Esc>", "<cmd>cclose<CR>", { buffer = true, silent = true, noremap = true })

    -- 결과 창에서 C-0으로 다음 diagnostic으로 이동
    vim.keymap.set("n", "<C-0>", function()
      vim.diagnostic.goto_next({ float = false }) -- float 옵션을 비활성화하여 QuickFix 창에서 이동
    end, { buffer = true, silent = true, noremap = true })

    -- 결과 창에서 C-9으로 이전 diagnostic으로 이동
    vim.keymap.set("n", "<C-9>", function()
      vim.diagnostic.goto_prev({ float = false }) -- float 옵션을 비활성화하여 QuickFix 창에서 이동
    end, { buffer = true, silent = true, noremap = true })
  end,
})
