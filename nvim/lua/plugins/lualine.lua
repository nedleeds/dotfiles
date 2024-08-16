return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
  config = function()
    local colors = {
      blue = "#3fa3ff",
      cyan = "#79dac8",
      green = "#33997f",
      black = "#080808",
      yellow = "#f3CC33",
      white = "#c6c6c6",
      red = "#ff5189",
      organge = "#ff9e64",
      violet = "#6f71ff",
      grey = "#303030",
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.black, bg = colors.green, gui = "bold" },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white },
      },
      insert = { a = { fg = colors.black, bg = colors.blue2, gui = "bold" } },
      visual = { a = { fg = colors.black, bg = colors.organge, gui = "bold" } },
      replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },
      inactive = {
        a = { fg = colors.white, gui = "bold" },
        b = { fg = colors.white },
        c = { fg = colors.white },
      },
    }

    require("lualine").setup({
      options = {
        theme = bubbles_theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", separator = { right = "" } } },
        lualine_x = { { "encoding", "fileformat", "filetype", color = { fg = colors.organge } } },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
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
    ]])
  end,
}
