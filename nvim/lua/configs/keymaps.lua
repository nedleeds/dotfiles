local map = vim.keymap.set

vim.g.mapleader = " "


-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end,       { desc = "Delete buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete other buffers" })

-- Editing
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Misc
map("n", "<leader>E", function() vim.ui.open(".") end, { desc = "Open system explorer" })

-- LSP
map("n", "K", function()
  vim.lsp.buf.hover({ max_height = 25, max_width = 80, border = "rounded" })
end, { desc = "Hover documentation" })
map("n", "gd", function()
  -- buf_request 에 직접 콜백을 넘겨 "(1 of 1): ..." echo 를 우회
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if not client then return end
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx)
    if err or not result then return end
    client = vim.lsp.get_client_by_id(ctx.client_id) or client
    local locs = vim.islist(result) and result or { result }
    if #locs == 0 then return end
    vim.lsp.util.show_document(locs[1], client.offset_encoding, { reuse_win = false, focus = true })
    vim.cmd("normal! zz")
    if #locs > 1 then
      vim.fn.setqflist({}, " ", {
        title = "Definitions",
        items = vim.lsp.util.locations_to_items(locs, client.offset_encoding),
      })
      vim.cmd("copen")
    end
  end)
end, { desc = "Go to definition (centered)" })
map("n", "gD", vim.lsp.buf.declaration,    { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "grr", vim.lsp.buf.references,    { desc = "References" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

-- Diagnostics
map("n", "dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "da", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
map("n", "]d", function() vim.diagnostic.jump({ count =  1 }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "]e", function() vim.diagnostic.jump({ count =  1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })

-- Pickers (Snacks)
map("n", "<leader>su", function() Snacks.picker.undo() end,   { desc = "Undo history" })
map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "Find Symbols in Document" })
map("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Find Symbols in Workspace"})

-- Git (Snacks pickers)
map("n", "<leader>gl", function() Snacks.picker.git_log() end,    { desc = "Git log" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git status" })

-- Terminal splits
map({ "n", "t" }, "<C-\\>", function()
  Snacks.terminal.toggle("pwsh", { count = 1, win = { position = "right", width = 0.35, border = "rounded", wo = { winbar = "" } } })
end, { desc = "Terminal (right 35%)" })
map({ "n", "t" }, "<C-_>", function()
  Snacks.terminal.toggle("pwsh", { count = 2, win = { position = "bottom", height = 0.35, wo = { winbar = "", winhighlight = "FloatBorder:SnacksTermBorder" } } })
end, { desc = "Terminal (bottom 35%)" })


-- ---------------------------------------------------------
-- Window navigation
-- ---------------------------------------------------------
-- Close window
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Window: Close" })
-- Zoom toggle
map("n", "<C-z>", function() require("configs.zoom").toggle() end, { desc = "Window: Zoom toggle" })

-- Window Split
map("n", "<leader>wv", "<C-w>v", { desc = "Window: Split vertical" })
map("n", "<leader>wh", "<C-w>s", { desc = "Window: Split horizontal"})
map("n", "<leader>wd", "<Cmd>close<CR>", { desc = "Window: Close current"})
map("n", "<C-h>", "<C-w>h", { desc = "Window: Go to left window" })
map("n", "<BS>",  "<C-w>h", { desc = "Window: Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Window: Go to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Window: Go to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Window: Go to right window" })

-- Resize (NO Ctrl, NO Arrow)
local resize_step = 5
map("n", "-", function() vim.cmd("vertical resize -" .. resize_step) end, { desc = "Window: Decrease width" })
map("n", "=", function() vim.cmd("vertical resize +" .. resize_step) end, { desc = "Window: Increase width" })
map("n", "_", function() vim.cmd("resize -" .. resize_step) end, { desc = "Window: Decrease height"})
map("n", "+", function() vim.cmd("resize +" .. resize_step) end, { desc = "Window: Increase height"})

local windows = require("configs.windows")

vim.api.nvim_set_hl(0, "WinHintsFloat", { fg = "#000000", bg = "#e0af68", bold = true })

map("n", "<leader>ww", function()
  windows.show_win_hints()
  vim.cmd("redraw")
  local ok, ch = pcall(vim.fn.getcharstr)
  windows.hide_win_hints()
  if ok then
    local num = tonumber(ch)
    if num then
      windows.goto_win(num == 0 and 10 or num)
    end
  end
end, { desc = "Window: Pick by number" })

-- which-key용
for i = 1, 9 do
  map("n", "<leader>w" .. i, function()
    windows.goto_win(i)
  end, { desc = "Go to window " .. i })
end
map("n", "<leader>w0", function()
  windows.goto_win(10)
end, { desc = "Go to window 10" })

vim.keymap.set("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace Symbols" })
