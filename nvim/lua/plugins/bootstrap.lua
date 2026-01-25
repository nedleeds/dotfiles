-- lua/plugins/bootstrap.lua
vim.pack.add({
  -- ---------------------------------------------------------
  -- Core UI
  -- ---------------------------------------------------------
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },


  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },

  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },

  { src = "https://github.com/echasnovski/mini.tabline" },
  { src = "https://github.com/folke/which-key.nvim", version = "main" },
  { src = "https://github.com/folke/snacks.nvim" },

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
  -- Completion (nvim-cmp)
  -- ---------------------------------------------------------
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },

  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },

  -- ---------------------------------------------------------
  -- Git
  -- ---------------------------------------------------------
  { src = "https://github.com/jesseduffield/lazygit" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/tpope/vim-rhubarb" },

  -- ---------------------------------------------------------
  -- opencode
  -- ---------------------------------------------------------
  { src = "https://github.com/NickvanDyke/opencode.nvim" },

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
