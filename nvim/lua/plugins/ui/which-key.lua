-- lua/plugins/ui/which-key.lua
local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.setup({
  preset = "helix",
  delay = 50,

  plugins = {
    spelling = { enabled = true, suggestions = 20 },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },

  win = {
    title = false,
    wo = {
      winblend = 1,
    },
  },

  layout = {
    width = { min = 18, max = 30 },
    spacing = 1,
  },

  icons = {
    breadcrumb = "¡í",
    separator = "?",
    group = "+",
    ellipsis = "¡¦",
  },

  show_help = true,
  show_keys = true,
})

wk.add({
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>l", group = "lsp" },
  { "<leader>d", group = "debug" },
  { "<leader>t", group = "terminal/test" },
  { "<leader>u", group = "ui" },
  { "<leader>w", group = "window" },
})


