vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorcolumn = false

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.o.swapfile = false
vim.o.signcolumn = "yes"
vim.o.splitright = true
vim.o.showtabline = 2
vim.o.termguicolors = true

-- Hide end-of-buffer "~"
vim.o.fillchars = "eob: "
vim.o.shell = "pwsh"

if vim.fn.has("unnamedplus") == 1 then
  vim.o.clipboard = "unnamedplus"
else
  vim.o.clipboard = "unnamed"
end

