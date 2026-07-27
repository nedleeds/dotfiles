local map = vim.keymap.set

-- 검색 하이라이트 끄기
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- 버퍼
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "이전 버퍼" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "다음 버퍼" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "버퍼 닫기" })

map("n", "<leader>bo", function()
    local cur = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= cur and vim.bo[buf].buflisted then
            vim.api.nvim_buf_delete(buf, {})
        end
    end
end, { desc = "다른 버퍼 모두 닫기" })

-- 창 이동
map("n", "<C-h>", "<C-w>h", { desc = "왼쪽 창으로" })
map("n", "<C-j>", "<C-w>j", { desc = "아래 창으로" })
map("n", "<C-k>", "<C-w>k", { desc = "위 창으로" })
map("n", "<C-l>", "<C-w>l", { desc = "오른쪽 창으로" })

-- 진단
map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "진단 상세" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end,  { desc = "다음 진단" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "이전 진단" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "진단 목록" })

map("n", "<leader>mm", function() require("customs.messages").show() end, { desc = "메시지 히스토리" })

-- buffer close with q
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "help",
        "qf",              -- quickfix, location list
        "man",
        "checkhealth",
        "undotree",
        "diff",
        "lspinfo",
        "startuptime",
        "gitsigns-blame",
        "gitsigns.blame",
        "toggleterm",
        "fugitive",
        "fugitiveblame",
        "git",
    },
    callback = function(args)
        vim.bo[args.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<CR>", {
            buffer = args.buf,
            silent = true,
            desc = "닫기",
        })
    end,
})

-- 창 크기 조정
map({ "n", "i", "t" }, "<M-,>", "<cmd>vertical resize -5<CR>", { desc = "창 좁게" })
map({ "n", "i", "t" }, "<M-.>", "<cmd>vertical resize +5<CR>", { desc = "창 넓게" })
map("v", "=",  "=",      { desc = "선택 영역 들여쓰기" })

map("n", "]q", "<cmd>cnext<CR>zz",     { desc = "다음 quickfix" })
map("n", "[q", "<cmd>cprevious<CR>zz", { desc = "이전 quickfix" })
map("n", "n", "nzzzv", { desc = "다음 검색 결과" })
map("n", "N", "Nzzzv", { desc = "이전 검색 결과" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<C-o>zz", { desc = "뒤로 + 중앙 정렬" })
map("n", "<C-i>", "<C-i>zz", { desc = "앞으로 + 중앙 정렬" })

-- visual 모드 들여쓰기 (선택 유지)
map("v", ">", ">gv", { desc = "들여쓰기" })
map("v", "<", "<gv", { desc = "내어쓰기" })


-- 현재 버퍼가 보고 있는 파일을 windows 탐색기로 열기
map("n", "<leader>E", function()
  local file = vim.fn.expand("%:p"):gsub("/", "\\")
  local target = file ~= "" and ("/select," .. file) or (vim.fn.getcwd():gsub("/", "\\"))
  vim.fn.system({
    "powershell", "-NoProfile", "-Command",
    "Start-Process", "explorer.exe", "-ArgumentList", "'" .. target .. "'"
  })
end, { desc = "탐색기에서 현재 파일 보기" })

-- list toggle
map("n", "<leader>l", "<cmd>set list!<cr>", { desc = "list 토글" })

map("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "들어오는 호출 (누가 나를 부르나)" })
map("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "나가는 호출 (내가 누구를 부르나)" })

local function qf_next()
  local ok = pcall(vim.cmd, "cnext")
  if not ok then pcall(vim.cmd, "cfirst") end   -- 끝이면 처음으로
  vim.cmd("normal! zz")
end

local function qf_prev()
  local ok = pcall(vim.cmd, "cprev")
  if not ok then pcall(vim.cmd, "clast") end    -- 처음이면 끝으로
  vim.cmd("normal! zz")
end

map("n", "<C-n>", qf_next, { desc = "다음 quickfix (순환)" })
map("n", "<C-p>", qf_prev, { desc = "이전 quickfix (순환)" })

vim.keymap.set("n", "<leader>nn", function() require("customs.note").open()
end, { desc = "오늘 데일리 노트" })

