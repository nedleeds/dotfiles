return {
  "christoomey/vim-tmux-navigator",
  lazy = false, -- 항상 로드되도록 설정
  config = function()
    -- Lazy.nvim이 모든 설정을 로드한 후에 키맵핑 설정 적용
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy", -- 모든 설정이 로드된 후 실행
      callback = function()
        vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { desc = "Navigate to the left pane in tmux" })
        vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { desc = "Navigate to the below pane in tmux" })
        vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { desc = "Navigate to the upper pane in tmux" })
        vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { desc = "Navigate to the right pane in tmux" })
      end,
    })
  end,
}
