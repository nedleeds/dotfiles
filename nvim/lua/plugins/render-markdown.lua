return {
    'MeanderingProgrammer/render-markdown.nvim',
    init = function()
        local hl = vim.api.nvim_set_hl
        hl(0, 'MdH1', { fg = '#E06C75', bg = 'none', bold = true })
        hl(0, 'MdH2', { fg = '#98C379', bg = 'none', bold = true })
        hl(0, 'MdH3', { fg = '#61AFEF', bg = 'none', bold = true })
        hl(0, 'MdH4', { fg = '#D19A66', bg = 'none', bold = true })
        hl(0, 'MdH5', { fg = '#C678DD', bg = 'none', bold = true })
        hl(0, 'MdH6', { fg = '#56B6C2', bg = 'none', bold = true })
    end,
    opts = {
        heading = {
            position = 'inline',
            icons = { '┃ ', '┃ ', '┃ ', '┃ ', '┃ ', '┃ ' },
            signs = { 'H1', 'H2', 'H3', 'H4', 'H5', 'H6' },
            backgrounds = {},
            foregrounds = { 'MdH1', 'MdH2', 'MdH3', 'MdH4', 'MdH5', 'MdH6' },
        },
        bullet = {
            icons = { '· ', '◦ ', '• ', '∙ ' },
        },
        code = {
            width = 'block',
            border = 'thin',
            style = 'normal'
        },
    }
}
