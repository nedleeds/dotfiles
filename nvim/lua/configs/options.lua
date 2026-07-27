-- UI
vim.opt.termguicolors  = true
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = true
vim.opt.signcolumn     = "yes"
vim.opt.winborder      = "rounded"
vim.opt.list           = false
vim.opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }

-- edit
vim.opt.mouse       = "a"
vim.opt.clipboard   = "unnamedplus"
vim.opt.undofile    = true
vim.opt.hlsearch    = true
vim.opt.breakindent = true
vim.opt.wrap        = true
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true
vim.opt.textwidth   = 80

-- split window
vim.opt.splitright = true

-- PowerShell
vim.opt.shell        = "pwsh"
vim.opt.shellcmdflag = "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote   = ""
vim.opt.shellxquote  = ""

-- turn off warning of swp
vim.opt.shortmess:append("A")

-- autocomplete
vim.opt.autocomplete = true                                     -- insert 모드 자동 완성
vim.opt.completeopt = "menu,menuone,noselect,popup"             -- noselect: 첫 항목 자동 선택 방지
vim.opt.pumborder = "rounded"                                   -- 팝업 테두리
vim.opt.pummaxwidth = 40
vim.opt.pumheight = 10
vim.opt.pumblend = 15   -- 0(불투명) ~ 100(완전 투명)

vim.opt.scrolloff = 35
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.fn.system("im-select.exe 1033")
  end,
})

-- folding
vim.opt.foldmethod = "manual"
vim.opt.foldenable = false
vim.opt.foldcolumn = "1"
vim.opt.fillchars:append({
foldopen = "▼",
foldclose = "▶",
  foldsep = " ",
})
