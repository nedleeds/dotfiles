return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    local ok, vscode = pcall(require, "vscode")
    if not ok then
      return
    end

    -- VSCode theme setup (keep it close to original tone)
    vscode.setup({
      transparent = true,
      italic_comments = true,
      underline_links = true,
      disable_nvimtree_bg = true,
    })

    vscode.load()

    -- block cursor like you had
    vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

    -- helper: apply highlights after colorscheme (and on :colorscheme reload)
    local function apply_overrides()
      -- =========================
      -- Base transparency
      -- =========================
      vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

      -- muted / low saturation
      vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = "#7f9fbf" }) -- soft gray-blue
      vim.api.nvim_set_hl(0, "@lsp.type.method",    { fg = "#c8c093" }) -- soft warm beige
      vim.api.nvim_set_hl(0, "@lsp.type.function",  { fg = "#c8c093" })

      vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#252525" })
      -- =========================
      -- VSCode palette (best-effort)
      -- =========================
      local blue = "#4FC1FF"   -- VS Code Dark+ blue-ish
      local orange = "#CE9178" -- VS Code Dark+ orange-ish
      local bg_cursorline = "#252525"
      local bg_visual = "#264F78"


      do
        -- vscode.nvim exposes colors; keep this defensive across versions
        local okc, c = pcall(function() return require("vscode.colors").get_colors() end)
        if okc and type(c) == "table" then
          blue = c.vscBlue or blue
          orange = c.vscOrange or orange
          bg_cursorline = "#252525"
          bg_visual = c.vscSelection or bg_visual
        end
      end

      -- =========================
      -- LSP hover border / floats
      -- =========================
      vim.api.nvim_set_hl(0, "LspFloatBorder", { fg = blue, bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder",    { link = "LspFloatBorder" })

      -- =========================
      -- Tabline / mini.tabline
      -- =========================
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TabLine",     { link = "Comment" })
      vim.api.nvim_set_hl(0, "TabLineSel",  { link = "Title" })

      vim.api.nvim_set_hl(0, "MiniTablineFill",    { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniTablineHidden",  { link = "Comment" })
      vim.api.nvim_set_hl(0, "MiniTablineVisible", { link = "Normal" })
      vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "Title" })

      -- Modified states (similar to your github config)
      vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden",  { fg = orange, bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { fg = orange, bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { fg = orange, bg = "NONE", bold = true, italic = true })

      -- =========================
      -- Treesitter links (reuse theme groups)
      -- =========================
      vim.api.nvim_set_hl(0, "@keyword.import.python",   { link = "Keyword" })
      vim.api.nvim_set_hl(0, "@keyword.import",          { link = "Keyword" })
      vim.api.nvim_set_hl(0, "@module.python",           { link = "Identifier" })
      vim.api.nvim_set_hl(0, "@module",                  { link = "Identifier" })
      vim.api.nvim_set_hl(0, "@keyword.function.python", { link = "Statement" })
      vim.api.nvim_set_hl(0, "@keyword.function",        { link = "Statement" })

      -- =========================
      -- Statusline / msgarea / splits cleanup
      -- =========================
      vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MsgArea",      { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MsgSeparator", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })

      -- =========================
      -- Cursor / visual (subtle)
      -- =========================
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#252525" })
      vim.api.nvim_set_hl(0, "Visual",     { bg = bg_visual, fg = "NONE" })
      vim.api.nvim_set_hl(0, "VisualNOS",  { link = "Visual" })

      -- =========================
      -- Semantic tokens: module vs method (requests.get)
      -- =========================
      -- module/package name: requests
      vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = blue })

      -- method/function name: get
      vim.api.nvim_set_hl(0, "@lsp.type.method",    { link = "Function" })
      vim.api.nvim_set_hl(0, "@lsp.type.function",  { link = "Function" })

      -- Optional: attribute / property clarity
      vim.api.nvim_set_hl(0, "@lsp.type.property",  { link = "Identifier" })
    end

    apply_overrides()

    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("VscodeThemeOverridesFzf", { clear = true }),
      pattern = { "fzf", "fzf-lua" },
      callback = apply_overrides,
    })
    -- Re-apply after any :colorscheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("VscodeThemeOverrides", { clear = true }),
      callback = apply_overrides,
    })

      -- soften fzf-lua match highlight
      vim.api.nvim_set_hl(0, "FzfLuaSearch", { fg = "#f58900", bold = false })

      -- selected line
      vim.api.nvim_set_hl(0, "FzfLuaCursorLine", { bg = "#252525" })

      -- popup background (transparent look)
      vim.api.nvim_set_hl(0, "FzfLuaNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#7f9fbf", bg = "NONE" })

      -- FzfLua selection / cursorline variants (covers multiple versions)
      vim.api.nvim_set_hl(0, "FzfLuaCursorLine",   { bg = "#252525" })
      vim.api.nvim_set_hl(0, "FzfLuaCursorLineNr", { bg = "#252525" })
      vim.api.nvim_set_hl(0, "FzfLuaSel",          { bg = "#252525" })
      vim.api.nvim_set_hl(0, "FzfLuaSelBg",        { bg = "#252525" })
      vim.api.nvim_set_hl(0, "FzfLuaFzfCursorLine",{ bg = "#252525" })

  end,
}

