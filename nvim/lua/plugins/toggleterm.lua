vim.pack.add({
    {src = "https://github.com/akinsho/toggleterm.nvim"},
})

require("toggleterm").setup({
  shade_terminals = true,
  shading_factor = 1,
  open_mapping = [[<C-\>]],
  direction = "float",
  float_opts = {
    border = "rounded",
    winblend = 0,
  },
})
