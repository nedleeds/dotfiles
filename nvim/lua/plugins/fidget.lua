vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })

require("fidget").setup({
  progress = {
    display = {
      done_icon = "✓",
    },
  },
  notification = {
    window = {
      winblend = 0,   -- 배경 투명 (transparent 쓰시면)
      align = "bottom",
      x_padding = 1,
      y_padding = 1,
    },
  },
})
