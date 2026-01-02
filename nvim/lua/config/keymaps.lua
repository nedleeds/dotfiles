vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>w", ":w<CR>", opts)
vim.keymap.set("n", "<leader>q", ":q<CR>", opts)
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>", opts)

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)

-- Oil
vim.keymap.set("n", "<leader>e", ":Oil --float<CR>", opts)

-- fzf-lua
vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>", opts)
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>", opts)
vim.keymap.set("n", "<leader>/", ":FzfLua blines<CR>", opts)
vim.keymap.set("n", "<leader>g", ":FzfLua live_grep<CR>", opts)

-- Buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", opts)
vim.keymap.set("n", "<leader>bo", function()
  local v = vim.fn.winsaveview()
  vim.cmd("silent! %bd | e# | bd#")
  vim.fn.winrestview(v)
end, { silent = true, desc = "Close other buffers (keep view)" })

-- lazygit
vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", opts)

-- noice
vim.keymap.set("n", "<leader>n", ":NoiceAll<CR>", opts)

--------------------- lsp
-- Go to definition / declaration / implementation / type definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP Declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "LSP Type Definition" })

-- References
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })

-- Rename / Code Action
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

-- Diagnostics
vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

-- Toggleterm
-- =========================================================
-- ToggleTerm Vim-like terminal behavior
-- =========================================================

-- Terminal mode -> Normal mode
vim.keymap.set("t", "<C-[>", [[<C-\><C-n>]], {
  desc = "Terminal: enter normal mode",
})

-- Terminal normal mode -> Insert mode
vim.keymap.set("n", "i", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("startinsert")
  else
    return "i"
  end
end, {
  expr = true,
  desc = "Terminal: normal -> insert",
})

-- move
-- Window navigation without <C-w>
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Win left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Win down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Win up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Win right" })


-- Ctrl+Z : Window Zoom toggle
vim.keymap.set("n", "<C-z>", function()
  require("plugins.ui.zoom").toggle()
end, {
  desc = "Window Zoom (same tab)",
})

-- Split windows
vim.keymap.set("n", "<leader>ws", "<C-w>s", {
  noremap = true,
  silent = true,
  desc = "Window: split horizontally",
})

vim.keymap.set("n", "<leader>wv", "<C-w>v", {
  noremap = true,
  silent = true,
  desc = "Window: split vertically",
})

-- Close current window
vim.keymap.set("n", "<leader>wd", function()
  vim.cmd("close")
end, {
  noremap = true,
  silent = true,
  desc = "Window: close current",
})

-- =========================================================
-- Window resize (NO Ctrl, NO Arrow)
-- <leader>w + hjkl
-- =========================================================

local resize_step = 5

-- Width (left / right)
vim.keymap.set("n", "-", function()
  vim.cmd("vertical resize -" .. resize_step)
end, { noremap = true, silent = true, desc = "Window: decrease width" })

vim.keymap.set("n", "=", function()
  vim.cmd("vertical resize +" .. resize_step)
end, { noremap = true, silent = true, desc = "Window: increase width" })

-- Height (down / up)
vim.keymap.set("n", "_", function()
  vim.cmd("resize -" .. resize_step)
end, { noremap = true, silent = true, desc = "Window: decrease height" })

vim.keymap.set("n", "+", function()
  vim.cmd("resize +" .. resize_step)
end, { noremap = true, silent = true, desc = "Window: increase height" })

-- DAP
-- =========================================================
-- DAP (nvim-dap / nvim-dap-ui)
-- <leader>d*
-- =========================================================

-- Debug flow (arrow keys)
vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { noremap = true, silent = true, desc = "DAP: Continue" })

vim.keymap.set("n", "<leader>do", function()
  require("dap").step_over()
end, { noremap = true, silent = true, desc = "DAP: Step over" })

vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { noremap = true, silent = true, desc = "DAP: Step into" })

vim.keymap.set("n", "<leader>dO", function()
  require("dap").step_out()
end, { noremap = true, silent = true, desc = "DAP: Step out" })

-- Breakpoints
vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { noremap = true, silent = true, desc = "DAP: Toggle breakpoint" })

-- 빈 입력이면 일반 BP로 fallback (실전 UX)
vim.keymap.set("n", "<leader>dB", function()
  local cond = vim.fn.input("Breakpoint condition: ")
  if cond == nil or cond == "" then
    require("dap").toggle_breakpoint()
  else
    require("dap").set_breakpoint(cond)
  end
end, { noremap = true, silent = true, desc = "DAP: Conditional breakpoint" })

-- UI / REPL
vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { noremap = true, silent = true, desc = "DAP-UI: Toggle" })

vim.keymap.set("n", "<leader>dr", function()
  require("dap").repl.open()
end, { noremap = true, silent = true, desc = "DAP: REPL" })

-- Optional: terminate / restart
vim.keymap.set("n", "<leader>dq", function()
  require("dap").terminate()
end, { noremap = true, silent = true, desc = "DAP: Terminate" })

vim.keymap.set("n", "<leader>dR", function()
  require("dap").restart()
end, { noremap = true, silent = true, desc = "DAP: Restart" })


-- insert mode에서 pum 보일 때 C-j/C-k로 다음/이전 항목 선택
vim.keymap.set("i", "<C-j>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  return "<C-j>"
end, { expr = true, noremap = true })

vim.keymap.set("i", "<C-k>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  end
  return "<C-k>"
end, { expr = true, noremap = true })

