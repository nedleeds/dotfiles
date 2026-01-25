require("toggleterm").setup({
  shade_terminals = true,
  shading_factor = 0.2,
  open_mapping = [[<C-\>]],
  direction = "float",
  float_opts = {
    border = "rounded",
    winblend = 0,
  },
})
