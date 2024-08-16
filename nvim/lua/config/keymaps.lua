-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymaps = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment / Decrement
keymaps.set("n", "+", "<C-a>")
keymaps.set("n", "-", "<C-x>")

-- Delete a word backwards
keymaps.set("n", "db", "vb_d")

-- Select all
keymaps.set("n", "<C-a>", "gg<S-v>G")

-- Jumplist
keymaps.set("n", "<C-m>", "<C-i>", opts)

-- new tab
keymaps.set("n", "te", ":tabedit<Return>", opts)
keymaps.set("n", "<tab>", ":tabnext<Return>", opts)
keymaps.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- split windows
keymaps.set("n", "ss", ":split<Return>", opts)
keymaps.set("n", "sv", ":vsplit<Return>", opts)

-- move windows
keymaps.set("n", "sh", "<C-w>h")
keymaps.set("n", "sj", "<C-w>j")
keymaps.set("n", "sk", "<C-w>k")
keymaps.set("n", "sl", "<C-w>l")

-- resize windows
keymaps.set("n", "<C-w><left>", "<C-w><")
keymaps.set("n", "<C-w><right>", "<C-w><")
keymaps.set("n", "<C-w><up>", "<C-w><")
keymaps.set("n", "<C-w><down>", "<C-w><")

-- diagnostics
keymaps.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)
keymaps.set("n", "<C-k>", function()
  vim.diagnostic.goto_prev()
end, opts)
