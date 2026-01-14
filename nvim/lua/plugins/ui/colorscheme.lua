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
-- Base transparency
-- =========================
vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

-- =========================
-- ToggleTerm transparency
-- =========================
vim.api.nvim_set_hl(0, "ToggleTerm",            { bg = "NONE" })
vim.api.nvim_set_hl(0, "ToggleTermNormal",      { bg = "NONE" })
vim.api.nvim_set_hl(0, "ToggleTermNormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "ToggleTermBorder",      { bg = "NONE" })

-- =========================
-- LSP Float Border (GitHub tone)
-- =========================
do
  local okp, palette = pcall(require, "github-theme.palette")
  if okp then
    local c = palette.load(vim.g.colors_name)

    local function pick(v)
      if type(v) == "string" then return v end
      if type(v) == "table" then return v.base or v.fg or v[1] end
    end

    local blue = pick(c.blue)

    vim.api.nvim_set_hl(0, "LspFloatBorder", {
      fg = blue,
      bg = "NONE",
    })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "LspFloatBorder" })
  end
end

-- =========================
-- Tabline / mini.tabline
-- =========================
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLine",     { link = "Comment" })
vim.api.nvim_set_hl(0, "TabLineSel",  { link = "Title" })

vim.api.nvim_set_hl(0, "MiniTablineFill",     { bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniTablineHidden",  { link = "Comment" })
vim.api.nvim_set_hl(0, "MiniTablineVisible", { link = "Normal" })
vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "Title" })

-- =========================
-- mini.tabline: Modified
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

    local modified_fg =
      pick(c.orange)
      or pick(c.yellow)
      or pick(c.magenta)
      or pick(c.blue)

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
      italic = true,
    })
  else
    vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden",  { bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { bg = "NONE", bold = true })
  end
end

-- =========================
-- Treesitter (GitHub tone reuse)
-- =========================
vim.api.nvim_set_hl(0, "@keyword.import.python", { link = "Keyword" })
vim.api.nvim_set_hl(0, "@keyword.import",        { link = "Keyword" })

vim.api.nvim_set_hl(0, "@module.python", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@module",        { link = "Identifier" })

vim.api.nvim_set_hl(0, "@keyword.function.python", { link = "Statement" })
vim.api.nvim_set_hl(0, "@keyword.function",        { link = "Statement" })

-- =========================
-- Statusline / UI transparency
-- =========================
vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

vim.api.nvim_set_hl(0, "MsgArea",      { bg = "NONE" })
vim.api.nvim_set_hl(0, "MsgSeparator", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })

-- =========================
-- nvim-notify (WARNING FIX)
-- =========================
do
  local okp, palette = pcall(require, "github-theme.palette")
  local bg = "#0d1117" -- GitHub dark default fallback

  if okp then
    local c = palette.load(vim.g.colors_name)

    local function pick(v)
      if type(v) == "string" then return v end
      if type(v) == "table" then return v.base or v.fg or v[1] end
    end

    bg = pick(c.bg0) or pick(c.bg) or pick(c.black) or bg
  end

  -- 기준 배경색 (NONE 금지)
  vim.api.nvim_set_hl(0, "NotifyBackground", { bg = bg })

  -- 시각적 투명도 유지
  vim.api.nvim_set_hl(0, "NotifyINFOBody",  { link = "NotifyBackground", blend = 15 })
  vim.api.nvim_set_hl(0, "NotifyWARNBody",  { link = "NotifyBackground", blend = 15 })
  vim.api.nvim_set_hl(0, "NotifyERRORBody", { link = "NotifyBackground", blend = 15 })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { link = "NotifyBackground", blend = 15 })
  vim.api.nvim_set_hl(0, "NotifyTRACEBody", { link = "NotifyBackground", blend = 15 })

  require("notify").setup({
    background_colour = "NotifyBackground",
  })
end
