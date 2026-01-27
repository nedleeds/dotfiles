return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
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

      local bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.green, gui = "bold" },
          b = { fg = colors.white },
          c = { fg = colors.white },
          y = { fg = colors.white },
        },
        insert = {
          a = { fg = colors.black, bg = colors.blue2, gui = "bold" },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.white },
          y = { fg = colors.white, bg = colors.grey },
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

      -- opencode statusline (없어도 안전)
      local opencode_component = nil
      do
        local ok_oc, oc = pcall(require, "opencode")
        if ok_oc and type(oc.statusline) == "function" then
          opencode_component = oc.statusline
        end
      end

      -- lualine_x 구성 (nil 제거로 안전하게)
      local lualine_x = {
        opencode_component and { opencode_component, color = { fg = colors.orange } } or nil,
        { "encoding" },
        { "filesize" },
        { "fileformat"},
        { "filetype" },
      }

      local filtered_x = {}
      for _, v in ipairs(lualine_x) do
        if v ~= nil then table.insert(filtered_x, v) end
      end

      lualine.setup({
        options = {
          theme = bubbles_theme,
          component_separators = "",
          section_separators = { left = "", right = "" },
          -- globalstatus = true,
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" } } },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "lsp_status", separator = { right = "", bg = "NONE" } } },
          lualine_x = filtered_x,
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { right = "", bg = "NONE" } } },
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
    end,
  },
}
