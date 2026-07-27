vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.env.CC = "clang"

require("configs.options")
require("configs.keymaps")
require("configs.diagnostics")
require("configs.builtin")
require("configs.neovide")

require("plugins.github-theme")
-- require("plugins.techbase")
require("plugins.gitsigns")
require("plugins.vim-fugitive")
require("plugins.which-key")
require("plugins.mini")
require("plugins.lsp")
require("plugins.toggleterm")
require("plugins.neoscroll")
require("plugins.nvim-treesitter")
require("plugins.render-markdown")
require("plugins.vim-illuminate")
require("plugins.fidget")
