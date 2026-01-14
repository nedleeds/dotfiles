vim.g.neovide_opacity = 0.88
vim.o.guifont = "JetBrainsMono Nerd Font:h13"
vim.keymap.set("n", "<C-=>", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end)

vim.keymap.set("n", "<C-->", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end)

vim.g.clipboard = {
  name = "powershell-clipboard",
  copy = {
    ["+"] = { "powershell.exe", "-NoProfile", "-Command", "Set-Clipboard -Value ([Console]::In.ReadToEnd())" },
    ["*"] = { "powershell.exe", "-NoProfile", "-Command", "Set-Clipboard -Value ([Console]::In.ReadToEnd())" },
  },
  paste = {
    ["+"] = { "powershell.exe", "-NoProfile", "-Command", "Get-Clipboard -Raw" },
    ["*"] = { "powershell.exe", "-NoProfile", "-Command", "Get-Clipboard -Raw" },
  },
  cache_enabled = 0,
}

-- init.lua
require("config.options")
require("config.keymaps")

require("plugins.bootstrap")
require("plugins.init")

