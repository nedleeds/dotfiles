return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter/runtime')
    require("nvim-treesitter.install").compilers = { "clang" }
    require("nvim-treesitter.install").command_extra_args = {
      curl = { "--ssl-no-revoke" }
    }
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
