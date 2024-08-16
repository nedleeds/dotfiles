return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = true,
  priority = 1000,
  config = function()
    vim.g.moonflyTransparent = true
    vim.cmd("colorscheme moonfly")
  end,
}
