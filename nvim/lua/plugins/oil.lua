return {
  "stevearc/oil.nvim",
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  keys = {
    { "<leader>-", "<cmd>Oil --float<cr>", desc = "Oil (float)" },
  },
  opts = {
    columns = {
      "icon",
      "permissions",
      { "size", format = "human_readable" },
      "mtime",
    },
    keymaps = {
      ["<Esc>"] = "actions.close",
      ["q"]     = "actions.close",
    },
    confirmation = {
      max_width  = 0.4,
      min_width  = 50,
      max_height = 0.2,
      min_height = 2,
      border     = "rounded",
      win_options = { winblend = 0 },
    },
    progress = {
      max_width         = 0.4,
      min_width         = 20,
      max_height        = 0.1,
      border            = "rounded",
      minimized_border  = "rounded",
      win_options = { winblend = 0 },
    },
    ssh          = { border = "rounded" },
    keymaps_help = { border = "rounded" },
    float = {
      padding    = 2,
      max_width  = 85,
      max_height = 0.25,
      border     = "rounded",
    },
  },
}
