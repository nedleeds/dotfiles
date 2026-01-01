vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  -- lualine 아이콘이 필요하면(권장):
  { src = "https://github.com/nvim-tree/nvim-web-devicons", opt = true },
})

local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

local colors = {
  blue = "#80a0ff",
  blue2 = "#3fa3ff",
  cyan = "#79dac8",
  green = "#07ba5a",
  black = "#080808",
  yellow = "#f3CC33",
  white = "#f6f6f6",
  red = "#ff5189",
  orange = "#ff9e64",
  violet = "#6f71ff",
  grey = "#303030",
}

-- 원래 스타일 유지: mode bubble(좌측) 배경색이 모드에 따라 바뀜
local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.green, gui = "bold" },
    b = { fg = colors.white }, -- bg 지정 안 하면 테마 기본/투명에 맡김
    c = { fg = colors.white },
    y = { fg = colors.white },
  },

  insert = {
    a = { fg = colors.black, bg = colors.blue2, gui = "bold" },
    b = { fg = colors.white, bg = colors.grey },      -- ✅ 원래 코드 느낌
    c = { fg = colors.white },
    y = { fg = colors.white, bg = colors.grey  },      -- ✅ 원래 코드 느낌
  },

  visual  = { a = { fg = colors.black, bg = colors.orange, gui = "bold" } },
  replace = { a = { fg = colors.black, bg = colors.cyan, gui = "bold" } },
  command = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

require("lualine").setup({
  options = {
    theme = bubbles_theme,
    component_separators = "",
    section_separators = { left = "", right = "" },
    -- globalstatus = true, -- 필요하면 켜기
  },
  sections = {
    -- ✅ 좌측 mode bubble: 배경색은 bubbles_theme.a에서 모드별로 자동 적용됨
    lualine_a = {
      { "mode", separator = { left = "" } },
    },
    lualine_b = {  "branch", "diff", "diagnostics" },
    lualine_c = {
      { "lsp_status" , separator = { right = "", bg = "NONE" } },
    },
    lualine_x = {
      { "encoding", "filesize", "fileformat", "filetype", color = { fg = colors.orange } },
    },
    lualine_y = { "progress" },
    lualine_z = {
      { "location", separator = { right = "", bg = "NONE" }},
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
})
