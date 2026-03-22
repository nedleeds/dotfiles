return {
  "projekt0n/github-nvim-theme",
  name = "github-theme",
  lazy = false,
  priority = 1000,

  config = function(_, opts)
    local ok_gh, github = pcall(require, "github-theme")
    if not ok_gh then
      return
    end

    github.setup(opts)

    -- Make red palette less harsh
    do
      local okp, palette = pcall(require, "github-theme.palette")
      if okp then
        local default_scheme = "github_dark_default"
        local p = palette.load(default_scheme)

        if p then
          p.red = { base = "#c75050", bright = "#d46565" }
        end

        local loaded = package.loaded["github-theme.palette"]
        if loaded and loaded.load then
          local orig_load = loaded.load
          loaded.load = function(name)
            local result = orig_load(name)
            if name == default_scheme and result then
              result.red = { base = "#c75050", bright = "#d46565" }
            end
            return result
          end
        end
      end
    end

    -- colorscheme 먼저 적용
    vim.cmd.colorscheme("github_dark_default")

    -- 커서를 블록으로 설정
    vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

    -- =========================
    -- Minimal overrides (keep GitHub original tone)
    -- =========================

    -- Base transparency
    vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

    -- LSP hover border
    do
      local okp, palette = pcall(require, "github-theme.palette")
      if okp then
        local c = palette.load(vim.g.colors_name)

        local blue = c.blue
        if type(blue) == "table" then
          blue = blue.base or blue.fg or blue[1]
        end

        vim.api.nvim_set_hl(0, "LspFloatBorder", { fg = blue, bg = "NONE" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "LspFloatBorder" })
      end
    end

    -- Tabline / mini.tabline (link만)
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLine",     { link = "Comment" })
    vim.api.nvim_set_hl(0, "TabLineSel",  { link = "Title" })

    vim.api.nvim_set_hl(0, "MiniTablineFill",    { bg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniTablineHidden",  { link = "Comment" })
    vim.api.nvim_set_hl(0, "MiniTablineVisible", { link = "Normal" })
    vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "Title" })

    -- =========================
    -- mini.tabline: Modified
    -- =========================
    do
      local okp, palette = pcall(require, "github-theme.palette")
      if okp then
        local c = palette.load(vim.g.colors_name)

        local function pick(v)
          if type(v) == "string" or type(v) == "number" then
            return v
          end
          if type(v) == "table" then
            return v.base or v.fg or v[1]
          end
        end

        local modified_fg = pick(c.orange) or pick(c.yellow) or pick(c.magenta) or pick(c.blue)

        vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
          fg = modified_fg,
          bg = "NONE",
          bold = true,
        })
        vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
          fg = modified_fg,
          bg = "NONE",
          bold = true,
        })
        vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
          fg = modified_fg,
          bg = "NONE",
          bold = true,
          italic = true,
        })
      else
        vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden",  { bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { bg = "NONE", bold = true })
      end
    end

    -- Statusline transparency (lualine bg band)
    vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

    -- Optional: cmdline/message/split bg cleanup
    vim.api.nvim_set_hl(0, "MsgArea",       { bg = "NONE" })
    vim.api.nvim_set_hl(0, "MsgSeparator",  { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinSeparator",  { bg = "NONE" })

    -- =========================
    -- Cursor highlighting (subtle, theme-appropriate)
    -- =========================
    do
      local okp, palette = pcall(require, "github-theme.palette")
      if okp then
        local c = palette.load(vim.g.colors_name)

        local function pick(v)
          if type(v) == "string" or type(v) == "number" then
            return v
          end
          if type(v) == "table" then
            return v.base or v.fg or v[1]
          end
        end

        local cursor_fg = pick(c.bg) or pick(c.bg_dim) or "#0d1117"

        vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#1a1d23" })
        vim.api.nvim_set_hl(0, "CursorColumn", { bg = "NONE" })

        vim.api.nvim_set_hl(0, "Cursor", {
          bg = "#58a6ff",
          fg = cursor_fg,
        })
        vim.api.nvim_set_hl(0, "TermCursor", {
          bg = "#58a6ff",
          fg = cursor_fg,
        })

        vim.api.nvim_set_hl(0, "Visual", { bg = "#1a1d23", fg = nil })
        vim.api.nvim_set_hl(0, "VisualNOS", { link = "Visual" })
      else
        vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#0f1114" })
        vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
        vim.api.nvim_set_hl(0, "Cursor",       { bg = "#0d1117", fg = "#1a1d23" })
        vim.api.nvim_set_hl(0, "TermCursor",   { bg = "#1a1d23", fg = "#0d1117" })
        vim.api.nvim_set_hl(0, "Visual",       { bg = "#1a1d23" })
        vim.api.nvim_set_hl(0, "VisualNOS",    { link = "Visual" })
      end
    end
  end,
}

