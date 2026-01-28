local base = { noremap = true, silent = true }
local function map(mode, lhs, rhs, desc, extra)
  local o = vim.tbl_extend("force", base, extra or {})
  if desc then o.desc = desc end
  vim.keymap.set(mode, lhs, rhs, o)
end

local function with_require(mod, fn, notify_name)
  return function(...)
    local ok, m = pcall(require, mod)
    if not ok then
      vim.notify((notify_name or mod) .. " is not loaded", vim.log.levels.WARN)
      return
    end
    return fn(m, ...)
  end
end

-- ---------------------------------------------------------
-- which-key groups + icons (v3 icon table)
-- ---------------------------------------------------------
do
  local ok_wk, wk = pcall(require, "which-key")
  if ok_wk then
    wk.add({
      -- Groups (prefix)
      { "<leader>b", group = "Buffer",  icon = { icon = "󰓩 ", hl = "WKIconBuffer" } },
      { "<leader>d", group = "Debug",   icon = { icon = "󰃤 ", hl = "WKIconDebug" } },
      { "<leader>f", group = "Find",    icon = { icon = " ", hl = "WKIconFind" } },
      { "<leader>g", group = "Git",     icon = { icon = "󰊢 ", hl = "WKIconGit" } },
      { "<leader>l", group = "LSP",     icon = { icon = "󰒋 ", hl = "WKIconLSP" } },
      { "<leader>o", group = "OpenCode",icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>oa", desc = "Ask", icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>ox", desc = "Action picker", icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>ot", desc = "Toggle panel", icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>os", desc = "Add selection", icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>ol", desc = "Add line", icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>ou", desc = "Scroll up", icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>od", desc = "Scroll down", icon = { icon = "󰚩 ", hl = "WKIconOpenCode" } },
      { "<leader>w", group = "Window",  icon = { icon = "󰖲 ", hl = "WKIconWindow" } },
      { "<leader>s", group = "Session", icon = { icon = " ", hl = "WKIconSession" } },
      { "<leader>m", group = "Log Messages", icon = { icon = "󱅫 ", hl = "WKIconNotify" } },

      -- Singles (top-level)
      { "<leader>e", desc = "Explorer",           icon = { icon = " ",  hl = "WKIconExplorer" } },
      { "<leader>q", desc = "Quit",               icon = { icon = "󰗼 ", hl = "WKIconFile" } },
      { "<leader>T", desc = "Retab",              icon = { icon = "󰉢 ", hl = "WKIconFormat" } },

      -- Non-leader keymaps (shown with ?)
      { "<C-[>", desc = "Clear search highlight", icon = { icon = "󰍉 ", hl = "WKIconSearch" } },

      { "<C-z>", desc = "Window: Zoom toggle", icon = { icon = "󰖲 ", hl = "WKIconWindow" } },
      { "gd", desc = "LSP: Go to definition", icon = { icon = "󰒋 ", hl = "WKIconLSP" } },
      { "gD", desc = "LSP: Go to declaration", icon = { icon = "󰒋 ", hl = "WKIconLSP" } },
      { "gi", desc = "LSP: Go to implementation", icon = { icon = "󰒋 ", hl = "WKIconLSP" } },
      { "gy", desc = "LSP: Go to type definition", icon = { icon = "󰒋 ", hl = "WKIconLSP" } },
      { "gr", desc = "LSP: References", icon = { icon = "󰒋 ", hl = "WKIconLSP" } },

      { "-", desc = "Window: Decrease width", icon = { icon = "󰖲 ", hl = "WKIconWindow" } },
      { "=", desc = "Window: Increase width", icon = { icon = "󰖲 ", hl = "WKIconWindow" } },
      { "_", desc = "Window: Decrease height", icon = { icon = "󰖲 ", hl = "WKIconWindow" } },
      { "+", desc = "Window: Increase height", icon = { icon = "󰖲 ", hl = "WKIconWindow" } },
      { "<S-l>", desc = "Buffer: Next", icon = { icon = "󰓩 ", hl = "WKIconBuffer" } },
      { "<S-h>", desc = "Buffer: Prev", icon = { icon = "󰓩 ", hl = "WKIconBuffer" } },

      -- Help key for non-prefix keymaps
      { "<leader>?", group = "noPrefix", icon = { icon = "󰋗 ", hl = "WKIconHelp" } },
    })
  end
end

-- ---------------------------------------------------------
-- Log Messages
-- <leader>m
-- ---------------------------------------------------------
map("n", "<leader>mm", function()
  require("config.snacks").open_messages_split()
end, "Log: messages")

map("n", "<leader>ms", function()
  require("config.snacks").open_snacks_notifications_split()
end, "Log: snacks history")

-- ---------------------------------------------------------
-- General / File
-- ---------------------------------------------------------
map("n", "<C-[>", "<Cmd>nohlsearch<CR><Esc>", "Search: Clear highlight")
map("n", "<leader>w", "<Cmd>w<CR>", "File: Save")
map("n", "<leader>q", "<Cmd>close<CR>", "Quit Window")
map("n", "<leader>T", "<Cmd>retab<CR>", "Format: Retab")

-- LSP format (global)
map("n", "<leader>lf", vim.lsp.buf.format, "LSP: Format")

-- ---------------------------------------------------------
-- Explorer (Oil)
-- ---------------------------------------------------------
map("n", "<leader>e", "<Cmd>Oil --float<CR>", "Explorer: Oil (float)")

-- ---------------------------------------------------------
-- Find (fzf-lua)
-- ---------------------------------------------------------
map("n", "<leader>ff", "<Cmd>FzfLua files<CR>", "Find: Files")
map("n", "<leader>fb", "<Cmd>FzfLua buffers<CR>", "Find: Buffers (fzf-lua)")
map("n", "<leader>fg", "<Cmd>FzfLua live_grep<CR>", "Find: Live grep")
map("n", "<leader>fl", "<Cmd>FzfLua blines<CR>", "Find: Buffer lines")

-- ---------------------------------------------------------
-- Buffer
-- ---------------------------------------------------------
map("n", "<S-l>", "<Cmd>bnext<CR>", "Buffer: Next")
map("n", "<S-h>", "<Cmd>bprevious<CR>", "Buffer: Prev")
map("n", "<leader>bd", "<Cmd>bdelete<CR>", "Buffer: Delete")

map("n", "<leader>bo", function()
  local v = vim.fn.winsaveview()
  vim.cmd("silent! %bd | e# | bd#")
  vim.fn.winrestview(v)
end, "Buffer: Close others (keep view)", { silent = true })

-- ---------------------------------------------------------
-- Git
-- ---------------------------------------------------------
map("n", "<leader>gg", "<Cmd>LazyGit<CR>", "Git: LazyGit")

-- Fugitive
map("n", "<leader>gs", "<Cmd>Git<CR>", "Git: Status (Fugitive)")
map("n", "<leader>gd", "<Cmd>Gdiffsplit<CR>", "Git: Diff (split)")
map("n", "<leader>gb", "<Cmd>Git blame<CR>", "Git: Blame")
map("n", "<leader>gl", "<Cmd>Gclog<CR>", "Git: Log (quickfix)")
map("n", "<leader>gL", "<Cmd>0Gclog<CR>", "Git: Log (this file)")
map("n", "<leader>gp", "<Cmd>Git push<CR>", "Git: Push")
map("n", "<leader>gP", "<Cmd>Git pull<CR>", "Git: Pull")
map("n", "<leader>go", "<Cmd>GBrowse<CR>", "Git: Open on remote") -- rhubarb 필요

-- ---------------------------------------------------------
-- LSP navigation / actions
-- ---------------------------------------------------------
map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
map("n", "gy", vim.lsp.buf.type_definition, "LSP: Go to type definition")
map("n", "gr", vim.lsp.buf.references, "LSP: References")

map("n", "<leader>lr", vim.lsp.buf.rename, "LSP: Rename")
map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "LSP: Code action")

