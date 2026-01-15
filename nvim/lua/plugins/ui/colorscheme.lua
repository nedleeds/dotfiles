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
-- GitHub Theme
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
-- Helpers
-- =========================
local set = function(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

local link = function(from, to)
  set(from, { link = to })
end

local function make_palette()
  local okp, palette = pcall(require, "github-theme.palette")
  if not okp then
    return nil
  end

  local colors = palette.load(vim.g.colors_name)

  local function pick(v)
    if type(v) == "string" or type(v) == "number" then
      return v
    end
    if type(v) == "table" then
      return v.base or v.fg or v[1]
    end
    return nil
  end

  return {
    c = colors,
    pick = pick,
  }
end

local P = make_palette()

-- =========================
-- Base transparency
-- =========================
set("Normal",      { bg = "NONE" })
set("NormalNC",    { bg = "NONE" })
set("NormalFloat", { bg = "NONE" })

-- =========================
-- ToggleTerm transparency
-- =========================
set("ToggleTerm",            { bg = "NONE" })
set("ToggleTermNormal",      { bg = "NONE" })
set("ToggleTermNormalFloat", { bg = "NONE" })
set("ToggleTermBorder",      { bg = "NONE" })

-- =========================
-- Float borders (LSP/Diagnostics)
--   - 하나의 색으로 통일해서 충돌/재링크 이슈 제거
-- =========================
do
  local border = "#58a6ff" -- fallback
  local black = "#000000"
  if P then
    border = P.pick(P.c.blue) or border
    black = P.pick(P.c.black) or black
  end

  set("FloatBorder", { fg = border, bg =black })
  link("LspFloatBorder", "FloatBorder")
  link("DiagnosticFloatBorder", "FloatBorder")
end

-- =========================
-- Tabline / mini.tabline
-- =========================
set("TabLineFill", { bg = "NONE" })
link("TabLine", "Comment")
link("TabLineSel", "Title")

set("MiniTablineFill", { bg = "NONE" })
link("MiniTablineHidden", "Comment")
link("MiniTablineVisible", "Normal")
link("MiniTablineCurrent", "Title")

-- mini.tabline: Modified
do
  local modified_fg
  if P then
    modified_fg =
      P.pick(P.c.orange)
      or P.pick(P.c.yellow)
      or P.pick(P.c.magenta)
      or P.pick(P.c.blue)
  end

  if modified_fg then
    set("MiniTablineModifiedHidden",  { fg = modified_fg, bg = "NONE", bold = true })
    set("MiniTablineModifiedVisible", { fg = modified_fg, bg = "NONE", bold = true })
    set("MiniTablineModifiedCurrent", { fg = modified_fg, bg = "NONE", bold = true, italic = true })
  else
    set("MiniTablineModifiedHidden",  { bg = "NONE", bold = true })
    set("MiniTablineModifiedVisible", { bg = "NONE", bold = true })
    set("MiniTablineModifiedCurrent", { bg = "NONE", bold = true })
  end
end

-- =========================
-- Treesitter links
-- =========================
link("@keyword.import.python", "Keyword")
link("@keyword.import",        "Keyword")

link("@module.python", "Identifier")
link("@module",        "Identifier")

link("@keyword.function.python", "Statement")
link("@keyword.function",        "Statement")

-- =========================
-- Statusline / UI transparency
-- =========================
set("StatusLine",   { bg = "NONE" })
set("StatusLineNC", { bg = "NONE" })

set("MsgArea",      { bg = "NONE" })
set("MsgSeparator", { bg = "NONE" })
set("WinSeparator", { bg = "NONE" })

-- =========================
-- nvim-notify (WARNING FIX)
-- =========================
do
  local ok_notify, notify = pcall(require, "notify")

  local bg = "#0d1117" -- GitHub dark default fallback
  if P then
    bg = P.pick(P.c.bg0) or P.pick(P.c.bg) or P.pick(P.c.black) or bg
  end

  -- notify는 배경을 NONE로 두면 경고/에러가 보기 안 좋아지는 경우가 있어 고정 bg 사용
  set("NotifyBackground", { bg = bg })

  -- 반투명 느낌(터미널 투명 + notify 가독성 타협)
  link("NotifyINFOBody",  "NotifyBackground");  set("NotifyINFOBody",  { blend = 15 })
  link("NotifyWARNBody",  "NotifyBackground");  set("NotifyWARNBody",  { blend = 15 })
  link("NotifyERRORBody", "NotifyBackground");  set("NotifyERRORBody", { blend = 15 })
  link("NotifyDEBUGBody", "NotifyBackground");  set("NotifyDEBUGBody", { blend = 15 })
  link("NotifyTRACEBody", "NotifyBackground");  set("NotifyTRACEBody", { blend = 15 })

  if ok_notify then
    notify.setup({
      background_colour = "NotifyBackground",
    })
  end
end

