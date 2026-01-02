local configs = require("nvim-treesitter.configs")
configs.setup({
  ensure_installed = { "lua", "python", "c", "cpp", "bash", "json", "yaml", "markdown" },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})
