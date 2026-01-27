local M = {}

function M.setup(opts)
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  wk.setup(opts)

  -- =========================================================
  -- Highlights
  -- =========================================================
  local function fix_which_key_hl()
    -- which-key core (slightly GitHub Dark-ish)
    vim.api.nvim_set_hl(0, "WhichKey",          { link = "Keyword" })
    vim.api.nvim_set_hl(0, "WhichKeyDesc",      { link = "Comment" })     -- 기존 Normal -> Comment 추천
    vim.api.nvim_set_hl(0, "WhichKeyGroup",     { link = "Title" })
    vim.api.nvim_set_hl(0, "WhichKeySeparator", { link = "NonText" })     -- Comment보다 덜 튀게
    vim.api.nvim_set_hl(0, "WhichKeyBorder",    { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "WhichKeyNormal",    { link = "NormalFloat" })

    -- icon palette (GitHub Dark friendly, balanced saturation)
    -- 참고: https://primer.style/primitives/colors (GitHub Primer 계열 감각)
    vim.api.nvim_set_hl(0, "WKIconExplorer", { fg = "#79C0FF", bold = true }) -- blue
    vim.api.nvim_set_hl(0, "WKIconUI",       { fg = "#D2A8FF", bold = true }) -- purple
    vim.api.nvim_set_hl(0, "WKIconConfig",   { fg = "#E3B341", bold = true }) -- amber/yellow
    vim.api.nvim_set_hl(0, "WKIconFile",     { fg = "#56D4DD", bold = true }) -- cyan
    vim.api.nvim_set_hl(0, "WKIconFormat",   { fg = "#FFA657", bold = true }) -- warm orange
    vim.api.nvim_set_hl(0, "WKIconFind",     { fg = "#7EE787", bold = true }) -- green
    vim.api.nvim_set_hl(0, "WKIconBuffer",   { fg = "#A5D6FF", bold = true }) -- pale blue (distinct from Explorer)
    vim.api.nvim_set_hl(0, "WKIconDebug",    { fg = "#FF7B72", bold = true }) -- red
    vim.api.nvim_set_hl(0, "WKIconGit",      { fg = "#FF9E64", bold = true }) -- orange (primary accent)
    vim.api.nvim_set_hl(0, "WKIconLSP",      { fg = "#A371F7", bold = true }) -- violet (deeper than UI)
    vim.api.nvim_set_hl(0, "WKIconWindow",   { fg = "#8B949E", bold = true }) -- neutral gray (window = “chrome”)
    vim.api.nvim_set_hl(0, "WKIconSession",  { fg = "#C9D1D9", bold = true }) -- light gray
    vim.api.nvim_set_hl(0, "WKIconOn",       { fg = "#3FB950", bold = true }) -- green (success)
    vim.api.nvim_set_hl(0, "WKIconOff",      { fg = "#F85149", bold = true }) -- red (danger)
    vim.api.nvim_set_hl(0, "WKIconNotify",   { fg = "#FF9E64", bold = true }) -- orange (notify)
  end

  -- =========================================================
  -- Whitespace toggle (dynamic desc)
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
    wk.add({
      {
        "<leader>.",
        desc = "UI: Whitespace(" .. ws_state() .. ")",
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
end

return M