-- return {
--   "projekt0n/github-nvim-theme",
--   name = "github-theme",
--   lazy = false,
--   priority = 1000,
--
--   config = function(_, opts)
--     local ok_gh, github = pcall(require, "github-theme")
--     if not ok_gh then
--       return
--     end
--
--     github.setup(opts)
--
--     -- colorscheme 먼저 적용
--     vim.cmd.colorscheme("github_dark_default")
--
--     -- 커서를 블록으로 설정
--     vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
--
--     -- =========================
--     -- Minimal overrides (keep GitHub original tone)
--     -- =========================
--
--     -- Base transparency
--     vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
--
--     -- LSP hover border
--     do
--       local okp, palette = pcall(require, "github-theme.palette")
--       if okp then
--         local c = palette.load(vim.g.colors_name)
--
--         local blue = c.blue
--         if type(blue) == "table" then
--           blue = blue.base or blue.fg or blue[1]
--         end
--
--         vim.api.nvim_set_hl(0, "LspFloatBorder", { fg = blue, bg = "NONE" })
--         vim.api.nvim_set_hl(0, "FloatBorder", { link = "LspFloatBorder" })
--       end
--     end
--
--     -- Tabline / mini.tabline (link만)
--     vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "TabLine",     { link = "Comment" })
--     vim.api.nvim_set_hl(0, "TabLineSel",  { link = "Title" })
--
--     vim.api.nvim_set_hl(0, "MiniTablineFill",    { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "MiniTablineHidden",  { link = "Comment" })
--     vim.api.nvim_set_hl(0, "MiniTablineVisible", { link = "Normal" })
--     vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "Title" })
--
--     -- =========================
--     -- mini.tabline: Modified
--     -- =========================
--     do
--       local okp, palette = pcall(require, "github-theme.palette")
--       if okp then
--         local c = palette.load(vim.g.colors_name)
--
--         local function pick(v)
--           if type(v) == "string" or type(v) == "number" then
--             return v
--           end
--           if type(v) == "table" then
--             return v.base or v.fg or v[1]
--           end
--         end
--
--         local modified_fg = pick(c.orange) or pick(c.yellow) or pick(c.magenta) or pick(c.blue)
--
--         vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
--           fg = modified_fg,
--           bg = "NONE",
--           bold = true,
--         })
--         vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
--           fg = modified_fg,
--           bg = "NONE",
--           bold = true,
--         })
--         vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
--           fg = modified_fg,
--           bg = "NONE",
--           bold = true,
--           italic = true,
--         })
--       else
--         vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden",  { bg = "NONE", bold = true })
--         vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { bg = "NONE", bold = true })
--         vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { bg = "NONE", bold = true })
--       end
--     end
--
--     -- Treesitter links (색을 직접 찍지 않고 테마 그룹 재사용)
--     vim.api.nvim_set_hl(0, "@keyword.import.python",   { link = "Keyword" })
--     vim.api.nvim_set_hl(0, "@keyword.import",          { link = "Keyword" })
--     vim.api.nvim_set_hl(0, "@module.python",           { link = "Identifier" })
--     vim.api.nvim_set_hl(0, "@module",                  { link = "Identifier" })
--     vim.api.nvim_set_hl(0, "@keyword.function.python", { link = "Statement" })
--     vim.api.nvim_set_hl(0, "@keyword.function",        { link = "Statement" })
--
--     -- Statusline transparency (lualine bg band)
--     vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
--
--     -- Optional: cmdline/message/split bg cleanup
--     vim.api.nvim_set_hl(0, "MsgArea",       { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "MsgSeparator",  { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "WinSeparator",  { bg = "NONE" })
--
--     -- =========================
--     -- Cursor highlighting (subtle, theme-appropriate)
--     -- =========================
--     do
--       local okp, palette = pcall(require, "github-theme.palette")
--       if okp then
--         local c = palette.load(vim.g.colors_name)
--
--         local function pick(v)
--           if type(v) == "string" or type(v) == "number" then
--             return v
--           end
--           if type(v) == "table" then
--             return v.base or v.fg or v[1]
--           end
--         end
--
--         local cursor_fg = pick(c.bg) or pick(c.bg_dim) or "#0d1117"
--
--         vim.api.nvim_set_hl(0, "CursorLine", { bg = "#262b33" })
--         vim.api.nvim_set_hl(0, "TermCursor", {
--           bg = "#58a6ff",
--           fg = cursor_fg,
--         })
--
--         vim.api.nvim_set_hl(0, "Visual",     { bg = "#30363d", fg = "NONE" })
--         vim.api.nvim_set_hl(0, "VisualNOS", { link = "Visual" })
--       else
--         vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#22262e" })
--         vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
--         vim.api.nvim_set_hl(0, "Cursor",       { bg = "#0d1117", fg = "#1a1d23" })
--         vim.api.nvim_set_hl(0, "TermCursor",   { bg = "#1a1d23", fg = "#0d1117" })
--         vim.api.nvim_set_hl(0, "Visual",       { bg = "#1b2027" })
--         vim.api.nvim_set_hl(0, "VisualNOS",    { link = "Visual" })
--       end
--     end
--   end,
-- }
