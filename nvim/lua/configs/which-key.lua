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

    hl(0, "WKIconFind",   { fg = "#7EE787", bold = true })
    hl(0, "WKIconGit",    { fg = "#FF9E64", bold = true })
    hl(0, "WKIconBuffer", { fg = "#A5D6FF", bold = true })
    hl(0, "WKIconLSP",    { fg = "#A371F7", bold = true })
    hl(0, "WKIconUI",     { fg = "#D2A8FF", bold = true })
    hl(0, "WKIconFile",   { fg = "#56D4DD", bold = true })
    hl(0, "WKIconNotify", { fg = "#FF9E64", bold = true })
    hl(0, "WKIconOn",     { fg = "#3FB950", bold = true })
    hl(0, "WKIconOff",    { fg = "#F85149", bold = true })
  end

  fix_hl()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("WhichKeyHL", { clear = true }),
    callback = fix_hl,
  })

  wk.add({
    { "<leader>f",  group = "Find",          icon = { icon = "󰍉", hl = "WKIconFind" } },
    { "<leader>g",  group = "Git",           icon = { icon = "󰊤", hl = "WKIconGit" } },
    { "<leader>s",  group = "Search",        icon = { icon = "󰔟", hl = "WKIconFind" } },
    { "<leader>b",  group = "Buffer/Bookmark", icon = { icon = "󰓩", hl = "WKIconBuffer" } },
    { "<leader>m",  group = "Messages",      icon = { icon = "󰯪", hl = "WKIconNotify" } },
    { "<leader>r",  group = "Refactor",      icon = { icon = "󱍓", hl = "WKIconLSP" } },
  })
end

return M
