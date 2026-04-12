return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  keys = {
    { "<leader>ff", function() require("fzf-lua").files() end,      desc = "Find Files" },
    { "<leader>fb", function() require("fzf-lua").buffers() end,    desc = "Find Buffers" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end,   desc = "Recent Files" },
    { "<leader>fg", function() require("fzf-lua").live_grep() end,  desc = "Live Grep" },
    { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "Search Word" },
  },
  opts = {},
}
