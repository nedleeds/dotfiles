-- Disable unused providers to skip binary lookups at startup
vim.g.loaded_perl_provider    = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_node_provider    = 0
vim.g.loaded_python3_provider = 0

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.fillchars      = { eob = " " }
vim.opt.expandtab      = true
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = { "win32yank.exe", "-i", "--crlf" },
    ["*"] = { "win32yank.exe", "-i", "--crlf" },
  },
  paste = {
    ["+"] = { "win32yank.exe", "-o", "--lf" },
    ["*"] = { "win32yank.exe", "-o", "--lf" },
  },
  cache_enabled = 0,
}
vim.opt.shiftwidth     = 2
vim.opt.tabstop        = 2
vim.opt.smartindent    = true
vim.opt.breakindent    = true
vim.opt.cursorline     = true
vim.opt.signcolumn     = "yes"
vim.opt.updatetime     = 250

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.diagnostic.config({ float = { border = "rounded" } })
vim.api.nvim_set_hl(0, "@markup.raw", { italic = false })
vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { italic = false })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = "#ff9d5c", bg = "#2a1f1a", bold = true, italic = false })
