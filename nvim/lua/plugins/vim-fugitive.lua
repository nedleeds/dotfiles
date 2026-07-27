-- lua/plugins/fugitive.lua
vim.pack.add({ "https://github.com/tpope/vim-fugitive" })

vim.keymap.set("n", "gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>",       { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "Git diff split" })
vim.keymap.set("n", "<leader>gl", "<cmd>vertical Git log --oneline --decorate<cr>", { desc = "Git log" })
