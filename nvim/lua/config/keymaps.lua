-- lua/config/keymaps.lua
vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ------------------------------------------------------------
-- Core / General
-- ------------------------------------------------------------
map("n", "<C-[>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

map("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<Cmd>quit<CR>", { desc = "Quit window" })
map("n", "<leader>o", "<Cmd>update<CR><Cmd>source %<CR>", { desc = "Source current file" })

-- Formatting
map("n", "<leader>lf", function() vim.lsp.buf.format() end, { desc = "LSP: Format" })
map("n", "<leader>T", "<Cmd>retab<CR>", { desc = "Retab (fix tabs/spaces)" })

-- Toggle whitespace visualization
map("n", "<leader>.", function()
  vim.opt.list = not vim.opt.list:get()
  if vim.opt.list:get() then
    vim.opt.listchars = { tab = ">>", trail = "." }
  end
end, { desc = "Toggle whitespace" })

-- ------------------------------------------------------------
-- File explorer (Oil)
-- ------------------------------------------------------------
map("n", "<leader>e", "<Cmd>Oil --float<CR>", { desc = "Explorer: Oil (float)" })

-- ------------------------------------------------------------
-- Find (fzf-lua)
-- NOTE: <leader>f is reserved as a group prefix for which-key.
-- ------------------------------------------------------------
map("n", "<leader>ff", "<Cmd>FzfLua files<CR>", { desc = "Find files" })
map("n", "<leader>fb", "<Cmd>FzfLua buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fl", "<Cmd>FzfLua blines<CR>", { desc = "Find in current buffer" })
map("n", "<leader>fg", "<Cmd>FzfLua live_grep<CR>", { desc = "Find by grep" })

-- (쩌짹횇횄) 짹창횁쨍 쩍??째체 ??짱횁철쩔챘: <leader>/ 쨈횂 blines쨌횓 짹횞쨈챘쨌횓 쨉횘
map("n", "<leader>/", "<Cmd>FzfLua blines<CR>", { desc = "Find in current buffer" })

-- ------------------------------------------------------------
-- Buffers
-- ------------------------------------------------------------
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })

map("n", "<leader>bd", "<Cmd>bdelete<CR>", { desc = "Buffer: delete" })
map("n", "<leader>bo", function()
  local v = vim.fn.winsaveview()
  vim.cmd("silent! %bd | e# | bd#")
  vim.fn.winrestview(v)
end, { silent = true, desc = "Buffer: close others (keep view)" })

-- ------------------------------------------------------------
-- Git
-- ------------------------------------------------------------
map("n", "<leader>gg", "<Cmd>LazyGit<CR>", { desc = "Git: LazyGit" })

-- ------------------------------------------------------------
-- Noice
-- ------------------------------------------------------------
map("n", "<leader>un", "<Cmd>NoiceAll<CR>", { desc = "UI: Noice history" })

-- ------------------------------------------------------------
-- LSP (non-leader go-to keys)
-- ------------------------------------------------------------
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "LSP: Type definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP: References" })

-- LSP actions (leader)
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: Rename" })
map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "LSP: Code action" })

-- Diagnostics
-- ?쟾泥?/?썙?겕?뒪?럹?씠?뒪 diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Diagnostics: line float" })
map("n", "<leader>dd", vim.diagnostic.setloclist, { desc = "Diagnostics: document list" })
map("n", "<leader>dD", vim.diagnostic.setqflist, { desc = "Diagnostics: workspace list" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Diagnostics: prev", nowait = true})
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Diagnostics: next", nowait = true })

-- ------------------------------------------------------------
-- Terminal (toggleterm) / terminal UX
-- ------------------------------------------------------------
map("t", "<C-[>", [[<C-\><C-n>]], { desc = "Terminal: normal mode" })

-- terminal buffer쩔징쩌짯쨍쨍 i째징 startinsert쨌횓 쨉쩔??횤횉횕쨉쨉쨌횕 (짹횞 쩔횥쩔징쨈횂 ??횕쨔횦 i)
map("n", "i", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("startinsert")
  else
    return "i"
  end
end, { expr = true, desc = "Terminal: enter insert" })

-- ------------------------------------------------------------
-- Window movement / layout
-- ------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Window: left" })
map("n", "<BS>",  "<C-w>h", { desc = "Window: left (Backspace)" })
map("n", "<C-j>", "<C-w>j", { desc = "Window: down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window: up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window: right" })

map("n", "<C-z>", function()
  require("plugins.ui.zoom").toggle()
end, { desc = "Window: zoom toggle" })

map("n", "<leader>ws", "<C-w>s", { desc = "Window: split horizontal" })
map("n", "<leader>wv", "<C-w>v", { desc = "Window: split vertical" })
map("n", "<leader>wd", "<Cmd>close<CR>", { desc = "Window: close" })

-- Resize (no Ctrl, no arrow)
local resize_step = 5
map("n", "-", function() vim.cmd("vertical resize -" .. resize_step) end, { desc = "Window: width -" })
map("n", "=", function() vim.cmd("vertical resize +" .. resize_step) end, { desc = "Window: width +" })
map("n", "_", function() vim.cmd("resize -" .. resize_step) end, { desc = "Window: height -" })
map("n", "+", function() vim.cmd("resize +" .. resize_step) end, { desc = "Window: height +" })

-- ------------------------------------------------------------
-- DAP (<leader>d*)
-- ------------------------------------------------------------
map("n", "<leader>Dc", function() require("dap").continue() end, { desc = "DAP: Continue" })
map("n", "<leader>Do", function() require("dap").step_over() end, { desc = "DAP: Step over" })
map("n", "<leader>Di", function() require("dap").step_into() end, { desc = "DAP: Step into" })
map("n", "<leader>DO", function() require("dap").step_out() end, { desc = "DAP: Step out" })

map("n", "<leader>Db", function() require("dap").toggle_breakpoint() end, { desc = "DAP: Toggle breakpoint" })
map("n", "<leader>DB", function()
  local cond = vim.fn.input("Breakpoint condition: ")
  if cond == nil or cond == "" then
    require("dap").toggle_breakpoint()
  else
    require("dap").set_breakpoint(cond)
  end
end, { desc = "DAP: Conditional breakpoint" })

map("n", "<leader>Du", function() require("dapui").toggle() end, { desc = "DAP-UI: Toggle" })
map("n", "<leader>Dr", function() require("dap").repl.open() end, { desc = "DAP: REPL" })
map("n", "<leader>Dq", function() require("dap").terminate() end, { desc = "DAP: Terminate" })
map("n", "<leader>DR", function() require("dap").restart() end, { desc = "DAP: Restart" })

-- ------------------------------------------------------------
-- Insert-mode completion menu navigation
-- ------------------------------------------------------------
map("i", "<C-j>", function()
  if vim.fn.pumvisible() == 1 then return "<C-n>" end
  return "<C-j>"
end, { expr = true, noremap = true, desc = "PUM: next item" })

map("i", "<C-k>", function()
  if vim.fn.pumvisible() == 1 then return "<C-p>" end
  return "<C-k>"
end, { expr = true, noremap = true, desc = "PUM: prev item" })

-- ------------------------------------------------------------
-- Save-time whitespace trim (fixes your missing 'group' var)
-- ------------------------------------------------------------
local trim_grp = vim.api.nvim_create_augroup("trim_trailing_whitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = trim_grp,
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

vim.keymap.set("n", "<leader>gg", "<Cmd>LazyGit<CR>", { desc = "Git: LazyGit" })

