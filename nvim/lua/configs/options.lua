-- Disable unused providers to skip binary lookups at startup
vim.g.loaded_perl_provider    = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_node_provider    = 0
vim.g.loaded_python3_provider = 0

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.fillchars      = { eob = " " }
vim.opt.clipboard      = "unnamedplus"
vim.opt.expandtab      = true
vim.opt.shiftwidth     = 2
vim.opt.tabstop        = 2
vim.opt.smartindent    = true
vim.opt.breakindent    = true
vim.opt.cursorline     = true
vim.opt.signcolumn     = "yes"
vim.opt.updatetime     = 250
vim.opt.timeoutlen     = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.diagnostic.config({ float = { border = "rounded" } })
