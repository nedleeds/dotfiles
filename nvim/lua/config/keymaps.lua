-- keymaps are automatically loaded on the VeryLazy event
-- default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- add any additional keymaps here

local keymaps = vim.keymap
local opts = { noremap = true, silent = true }

-- increment / Decrement
keymaps.set("n", "+", "<C-a>")
keymaps.set("n", "-", "<C-x>")

-- delete a word backwards
keymaps.set("n", "db", "vb_d")

-- select all
keymaps.set("n", "<C-a>", "gg<S-v>G")

-- jumplist
keymaps.set("n", "<C-m>", "<C-i>", opts)

-- new tab
keymaps.set("n", "te", ":tabedit<Return>", opts)
keymaps.set("n", "<tab>", ":tabnext<Return>", opts)
keymaps.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- split windows
keymaps.set("n", "ss", ":split<Return>", opts)
keymaps.set("n", "sv", ":vsplit<Return>", opts)

-- move windows
keymaps.set("n", "<c-h>", "<C-w>h")
keymaps.set("n", "<c-j>", "<C-w>j")
keymaps.set("n", "<c-l>", "<C-w>l")
keymaps.set("n", "<c-k>", "<C-w>k")

-- resize windows
keymaps.set("n", "<C-w><left>", "<C-w><")
keymaps.set("n", "<C-w><right>", "<C-w>>")
keymaps.set("n", "<C-w><up>", "<C-w>=")
keymaps.set("n", "<C-w><down>", "<C-w>-")

-- diagnostics
keymaps.set("n", "<C-0>", function()
  vim.diagnostic.goto_next()
end, opts)
keymaps.set("n", "<C-9>", function()
  vim.diagnostic.goto_prev()
end, opts)
