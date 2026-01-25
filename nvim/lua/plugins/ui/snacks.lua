return {
  "folke/snacks.nvim",
  config = function()
    require("snacks").setup({
      input = {
        enabled = true,
        -- Configure for opencode integration
        win = {
          backdrop = true,
          position = "cursor",
          border = "rounded",
          title = "OpenCode",
          title_pos = "center",
          height = 1,
          width = 60,
          relative = "cursor",
          row = 1,
          col = 0,
        },
      },
      bigfile = {
        enabled = true,
      },
      notifier = {
        enabled = true,
      },
      quickfile = {
        enabled = true,
      },
      words = {
        enabled = true,
      },
    })
  end,
  keys = {
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>cR", function() Snacks.rename() end, desc = "Rename File" },
  },
}