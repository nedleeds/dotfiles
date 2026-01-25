local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.setup({
  preset = "helix",
  delay = 50,

  plugins = {
    spelling = { enabled = true, suggestions = 20 },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },


  win = {
    title = false,
    wo = { winblend = 1 },
  },

  layout = {
    width = { min = 18, max = 30 },
    spacing = 1,
  },

  -- v3: icons 테이블을 직접 정의하면 default merge가 깨질 수 있으니
  -- mappings를 명시적으로 켜서 아이콘 컬럼이 항상 나오게 보장합니다.
  icons = {
    mappings = true, -- ✅ 핵심: 아이콘 컬럼 ON
    breadcrumb = "»",
    separator = "➜",
    group = "+",
    ellipsis = "…",
  },

  show_help = true,
  show_keys = true,
})

-- =========================================================
-- Highlights (theme-friendly links)
-- =========================================================
local function fix_which_key_hl()
  -- =====================================================
  -- which-key core
  -- =====================================================
  vim.api.nvim_set_hl(0, "WhichKey",          { link = "Keyword" })
  vim.api.nvim_set_hl(0, "WhichKeyDesc",      { link = "Normal" })
  vim.api.nvim_set_hl(0, "WhichKeyGroup",     { link = "Title" })
  vim.api.nvim_set_hl(0, "WhichKeySeparator", { link = "Comment" })
  vim.api.nvim_set_hl(0, "WhichKeyBorder",    { link = "FloatBorder" })
  vim.api.nvim_set_hl(0, "WhichKeyNormal",    { link = "NormalFloat" })

  -- =====================================================
  -- icon palette (explicit colors = theme independent)
  -- =====================================================

  -- Explorer (folder) → blue
  vim.api.nvim_set_hl(0, "WKIconExplorer", { fg = "#61afef", bold = true })

  -- UI / Noice / misc → pink
  vim.api.nvim_set_hl(0, "WKIconUI", { fg = "#c678dd", bold = true })

  -- Config / reload → yellow
  vim.api.nvim_set_hl(0, "WKIconConfig", { fg = "#e5c07b", bold = true })

  -- File / quit → light cyan
  vim.api.nvim_set_hl(0, "WKIconFile", { fg = "#56b6c2", bold = true })

  -- Format → amber
  vim.api.nvim_set_hl(0, "WKIconFormat", { fg = "#d19a66", bold = true })

  -- Find (돋보기) → green (요청사항)
  vim.api.nvim_set_hl(0, "WKIconFind", { fg = "#00d75f", bold = true })

  -- Buffer → teal
  vim.api.nvim_set_hl(0, "WKIconBuffer", { fg = "#2bbac5", bold = true })

  -- Debug → red
  vim.api.nvim_set_hl(0, "WKIconDebug", { fg = "#e86671", bold = true })

  -- Git → orange
  vim.api.nvim_set_hl(0, "WKIconGit", { fg = "#f08c2e", bold = true })

  -- LSP → purple
  vim.api.nvim_set_hl(0, "WKIconLSP", { fg = "#a377ff", bold = true })

  -- Window → soft gray-blue
  vim.api.nvim_set_hl(0, "WKIconWindow", { fg = "#7f9cf5", bold = true })

  -- Session → muted blue-gray
  vim.api.nvim_set_hl(0, "WKIconSession", { fg = "#6c7086", bold = true })

  -- Toggle states
  vim.api.nvim_set_hl(0, "WKIconOn",  { fg = "#22c55e", bold = true })
  vim.api.nvim_set_hl(0, "WKIconOff", { fg = "#ef4444", bold = true })
end

-- =========================================================
-- Whitespace toggle (v3 icon table + dynamic desc)
-- =========================================================
local function apply_listchars_if_on()
  if vim.opt.list:get() then
    vim.opt.listchars = { tab = ">>", trail = "." }
  end
end

local function ws_state()
  return vim.opt.list:get() and "ON" or "OFF"
end

local function ws_icon()
  local on = vim.opt.list:get()
  return {
    icon = on and "󰔡" or "󰔢",
    hl = on and "WKIconOn" or "WKIconOff",
  }
end

function _G.refresh_ws_wk()
  -- <leader>. 엔트리를 “단일 소스”로 유지 (중복 등록 방지)
  wk.add({
    {
      "<leader>.",
      desc = "UI: Whitespace (" .. ws_state() .. ")",
      icon = ws_icon(),
    },
  })
end

function _G.toggle_whitespace()
  vim.opt.list = not vim.opt.list:get()
  apply_listchars_if_on()
  _G.refresh_ws_wk()
end

-- Apply once now + re-apply on colorscheme
fix_which_key_hl()
_G.refresh_ws_wk()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("DHLWhichKeyHL", { clear = true }),
  callback = function()
    fix_which_key_hl()
    _G.refresh_ws_wk()
  end,
})
