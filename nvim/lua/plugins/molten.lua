return {
  "benlubas/molten-nvim",
  dependencies = {
    "willothy/wezterm.nvim",
  },
  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  build = ":UpdateRemotePlugins",
  init = function()
    -- this is an example, not a default. Please see the readme for more configuration options
    vim.g.molten_output_win_max_height = 12
  end,

  config = function()
    vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")
  end,

  vim.keymap.set("n", "<localleader>mp", function()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv ~= nil then
      venv = string.match(venv, "/.+/p(.+)")
      vim.cmd(("MoltenInit %s"):format(venv))
    else
      vim.cmd("MoltenInit python3")
    end
  end, { desc = "Initialize Molten for Python environment", silent = true }),

  vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" }),
  vim.keymap.set("n", "<localleader>mo", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Evaluate Operator" }),
  vim.keymap.set("n", "<localleader>ml", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" }),
  vim.keymap.set("n", "<localleader>mc", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" }),
  vim.keymap.set(
    "v",
    "<localleader>mv",
    ":<C-u>MoltenEvaluateVisual<CR>gv",
    { silent = true, desc = "Evaluate Visual Selection" }
  ),
}
