-- lua/plugins/bootstrap.lua
vim.pack.add({
  -- ---------------------------------------------------------
  -- Core UI
  -- ---------------------------------------------------------
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },

  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },

  { src = "https://github.com/echasnovski/mini.tabline" },

  -- ---------------------------------------------------------
  -- LSP / Treesitter
  -- ---------------------------------------------------------
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master", build = ":TSUpdate" },

  -- ---------------------------------------------------------
  -- DAP
  -- ---------------------------------------------------------
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/mfussenegger/nvim-dap-python" },

  -- ---------------------------------------------------------
  -- Git
  -- ---------------------------------------------------------
  { src = "https://github.com/kdheepak/lazygit.nvim" },

  -- ---------------------------------------------------------
  -- Colorschemes (optional, keep as you like)
  -- ---------------------------------------------------------
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/rose-pine/neovim" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/projekt0n/github-nvim-theme" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/navarasu/onedark.nvim" },
  { src = "https://github.com/Mofiqul/dracula.nvim" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/marko-cerovac/material.nvim" },
  { src = "https://github.com/cocopon/iceberg.vim" },
})
