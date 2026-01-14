-- lua/plugins/ui/fzf.lua
local ok, fzf = pcall(require, "fzf-lua")
if not ok then
  return
end

fzf.setup({
  -- Windows에서 fzf 실행 파일 명시
  fzf_bin = "C:\\Users\\Admin\\bin\\fzf.exe",

  -- 필요 시 기본 옵션 예시 (선택)
  -- winopts = {
  --   height = 0.85,
  --   width = 0.80,
  --   row = 0.35,
  --   col = 0.50,
  -- },

  -- files = {
  --   prompt = "Files> ",
  -- },
})
