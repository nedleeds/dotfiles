local map = vim.keymap.set

vim.g.mapleader = " "

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Close window" })

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
  Snacks.terminal.toggle(nil, { count = 1, win = { position = "right",  width  = 0.35, wo = { winbar = "" } } })
end, { desc = "Terminal (right 35%)" })

map({ "n", "t" }, "<C-_>", function()
  Snacks.terminal.toggle(nil, { count = 2, win = { position = "bottom", height = 0.35, wo = { winbar = "" } } })
end, { desc = "Terminal (bottom 35%)" })
