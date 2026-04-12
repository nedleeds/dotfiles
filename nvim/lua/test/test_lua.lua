-- LSP: lua_ls
-- 테스트 방법:
--   K           → hover (타입/문서 보기)
--   gd          → go-to-definition
--   <leader>ca  → code actions
--   <leader>rn  → rename
--   diagnostics → 오류/경고가 있는 줄에서 확인

-- ── 1. Hover (K) ────────────────────────────────────────────────
-- vim API 위에 커서를 올리고 K를 누르면 hover 문서가 떠야 합니다.
local bufnr = vim.api.nvim_get_current_buf()
local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
local line_count = #lines

-- ── 2. Go-to-definition (gd) ────────────────────────────────────
local M = {}

---@param name string
---@return string
function M.greet(name)
  return "Hello, " .. name
end

-- greet 위에서 gd 를 누르면 정의로 이동해야 합니다.
local msg = M.greet("neovim")
vim.notify(msg)

-- ── 3. Type annotation / completion ─────────────────────────────
---@class Config
---@field width  integer
---@field height integer
---@field title  string

---@type Config
local cfg = {
  width  = 80,
  height = 24,
  title  = "LSP Test",
}

-- cfg. 을 입력하면 width / height / title 필드가 완성 목록에 나타나야 합니다.
vim.notify(cfg.title)

-- ── 4. Diagnostics (오류) ────────────────────────────────────────
-- 아래 줄은 undefined_var 를 사용 → lua_ls가 경고를 표시해야 합니다.
-- (의도적 에러: 아래 주석을 제거하면 경고 발생)
-- local _ = undefined_var

-- ── 5. Table / method completion ────────────────────────────────
local t = { 1, 2, 3 }
-- table. 을 입력하면 insert / remove / concat 등이 완성되어야 합니다.
table.insert(t, 4)
vim.print(t)
