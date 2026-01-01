vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/rose-pine/neovim" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/projekt0n/github-nvim-theme" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },     -- gruvbox
  { src = "https://github.com/navarasu/onedark.nvim" },        -- One Dark
  { src = "https://github.com/Mofiqul/dracula.nvim" },         -- Dracula
  { src = "https://github.com/EdenEast/nightfox.nvim" },       -- Nightfox
  { src = "https://github.com/marko-cerovac/material.nvim" },  -- Material
  { src = "https://github.com/cocopon/iceberg.vim" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
})

-- require("tokyonight").setup({
--   style = "moon",
--   transparent = true,
--   styles = {
--     floats = "transparent",
--   },
-- })
--
-- vim.cmd.colorscheme("tokyonight")

-- -- =========================
-- -- ToggleTerm transparency + rounded float border
-- -- =========================
-- vim.api.nvim_set_hl(0, "ToggleTerm",            { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "ToggleTermNormal",      { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "ToggleTermNormalFloat", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "ToggleTermBorder",      { bg = "NONE" })
-- -- =========================
-- -- Theme palette (tokyonight)
-- -- =========================
-- local ok, tn_colors = pcall(require, "tokyonight.colors")
-- if not ok then
--   return
-- end
-- local c = tn_colors.setup()
-- =========================
-- Base transparency
-- =========================
-- vim.api.nvim_set_hl(0, "Normal",   { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
--
-- =========================
-- Tabline: accent / dim / contrast
-- =========================
-- local accent_fg   = c.blue or c.magenta or c.cyan or c.fg
-- local inactive_fg = c.fg_gutter or c.comment or c.fg_dark or c.fg
-- local hover_fg    = c.fg or c.fg_light or accent_fg -- "hover 느낌"용 대비
--
-- -- 기본 tabline 그룹 (Neovim 표준)
-- vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })

-- -- inactive: dim
-- vim.api.nvim_set_hl(0, "TabLine", {
--   fg = inactive_fg,
--   bg = "NONE",
-- })

-- -- current: accent + bold
-- vim.api.nvim_set_hl(0, "TabLineSel", {
--   fg = accent_fg,
--   bg = "NONE",
--   italic = true,
--   bold = true,
-- })
--
-- -- “hover 느낌”은 기본 TabLine에 진짜 hover가 없어서,
-- -- 대신 inactive 대비를 올리고(hover_fg), 선택 상태는 accent로 확실히 분리
-- -- (실제 hover 그룹이 있는 플러그인은 아래 mini.tabline 그룹에서 반영)
--
-- -- =========================
-- -- mini.tabline (버퍼 탭 UI) 하이라이트
-- -- =========================
-- -- mini.tabline을 쓰면 이 그룹들이 실제로 적용됩니다.
-- vim.api.nvim_set_hl(0, "MiniTablineFill", { bg = "NONE" })
--
-- -- inactive buffers: dim
-- vim.api.nvim_set_hl(0, "MiniTablineHidden", {
--   fg = inactive_fg,
--   bg = "NONE",
-- })
--
-- -- visible but not current (같은 탭에 보이는 버퍼): hover 느낌 대비
-- vim.api.nvim_set_hl(0, "MiniTablineVisible", {
--   fg = hover_fg,
--   bg = "NONE",
-- })
--
-- -- current buffer: accent
-- vim.api.nvim_set_hl(0, "MiniTablineCurrent", {
--   fg = accent_fg,
--   bg = "NONE",
--   italic = true,
--   bold = true,
-- })
--
-- -- modified 표시도 톤 맞춤(선택)
-- local modified_fg = c.orange or c.yellow or accent_fg
-- vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden",  { fg = modified_fg, bg = "NONE" })
-- vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { fg = modified_fg, bg = "NONE" })
-- vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { fg = modified_fg, bg = "NONE", bold = true })
--
-- -- =========================
-- -- Winbar (쓰는 경우 대비)
-- -- =========================
-- vim.api.nvim_set_hl(0, "WinBar",   { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
--
-- -- =========================
-- -- Treesitter: Python import 색 분리 (from / module path / symbol)
-- -- =========================
--
-- -- import 키워드(from/import)
-- vim.api.nvim_set_hl(0, "@keyword.import.python", { fg = c.cyan, italic = true })
-- vim.api.nvim_set_hl(0, "@keyword.import",        { fg = c.cyan, italic = true })
--
-- -- function 키워드(def/return/async/await 등 계열이 이쪽으로 잡히는 경우가 있음)
-- vim.api.nvim_set_hl(0, "@keyword.function.python", { fg = c.magenta, italic = false })
-- vim.api.nvim_set_hl(0, "@keyword.function",        { fg = c.magenta, italic = false })
--
-- -- 모듈 경로 (lerobot / datasets / lerobot_dataset)
-- vim.api.nvim_set_hl(0, "@module.python", { fg = c.blue })
-- vim.api.nvim_set_hl(0, "@module",        { fg = c.blue })
--
-- -- 필요 시: 일부 토큰이 @variable로 잡히는 경우도 있어서 대비를 더 주고 싶으면 켜기
-- -- (lerobot / datasets가 variable로도 잡히는 경우)
-- vim.api.nvim_set_hl(0, "@variable.python", { fg = c.cyan })
-- vim.api.nvim_set_hl(0, "@variable",        { fg = c.cyan })


-- =========================
-- GitHub theme
-- =========================
local ok_gh, github = pcall(require, "github-theme")
if not ok_gh then
  return
end

github.setup({
  options = {
    transparent = true,
    styles = {
      floats = "transparent",
    },
  },
})

vim.cmd.colorscheme("github_dark_default")

-- =========================
-- Minimal overrides (keep GitHub original tone)
-- =========================

-- Base transparency (원하는 컨셉 유지)
vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

-- ToggleTerm float 투명 (원래 하던 것 유지)
vim.api.nvim_set_hl(0, "ToggleTerm",            { bg = "NONE" })
vim.api.nvim_set_hl(0, "ToggleTermNormal",      { bg = "NONE" })
vim.api.nvim_set_hl(0, "ToggleTermNormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "ToggleTermBorder",      { bg = "NONE" })

-- LSP hover border: GitHub 테마의 Border 톤을 따르되, 둥근 테두리는 Noice preset으로 처리 권장
-- (색은 테마에 맡기고 싶으면 링크만)
local ok, palette = pcall(require, "github-theme.palette")
if ok then
  local c = palette.load(vim.g.colors_name)

  local blue = c.blue
  if type(blue) == "table" then
    blue = blue.base or blue.fg or blue[1]
  end

  vim.api.nvim_set_hl(0, "LspFloatBorder", {
    fg = blue,
    bg = "NONE",
  })
  vim.api.nvim_set_hl(0, "FloatBorder", { link = "LspFloatBorder" })
end

-- Tabline / mini.tabline: 테마 톤 유지 (색을 새로 지정하지 않고 link)
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLine",     { link = "Comment" })     -- inactive는 GitHub의 comment 톤
vim.api.nvim_set_hl(0, "TabLineSel",  { link = "Title" })       -- current는 Title 톤(과하지 않게 강조)

vim.api.nvim_set_hl(0, "MiniTablineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniTablineHidden",  { link = "Comment" })
vim.api.nvim_set_hl(0, "MiniTablineVisible", { link = "Normal" })
vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "Title" })

-- modified는 Diff/Diagnostic 계열을 쓰면 GitHub 톤이 유지됨
-- =========================
-- mini.tabline: Modified (bg 없음 + bold + GitHub modified 색)
-- =========================
do
  local okp, palette = pcall(require, "github-theme.palette")
  if okp then
    local c = palette.load(vim.g.colors_name)

    local function pick(v)
      if type(v) == "string" or type(v) == "number" then
        return v
      end
      if type(v) == "table" then
        return v.base or v.fg or v[1]
      end
    end

    -- GitHub 톤 유지: 변경(modified)은 보통 orange/yellow 계열이 자연스러움
    local modified_fg = pick(c.orange) or pick(c.yellow) or pick(c.magenta) or pick(c.blue)

    -- "활성 탭과 동일한 스타일"을 위해 Current(Title 링크) 스타일을 존중하되,
    -- bg는 무조건 NONE, modified는 bold로 강조
    vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
      fg = modified_fg,
      bg = "NONE",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
      fg = modified_fg,
      bg = "NONE",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
      fg = modified_fg,
      bg = "NONE",
      bold = true,
      -- 현재 탭을 Title로 링크해두셨으니(보통 bold/강조),
      -- italic까지 원하면 true, 원치 않으면 이 줄 삭제
      italic = true,
    })
  else
    -- 팔레트 로드 실패 시에도 배경이 생기지 않게 최소 안전 처리
    vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden",  { bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { bg = "NONE", bold = true })
  end
