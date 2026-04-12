return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
        "html", "yaml", "css", "javascript", "bash", "python"
      },

      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