-- (keep these as lightweight LSP diagnostics)
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "LSP: Prev diagnostic")
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "LSP: Next diagnostic")

-- ---------------------------------------------------------
-- Terminal behavior
-- ---------------------------------------------------------
map("t", "<C-[>", [[<C-\><C-n>]], "Terminal: Normal mode")

map("n", "i", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("startinsert")
  else
    return "i"
  end
end, "Terminal: Insert (if terminal)", { expr = true })

-- ---------------------------------------------------------
-- Window navigation
-- ---------------------------------------------------------
map("n", "<C-h>", "<C-w>h", "Window: Focus left")
map("n", "<C-j>", "<C-w>j", "Window: Focus down")
map("n", "<C-k>", "<C-w>k", "Window: Focus up")
map("n", "<C-l>", "<C-w>l", "Window: Focus right")

-- Zoom toggle
map("n", "<C-z>", function()
  require("config.zoom").toggle()
end, "Window: Zoom toggle")

-- Split
map("n", "<leader>ws", "<C-w>s", "Window: Split horizontal")
map("n", "<leader>wv", "<C-w>v", "Window: Split vertical")
map("n", "<leader>wd", "<Cmd>close<CR>", "Window: Close current")

-- Resize (NO Ctrl, NO Arrow)
local resize_step = 5
map("n", "-", function() vim.cmd("vertical resize -" .. resize_step) end, "Window: Decrease width")
map("n", "=", function() vim.cmd("vertical resize +" .. resize_step) end, "Window: Increase width")
map("n", "_", function() vim.cmd("resize -" .. resize_step) end, "Window: Decrease height")
map("n", "+", function() vim.cmd("resize +" .. resize_step) end, "Window: Increase height")

