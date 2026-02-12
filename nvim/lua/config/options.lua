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
vim.opt.fillchars = {
  eob = " ",
  vert = "▏",
}

if vim.fn.has("win32") == 1 then
  if vim.fn.executable("pwsh") == 1 then
    vim.opt.shell = "pwsh"
  else
    vim.opt.shell = "powershell.exe"
  end

  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

if vim.fn.has("unnamedplus") == 1 then
  vim.o.clipboard = "unnamedplus"
else
  vim.o.clipboard = "unnamed"
end

vim.opt.autoread = true
