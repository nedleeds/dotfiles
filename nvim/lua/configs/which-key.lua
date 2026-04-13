local M = {}

function M.setup(opts)
  local wk = require("which-key")
  wk.setup(opts)

  local function fix_hl()
    local hl = vim.api.nvim_set_hl
    hl(0, "WhichKey",          { link = "Keyword" })
    hl(0, "WhichKeyDesc",      { link = "Comment" })
    hl(0, "WhichKeyGroup",     { link = "Title" })
    hl(0, "WhichKeySeparator", { link = "NonText" })
    hl(0, "WhichKeyBorder",    { link = "FloatBorder" })
    hl(0, "WhichKeyNormal",    { link = "NormalFloat" })

    -- semantic (reused elsewhere)
    hl(0, "WKIconOn",    { fg = "#3FB950", bold = true })
    hl(0, "WKIconOff",   { fg = "#F85149", bold = true })
    hl(0, "WKIconDebug", { fg = "#FF7B72", bold = true })

    -- <leader> menu — blue→white→purple gradient (display order: a E q - b f g m r s w)
    hl(0, "WKL1",  { fg = "#3B5BDB", bold = true }) -- 1  a   navy
    hl(0, "WKL2",  { fg = "#5070E0", bold = true }) -- 2  E   dark blue
    hl(0, "WKL3",  { fg = "#6687E8", bold = true }) -- 3  q   medium blue
    hl(0, "WKL4",  { fg = "#82A3F2", bold = true }) -- 4  -   light blue
    hl(0, "WKL5",  { fg = "#AABEFF", bold = true }) -- 5  b   pale blue
    hl(0, "WKL6",  { fg = "#E8EEFF", bold = true }) -- 6  f   near-white (peak)
    hl(0, "WKL7",  { fg = "#DDD6FE", bold = true }) -- 7  g   light purple
    hl(0, "WKL8",  { fg = "#C4B5FD", bold = true }) -- 8  m   medium purple
    hl(0, "WKL9",  { fg = "#A78BFA", bold = true }) -- 9  r   purple
    hl(0, "WKL10", { fg = "#8B5CF6", bold = true }) -- 10 s   deep purple
    hl(0, "WKL11", { fg = "#7C3AED", bold = true }) -- 11 w   violet

    -- g menu — blue→white→purple gradient (display order: gD gd gi grr gy)
    hl(0, "WKG1", { fg = "#5B9BFF", bold = true }) -- gD  electric blue
    hl(0, "WKG2", { fg = "#B0D4FF", bold = true }) -- gd  pale blue
    hl(0, "WKG3", { fg = "#EDE9FE", bold = true }) -- gi  near-white lavender
    hl(0, "WKG4", { fg = "#C4B5FD", bold = true }) -- grr medium purple
    hl(0, "WKG5", { fg = "#8B5CF6", bold = true }) -- gy  deep purple
  end

  fix_hl()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("WhichKeyHL", { clear = true }),
    callback = fix_hl,
  })

  wk.add({
    -- <leader> menu (display order: a E q - b f g m r s w)
    { "<leader>-",                            icon = { icon = "󰙅 ", hl = "WKL4"  } },
    { "<leader>E", group = "Open Workspace",  icon = { icon = "󰝰 ", hl = "WKL2"  } },
    { "<leader>a",                            icon = { icon = " ", hl = "WKL1"  } },
    { "<leader>b", group = "Buffer/Bookmark", icon = { icon = "󰓩 ", hl = "WKL5"  } },
    { "<leader>f", group = "Find",            icon = { icon = " ", hl = "WKL6"  } },
    { "<leader>g", group = "Git",             icon = { icon = "󰊢 ", hl = "WKL7"  } },
    { "<leader>m", group = "Messages",        icon = { icon = "󱅫 ", hl = "WKL8"  } },
    { "<leader>q",                            icon = { icon = "󰗼 ", hl = "WKL3"  } },
    { "<leader>r", group = "Refactor",        icon = { icon = "󱍓 ", hl = "WKL9"  } },
    { "<leader>s", group = "Session",         icon = { icon = " ", hl = "WKL10"  } },
    { "<leader>w", group = "Window",          icon = { icon = "󰖲 ", hl = "WKL11" } },

    -- g menu (rainbow order: gD gd gi grr gy)
    { "gD",  icon = { icon = " ", hl = "WKG1" } },
    { "gd",  icon = { icon = " ", hl = "WKG2" } },
    { "gi",  icon = { icon = " ", hl = "WKG3" } },
    { "grr", icon = { icon = " ", hl = "WKG4" } },
    { "gy",  icon = { icon = " ", hl = "WKG5" } },
  })
end

return M