-- ---------------------------------------------------------
-- DAP
-- ---------------------------------------------------------
map("n", "<leader>dc", with_require("dap", function(dap) dap.continue() end, "nvim-dap"), "Debug: Continue")
map("n", "<leader>do", with_require("dap", function(dap) dap.step_over() end, "nvim-dap"), "Debug: Step over")
map("n", "<leader>di", with_require("dap", function(dap) dap.step_into() end, "nvim-dap"), "Debug: Step into")
map("n", "<leader>dO", with_require("dap", function(dap) dap.step_out() end, "nvim-dap"), "Debug: Step out")

map("n", "<leader>db", with_require("dap", function(dap) dap.toggle_breakpoint() end, "nvim-dap"), "Debug: Toggle breakpoint")

map("n", "<leader>dB", function()
  local ok, dap = pcall(require, "dap")
  if not ok then
    vim.notify("nvim-dap is not loaded", vim.log.levels.WARN)
    return
  end

  local cond = vim.fn.input("Breakpoint condition: ")
  if cond == nil or cond == "" then
    dap.toggle_breakpoint()
  else
    dap.set_breakpoint(cond)
  end
end, "Debug: Conditional breakpoint")

map("n", "<leader>du", with_require("dapui", function(dapui) dapui.toggle() end, "nvim-dap-ui"), "Debug: Toggle UI")
map("n", "<leader>dr", with_require("dap", function(dap) dap.repl.open() end, "nvim-dap"), "Debug: REPL")
map("n", "<leader>dq", with_require("dap", function(dap) dap.terminate() end, "nvim-dap"), "Debug: Terminate")
map("n", "<leader>dR", with_require("dap", function(dap) dap.restart() end, "nvim-dap"), "Debug: Restart")

-- ---------------------------------------------------------
-- Debug group: Diagnostics (Problems-like)
-- ---------------------------------------------------------
map("n", "<leader>dd", "<Cmd>FzfLua diagnostics_workspace<CR>", "Debug: Diagnostics (workspace)")
map("n", "<leader>df", "<Cmd>FzfLua diagnostics_document<CR>", "Debug: Diagnostics (file)")
map("n", "<leader>de", vim.diagnostic.open_float, "Debug: Line diagnostics")
map("n", "<leader>dQ", function()
  vim.diagnostic.setqflist({ open = true })
end, "Debug: Diagnostics -> Quickfix")

-- ---------------------------------------------------------
-- Insert mode PUM navigation
-- ---------------------------------------------------------
map("i", "<C-j>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  return "<C-j>"
end, "PUM: Next", { expr = true })

map("i", "<C-k>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  end
  return "<C-k>"
end, "PUM: Prev", { expr = true })

