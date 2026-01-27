return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gread", "Gwrite", "Gclog", "Gbrowse" },
    keys = {
      { "<leader>g",  "", desc = "+Git" },

      { "<leader>gs", "<cmd>Git<cr>",        desc = "Status" },
      { "<leader>gb", "<cmd>Git blame<cr>",  desc = "Blame" },
      { "<leader>gd", "<cmd>Git diff<cr>",   desc = "Diff" },
      { "<leader>gl", "<cmd>Git log<cr>",    desc = "Log" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
      { "<leader>gp", "<cmd>Git push<cr>",   desc = "Push" },
      { "<leader>gP", "<cmd>Git pull<cr>",   desc = "Pull" },

      -- 편의: 현재 파일 diff (3-way 상황에서도 유용)
      { "<leader>gf", "<cmd>Gvdiffsplit<cr>", desc = "File diff (vsplit)" },
    },
  },
}
