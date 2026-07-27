vim.pack.add({
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

-- 헤딩 색상
local hl = vim.api.nvim_set_hl
hl(0, "MdH1", { fg = "#E06C75", bg = "none", bold = true })
hl(0, "MdH2", { fg = "#98C379", bg = "none", bold = true })
hl(0, "MdH3", { fg = "#61AFEF", bg = "none", bold = true })
hl(0, "MdH4", { fg = "#D19A66", bg = "none", bold = true })
hl(0, "MdH5", { fg = "#C678DD", bg = "none", bold = true })
hl(0, "MdH6", { fg = "#56B6C2", bg = "none", bold = true })

require("render-markdown").setup({
    anti_conceal = { enabled = true },
    heading = {
        position    = "inline",
        icons       = { "┃ ", "┃ ", "┃ ", "┃ ", "┃ ", "┃ " },
        signs       = { "H1", "H2", "H3", "H4", "H5", "H6" },
        backgrounds = {},
        foregrounds = { "MdH1", "MdH2", "MdH3", "MdH4", "MdH5", "MdH6" },
    },
    bullet = {
        icons = { "· ", "◦ ", "• ", "∙ " },
    },
    code = {
        render_modes   = true,
        sign           = false,
        position       = "left",
        language       = false,
        border         = "thin",
        width          = "block",
        language_right = "",
        language_left  = "",
        above          = "",
        below          = "",
        left_pad       = 2,
        right_pad      = 2,
        inline         = true,
        inline_pad     = 0,
        style          = "language",
    },
})