-- -- ---------------------------------------------------------
-- -- Whitespace cleanup on save
-- -- ---------------------------------------------------------
-- do
--   local grp = vim.api.nvim_create_augroup("DHLTrimWhitespace", { clear = true })
--   vim.api.nvim_create_autocmd("BufWritePre", {
--     group = grp,
--     pattern = "*",
--     callback = function()
--       local view = vim.fn.winsaveview()
--       vim.cmd([[silent! %s/\s\+$//e]])
--       vim.fn.winrestview(view)
--     end,
--   })
-- end

-- Toggle whitespace display
map("n", "<leader>.", function()
  _G.toggle_whitespace()
end, "UI: Whitespace")

-- ---------------------------------------------------------
-- OpenCode (opencode.nvim) - safe lazy require
-- ---------------------------------------------------------
local function with_opencode(fn)
  return function(...)
    local ok, oc = pcall(require, "opencode")
    if not ok then
      vim.notify("opencode.nvim is not loaded", vim.log.levels.WARN)
      return
    end
    return fn(oc, ...)
  end
end

map({ "n", "x" }, "<leader>oa", with_opencode(function(oc)
  oc.ask("@this: ", { submit = true })
end), "OpenCode: Ask")

map({ "n", "x" }, "<leader>ox", with_opencode(function(oc)
  oc.select()
end), "OpenCode: Action picker")

map({ "n", "t" }, "<leader>ot", with_opencode(function(oc)
  oc.toggle()
end), "OpenCode: Toggle panel")

map({ "n", "x" }, "<leader>os", with_opencode(function(oc)
  return oc.operator("@this ")
end), "OpenCode: Add selection", { expr = true })

map("n", "<leader>ol", with_opencode(function(oc)
  return oc.operator("@this ") .. "_"
end), "OpenCode: Add line", { expr = true })

map("n", "<leader>ou", with_opencode(function(oc)
  oc.command("session.half.page.up")
end), "OpenCode: Scroll up")

map("n", "<leader>od", with_opencode(function(oc)
  oc.command("session.half.page.down")
end), "OpenCode: Scroll down")

-- ---------------------------------------------------------
-- Oil buffer-local keymaps (moved from oil.setup.keymaps)
-- ---------------------------------------------------------
local function set_oil_keymaps(bufnr)
  local function bmap(mode, lhs, rhs, desc, extra)
    local o = vim.tbl_extend("force", base, { buffer = bufnr }, extra or {})
    o.desc = desc
    vim.keymap.set(mode, lhs, rhs, o)
  end

  local ok_actions, actions = pcall(require, "oil.actions")
  if not ok_actions then
    return
  end

  bmap("n", "g?", actions.show_help.callback, "Oil: Help")

  bmap("n", "<CR>", actions.select.callback, "Oil: Select")
  bmap("n", "<C-s>", function() actions.select.callback({ vertical = true }) end, "Oil: Select vertical")
  bmap("n", "<C-h>", function() actions.select.callback({ horizontal = true }) end, "Oil: Select horizontal")
  bmap("n", "<C-t>", function() actions.select.callback({ tab = true }) end, "Oil: Select tab")

  bmap("n", "<C-p>", actions.preview.callback, "Oil: Preview")
  bmap("n", "q", actions.close.callback, "Oil: Close")
  bmap("n", "<C-l>", actions.refresh.callback, "Oil: Refresh")

  bmap("n", "-", actions.parent.callback, "Oil: Parent")
  bmap("n", "_", actions.open_cwd.callback, "Oil: Open CWD")

  bmap("n", "`", actions.cd.callback, "Oil: cd")
  bmap("n", "g~", function() actions.cd.callback({ scope = "tab" }) end, "Oil: cd (tab)")

  bmap("n", "gs", actions.change_sort.callback, "Oil: Change sort")
  bmap("n", "gx", actions.open_external.callback, "Oil: Open external")

  bmap("n", "g.", actions.toggle_hidden.callback, "Oil: Toggle hidden")
  bmap("n", "g\\", actions.toggle_trash.callback, "Oil: Toggle trash")
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(ev)
    set_oil_keymaps(ev.buf)
  end,
})

-- =========================================================
-- Snacks Terminal Toggle (Ctrl-\)
-- =========================================================
map({ "n", "t" }, "<C-\\>", function()
  local ok, Snacks = pcall(require, "snacks")
  if ok then
    Snacks.terminal.toggle()
  end
end, "Terminal Toggle")

-- Terminal: ESC -> Normal mode (so y/v work)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Terminal: Normal mode" })
