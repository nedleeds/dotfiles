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
    ["+"] = { "powershell.exe", "-NoProfile", "-Command",
      "[Console]::InputEncoding=[Text.UTF8Encoding]::UTF8; $t=[Console]::In.ReadToEnd(); Set-Clipboard -Value $t"
    },
    ["*"] = { "powershell.exe", "-NoProfile", "-Command",
      "[Console]::InputEncoding=[Text.UTF8Encoding]::UTF8; $t=[Console]::In.ReadToEnd(); Set-Clipboard -Value $t"
    },
  },
  paste = {
    ["+"] = { "powershell.exe", "-NoProfile", "-Command",
      "[Console]::OutputEncoding=[Text.UTF8Encoding]::UTF8; $t=Get-Clipboard -Raw; $t=$t -replace \"`r`n\",\"`n\"; $t=$t -replace \"`r\",\"\"; [Console]::Write($t)"
    },
    ["*"] = { "powershell.exe", "-NoProfile", "-Command",
      "[Console]::OutputEncoding=[Text.UTF8Encoding]::UTF8; $t=Get-Clipboard -Raw; $t=$t -replace \"`r`n\",\"`n\"; $t=$t -replace \"`r\",\"\"; [Console]::Write($t)"
    },
  },
  cache_enabled = 0,
}

-- init.lua
require("config.options")
require("config.keymaps")

require("plugins.bootstrap")
require("plugins.init")

