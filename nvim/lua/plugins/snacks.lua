return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1001, -- github-theme(1000)보다 먼저 로드되어도 문제 없음

  opts = {
    input = { enabled = true },
    notifier = { enabled = true },
    terminal = { enabled = true, start_insert = true },
    hover = {
      enabled = true,
      border = "rounded",
      max_width = 80,
      max_height = 30,
    },
  },

  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
