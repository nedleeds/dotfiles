-- lua/plugins/mini-tabline.lua
vim.pack.add({
  { src = "https://github.com/echasnovski/mini.tabline" },
})

require("mini.tabline").setup({
  show_icons = false,
})

