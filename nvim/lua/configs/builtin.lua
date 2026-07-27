vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Undo 트리" })
vim.keymap.set("n", "<leader>D", "<cmd>DiffTool<CR>", { desc = "Diff 도구" })
