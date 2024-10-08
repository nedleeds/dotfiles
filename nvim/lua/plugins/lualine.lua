return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
  config = function()
    local colors = {
      blue = "#80a0ff",
      blue2 = "#3fa3ff",
      cyan = "#79dac8",
      green = "#138933",
      black = "#080808",
      yellow = "#f3CC33",
      white = "#c6c6c6",
      red = "#ff5189",
      orange = "#ff9e64",
      violet = "#6f71ff",
      grey = "#303030",
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.green },
        b = { fg = colors.white },
        c = { fg = colors.white },
        y = { fg = colors.white },
      },

      insert = {
        a = { fg = colors.black, bg = colors.blue2 },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white },
        y = { fg = colors.white, bg = colors.grey },
      },
      visual = { a = { fg = colors.black, bg = colors.orange } },
      replace = { a = { fg = colors.black, bg = colors.cyan } },
      command = { a = { fg = colors.black, bg = colors.red } },

      inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white },
      },
    }

    require("lualine").setup({
      options = {
        theme = bubbles_theme,
        component_separators = "", -- 컴포넌트 구분자 제거
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "", fg = colors.green, bg = "NONE" }, right_padding = 2 } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", separator = { right = "", bg = "NONE" } } },
        lualine_x = { { "encoding", "fileformat", "filetype", color = { fg = "#ff9e64" } } },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = "", bg = "NONE" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {},
      extensions = {},
    })

    -- 하이라이트 그룹 설정
    vim.cmd([[
      hi CursorLineNr guifg=#FFA500 guibg=NONE gui=bold
      hi StatusLine guibg=NONE
      hi StatusLineNC guibg=NONE
      hi! StatusLineSeparator guifg=#33997f guibg=NONE
      hi! StatusLineSeparatorVisual guifg=#ff9e64 guibg=NONE
    ]])
  end,
}
