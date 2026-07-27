vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })

require("toggleterm").setup({
    shell           = "pwsh -NoLogo",
    open_mapping    = [[<C-\>]],
    direction       = "vertical",
    size            = function() return math.floor(vim.o.columns * 0.5) end,
    start_in_insert = true,
    persist_size    = true,
    shade_terminals = true,   -- 투명 배경 유지
})

-- 터미널 모드 키맵
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "터미널 normal 모드" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "왼쪽 창으로" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "아래 창으로" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "위 창으로" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "오른쪽 창으로" })

local function link_toggleterm_hl()
  for i = 1, 9 do
    vim.api.nvim_set_hl(0, ("ToggleTerm%dStatusLine"):format(i),   { link = "StatusLine" })
    vim.api.nvim_set_hl(0, ("ToggleTerm%dStatusLineNC"):format(i), { link = "StatusLineNC" })
  end
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*toggleterm#*",
  callback = function()
    vim.schedule(link_toggleterm_hl)

    vim.wo.statusline = " toggleterm"
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = link_toggleterm_hl,
})
