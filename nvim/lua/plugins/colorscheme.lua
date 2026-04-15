return {
  "projekt0n/github-nvim-theme",
  name = "github-theme",
  lazy = false,
  priority = 1000,
  config = function(_, opts)
    require("github-theme").setup(opts)
    vim.cmd.colorscheme("github_dark_default")

    local hl = vim.api.nvim_set_hl
    hl(0, "LspFloatBorder", { fg = "#7aa2f7", bg = "NONE" })
    hl(0, "FloatBorder",    { link = "LspFloatBorder" })
    hl(0, "SnacksTermBorder", { fg = "#30363d" })

    hl(0, "Normal",      { bg = "NONE" })
    hl(0, "NormalNC",    { bg = "NONE" })
    hl(0, "NormalFloat", { bg = "NONE" })

    hl(0, "TabLineFill",        { bg = "NONE" })
    hl(0, "TabLine",            { link = "Comment" })
    hl(0, "TabLineSel",         { link = "Title", bg = "NONE" })
    hl(0, "MiniTablineFill",    { bg = "NONE" })
    hl(0, "MiniTablineHidden",  { link = "Comment" })
    hl(0, "MiniTablineVisible", { link = "Normal" })
    hl(0, "MiniTablineCurrent", { link = "Title", bg = "NONE" })

    hl(0, "StatusLine",   { bg = "NONE" })
    hl(0, "StatusLineNC", { bg = "NONE" })
    hl(0, "MsgArea",      { bg = "NONE" })
    hl(0, "MsgSeparator", { bg = "NONE" })
    hl(0, "WinSeparator", { fg = "#30363d" })

    hl(0, "CursorLine", { bg = "#0f1114" })

    hl(0, "BlinkCmpMenuBorder",   { link = "FloatBorder" })
    hl(0, "BlinkCmpDocBorder",    { link = "FloatBorder" })
  end,
}
