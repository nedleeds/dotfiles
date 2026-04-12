return {
  "folke/which-key.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay  = 50,
    plugins = {
      spelling = { enabled = true, suggestions = 20 },
      presets  = {
        operators    = false,
        motions      = false,
        text_objects = false,
        windows      = true,
        nav          = true,
        z            = true,
        g            = true,
      },
    },
    win   = { border = "rounded" },
    layout = { spacing = 1 },
    icons = {
      mappings  = true,
      breadcrumb = "»",
      separator  = "➜",
      group      = "+",
      ellipsis   = "…",
    },
  },
  config = function(_, opts)
    require("configs.which-key").setup(opts)
  end,
}
