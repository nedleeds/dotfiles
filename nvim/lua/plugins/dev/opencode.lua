-- Ensure opencode CLI is discoverable from Neovim (before requiring opencode)
do
  local p = vim.fn.expand("~/.opencode/bin")
  if not vim.env.PATH:find(p, 1, true) then
    vim.env.PATH = p .. ":" .. vim.env.PATH
  end
end

-- 2) Configure safely
local ok, opencode = pcall(require, "opencode")
if not ok then
  return
end

-- opencode opts (global)
---@type opencode.Opts
vim.g.opencode_opts = {
  terminal = {
    toggleterm = false,
  },
  -- Force toggleterm usage even in tmux environment
  detect_tmux = false,
  -- Explicitly disable tmux integration
  tmux = {
    enabled = false,
  },
  -- Configure input to use snacks.nvim
  input = {
    enabled = true,
    -- Configure snacks input for floating window
    provider = function(opts, on_submit)
      return require("snacks").input(opts, on_submit)
    end,
  },
}

-- Required for `opts.events.reload`
vim.o.autoread = true
