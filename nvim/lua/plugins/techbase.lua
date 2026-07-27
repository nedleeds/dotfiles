vim.pack.add({
  { src = "https://github.com/mcauley-penney/techbase.nvim" },
})

-- ── 팔레트 ───────────────────────────────────────────────────
local c = {
    none      = "none",

    white     = "#ffffff",   -- 현재 버퍼 / 포커스된 제목
    fg        = "#e6edf3",   -- 본문 텍스트
    gray      = "#6e7681",   -- 비활성 텍스트
    gray_dim  = "#484f58",   -- 더 흐린 회색 (필요 시)
    border    = "#484f58",   -- floating window 테두리

    cursorline = "#161b22",  -- 현재 줄 배경

    yellow        = "#e3b341",  -- 수정됨 (현재)
    yellow_mid    = "#d29922",  -- 수정됨 (visible)
    yellow_dark   = "#9e6a03",  -- 수정됨 (hidden)

    blue   = "#58a6ff",
    orange = "#f0883e",
    green  = "#7ee787",
    red    = "#f85149",
}

require("techbase").setup({
  italic_comments = false,
  transparent = true,
  hl_overrides = {
  },
      groups = {
            CursorLine   = { bg = c.cursorline },
            CursorLineNr = { fg = c.fg, bg = c.cursorline, style = "bold" },
            Search    = { bg = c.none, fg = c.green, style = "underline"},
            CurSearch = { bg = c.none, fg = c.green, style = "underline"},
            IncSearch = { bg = c.none, fg = c.green, style = "underline"},

            -- mini.tabline
            MiniTablineHidden          = { fg = c.gray,        bg = c.none },
            MiniTablineVisible         = { fg = c.gray,        bg = c.none },
            MiniTablineCurrent         = { fg = c.white,       bg = c.none, style = "bold" },
            MiniTablineModifiedHidden  = { fg = c.yellow_dark, bg = c.none },
            MiniTablineModifiedVisible = { fg = c.yellow_mid,  bg = c.none },
            MiniTablineModifiedCurrent = { fg = c.yellow,      bg = c.none, style = "bold" },
            MiniTablineFill            = { bg = c.none },
            MiniTablineTabpagesection  = { fg = c.gray,        bg = c.none },

            -- 상태줄
            StatusLine   = { fg = c.white, bg = c.none, style = "bold" },
            StatusLineNC = { fg = c.gray,  bg = c.none, style = "underline" },
            ToggleTermStatusLine   = { fg = c.white, bg = c.none },
            ToggleTermStatusLineNC = { fg = c.gray,  bg = c.none },

            -- floating window
            NormalFloat = { fg = c.fg,     bg = c.none },
            FloatBorder = { fg = c.border, bg = c.none },
            FloatTitle  = { fg = c.border, bg = c.none },

            -- mini.files
            MiniFilesNormal         = { bg = c.none },
            MiniFilesBorder         = { fg = c.border,     bg = c.none },
            MiniFilesBorderModified = { fg = c.yellow_mid, bg = c.none },
            MiniFilesTitle          = { fg = c.border,     bg = c.none },
            MiniFilesTitleFocused   = { fg = c.white,      bg = c.none, style = "bold" },
            MiniFilesCursorLine     = { bg = c.none,       style = "bold,underline" },
            -- mini.pick
            MiniPickMatchRanges     = { fg = "palette.blue", style = "bold" },

            -- which-key
            WhichKey          = { fg = c.fg },
            WhichKeyGroup     = { fg = c.border },
            WhichKeyDesc      = { fg = c.gray },
            WhichKeySeparator = { fg = c.gray },
            WhichKeyFloat     = { bg = c.none },
            WhichKeyBorder    = { fg = c.border, bg = c.none },

            -- GitSigns
            GitSignsAdd    = { fg = c.green, bg = c.none },
            GitSignsChange = { fg = c.yellow, bg = c.none },
            GitSignsDelete = { fg = c.red, bg = c.none },
            GitSignsCurrentLineBlame = { fg = c.gray, style = "italic" },

            -- RenderMarkdown
            ["@markup.raw"] = { fg = "#e6edf3", style = "NONE" },
            RenderMarkdownCode       = { bg = c.none },
            RenderMarkdownCodeInline = { bg = c.none },
            RenderMarkdownCodeBorder = { bg = c.none },

            IlluminatedWordText  = { bg = c.none, style = "underline" },
            IlluminatedWordRead  = { bg = c.none, style = "underline" },
            IlluminatedWordWrite = { bg = c.none, style = "underline" },

            -- 자동 완성 팝업
            Pmenu         = { fg = c.fg,     bg = c.none },
            PmenuSel      = { fg = c.white,  bg = c.cursorline, style = "bold" },
            PmenuSbar     = { bg = c.none },
            PmenuThumb    = { bg = c.gray },
            PmenuKind     = { fg = c.gray,   bg = c.none },
            PmenuKindSel  = { fg = c.gray,   bg = c.cursorline },
            PmenuExtra    = { fg = c.gray,   bg = c.none },
            PmenuExtraSel = { fg = c.gray,   bg = c.cursorline },
            PmenuMatch    = { fg = c.blue, bg = c.none, style = "bold" },
            PmenuMatchSel = { fg = c.blue, bg = c.cursorline, style = "bold" },
    },
})

vim.cmd.colorscheme("techbase")


            -- 상태줄

