vim.opt.encoding = "utf-8"
vim.opt.fileencodings = {
  "utf-8",
  "cp949",
  "euc-kr",
  "latin1",
}
vim.opt.fileencoding = "utf-8"
vim.opt.bomb = true


-- UI / editor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.termguicolors = true

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Files
vim.opt.swapfile = false
vim.opt.fillchars = { eob = " " }

-- Whitespace visualize
vim.opt.list = true
vim.opt.listchars = {
  tab = ">-",
  trail = ".",
  extends = ">",
  precedes = "<",
  nbsp = "+"
}


-- Clipboard
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = "unnamedplus"
else
  vim.opt.clipboard = "unnamed"
end

-- Trim trailing whitespace (exclude markdown)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "markdown" then return end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

