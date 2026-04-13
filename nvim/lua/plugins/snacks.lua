return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    notifier = { enabled = true },
    input    = { enabled = true },
    picker   = { enabled = true, ui_select = true },
    words    = { enabled = false },
    styles = {
      notification_history = {
        position = "bottom",
        height   = 0.3,
        border   = "none",
        wo       = { winbar = " Notification History  ", number = false, relativenumber = false, signcolumn = "no", foldcolumn = "1" },
      },
    },
    terminal = {
      enabled = true,
      win = {
        keys = {
          nav_h = { "<C-h>", function() vim.cmd("wincmd h") end, desc = "Go to left window",  mode = { "n", "t" } },
          nav_j = { "<C-j>", function() vim.cmd("wincmd j") end, desc = "Go to down window", mode = { "n", "t" } },
          nav_k = { "<C-k>", function() vim.cmd("wincmd k") end, desc = "Go to up window",   mode = { "n", "t" } },
          nav_l = { "<C-l>", function() vim.cmd("wincmd l") end, desc = "Go to right window", mode = { "n", "t" } },
        },
      },
    },
  },
  keys = {
    { "<leader>mm", function()
      local lines = vim.split(vim.fn.execute("messages"), "\n", { trimempty = true })
      lines = vim.tbl_map(function(l) return " " .. l end, lines)
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].modifiable = false
      Snacks.win({
        buf      = buf,
        position = "bottom",
        height   = 0.3,
        wo       = { winbar = " Message History  ", number = false, relativenumber = false },
      })
    end, desc = "Messages" },
    { "<leader>ms", function() Snacks.notifier.show_history() end, desc = "Notification History" },
  },
  config = function(_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)
    vim.notify = snacks.notifier.notify
  end,
}
