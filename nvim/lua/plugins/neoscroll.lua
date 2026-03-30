return {
  {
    "karb94/neoscroll.nvim",
    opts = {
      duration_multiplier = 0.5, 
      mappings = { '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    },
    keys = {
      { "<C-d>", function() require("neoscroll").scroll(10, true, 120) end, mode = { "n", "v", "x" }, desc = "Scroll down 10 lines" },
      { "<C-u>", function() require("neoscroll").scroll(-10, true, 120) end, mode = { "n", "v", "x" }, desc = "Scroll up 10 lines" },
    },
  },
}
