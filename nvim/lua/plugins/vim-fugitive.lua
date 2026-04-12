return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gread", "Gwrite", "Gclog", "Gbrowse" },
  keys = {
    { "<leader>g",  "",                        desc = "+Git" },
    { "<leader>gg", "<cmd>Git<cr>",            desc = "Status (fugitive)" },
    { "<leader>gb", "<cmd>Git blame<cr>",      desc = "Blame" },
    { "<leader>gd", "<cmd>Git diff<cr>",       desc = "Diff" },
    { "<leader>gc", "<cmd>Git commit<cr>",     desc = "Commit" },
    { "<leader>gp", "<cmd>Git push<cr>",       desc = "Push" },
    { "<leader>gP", "<cmd>Git pull<cr>",       desc = "Pull" },
    { "<leader>gf", "<cmd>Gvdiffsplit<cr>",    desc = "File diff (vsplit)" },
  },
}
