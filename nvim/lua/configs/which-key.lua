local M = {}

function M.setup(opts)
  local wk = require("which-key")
  wk.setup(opts)

  local function fix_hl()
    local hl = vim.api.nvim_set_hl
    hl(0, "WhichKey",          { link = "Keyword" })
    hl(0, "WhichKeyDesc",      { link = "Comment" })
    hl(0, "WhichKeyGroup",     { link = "Title" })
    hl(0, "WhichKeySeparator", { link = "NonText" })
    hl(0, "WhichKeyBorder",    { link = "FloatBorder" })
    hl(0, "WhichKeyNormal",    { link = "NormalFloat" })

    hl(0, "WKIconExplorer", { fg = "#79C0FF", bold = true }) -- blue
    hl(0, "WKIconUI",       { fg = "#D2A8FF", bold = true }) -- purple
    hl(0, "WKIconConfig",   { fg = "#E3B341", bold = true }) -- amber/yellow
    hl(0, "WKIconFile",     { fg = "#56D4DD", bold = true }) -- cyan
    hl(0, "WKIconFormat",   { fg = "#FFA657", bold = true }) -- warm orange
    hl(0, "WKIconFind",     { fg = "#7EE787", bold = true }) -- green
    hl(0, "WKIconBuffer",   { fg = "#A5D6FF", bold = true }) -- pale blue (distinct from Explorer)
    hl(0, "WKIconDebug",    { fg = "#FF7B72", bold = true }) -- red
    hl(0, "WKIconGit",      { fg = "#FF9E64", bold = true }) -- orange (primary accent)
    hl(0, "WKIconLSP",      { fg = "#A371F7", bold = true }) -- violet (deeper than UI)
    hl(0, "WKIconWindow",   { fg = "#8B949E", bold = true }) -- neutral gray (window = “chrome”)
    hl(0, "WKIconSession",  { fg = "#C9D1D9", bold = true }) -- light gray
    hl(0, "WKIconOn",       { fg = "#3FB950", bold = true }) -- green (success)
    hl(0, "WKIconOff",      { fg = "#F85149", bold = true }) -- red (danger)
    hl(0, "WKIconNotify",   { fg = "#FF9E64", bold = true }) -- orange (notify)
  end

  fix_hl()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("WhichKeyHL", { clear = true }),
    callback = fix_hl,
  })

  wk.add({
    { "<leader>E",  group = "Open Explorer", icon = { icon = "", hl = "WKIconExplorer" } },
    { "<leader>f",  group = "Find",          icon = { icon = "", hl = "WKIconFind" } },
    { "<leader>g",  group = "Git",           icon = { icon = "󰊤", hl = "WKIconGit" } },
    { "<leader>s",  group = "Session",        icon = { icon = "", hl = "WKIconFind" } },
    { "<leader>b",  group = "Buffer/Bookmark", icon = { icon = "󰓩", hl = "WKIconBuffer" } },
    { "<leader>m",  group = "Messages",      icon = { icon = "󰅾", hl = "WKIconNotify" } },
    { "<leader>r",  group = "Refactor",      icon = { icon = "󱍓", hl = "WKIconLSP" } },
    { "<leader>w",  group = "Window",        icon = { icon = "󱂬", hl = "WKIconLSP" } },
  })
end

return M