end

-- Treesitter: Python import 구분은 "색을 직접 찍지 말고" GitHub 기본 그룹을 재사용
-- import 키워드: PreProc 대신 Keyword 쪽으로 빼서 대비를 주되, 색은 테마가 정한 Keyword 사용
vim.api.nvim_set_hl(0, "@keyword.import.python", { link = "Keyword" })
vim.api.nvim_set_hl(0, "@keyword.import",        { link = "Keyword" })

-- module path: PreProc 대신 Identifier/Include 중 하나로(테마 톤 유지 목적)
vim.api.nvim_set_hl(0, "@module.python", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@module",        { link = "Identifier" })

-- function keyword: GitHub 톤 유지하며 구분
vim.api.nvim_set_hl(0, "@keyword.function.python", { link = "Statement" })
vim.api.nvim_set_hl(0, "@keyword.function",        { link = "Statement" })

-- =========================
-- Statusline transparency (fix lualine bg band)
-- =========================
vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

-- (선택) 커맨드라인/메시지 영역도 투명 톤 유지하고 싶으면
vim.api.nvim_set_hl(0, "MsgArea",   { bg = "NONE" })
vim.api.nvim_set_hl(0, "MsgSeparator", { bg = "NONE" })

-- (선택) split 경계선도 배경색 끼는 경우가 있어 함께 정리
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })

