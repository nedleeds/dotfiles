vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master", build = ":TSUpdate" },
})

-- 핵심: opt로 깔렸을 수 있으니 런타임 로드를 강제
vim.cmd("packadd nvim-treesitter")

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  vim.notify("nvim-treesitter.configs load failed", vim.log.levels.ERROR)
  return
end

configs.setup({
  ensure_installed = { "lua", "python", "c", "cpp", "bash", "json", "yaml", "markdown" },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})
