-- =========================================================
-- Noice: 안전 로드 (플러그인 미설치/미로드 시 init 깨짐 방지)
-- =========================================================
local ok_noice, noice = pcall(require, "noice")
if not ok_noice or type(noice) ~= "table" then
  return
end

local function noice_open(url)
  local ok_util, util = pcall(require, "noice.util")
  if ok_util and type(util) == "table" and type(util.open) == "function" then
    return util.open(url)
  end
end

noice.setup({
  -- (이 아래는 기존 setup 내용 그대로 유지)
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    opts = {},
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      input = { view = "cmdline_input", icon = "󰥻 " },
    },
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = "virtualtext",
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
    kind_icons = {},
  },
  redirect = {
    view = "popup",
    filter = { event = "msg_show" },
  },
  commands = {
    history = {
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
    },
    last = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = { count = 1 },
    },
    errors = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
    all = {
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {},
    },
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  lsp = {
    progress = {
      enabled = true,
      format = "lsp_progress",
      format_done = "lsp_progress_done",
      throttle = 1000 / 30,
      view = "mini",
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
      ["vim.lsp.util.stylize_markdown"] = false,
      ["cmp.entry.get_documentation"] = false,
    },
    hover = { enabled = true, silent = true, view = nil, opts = {} },
    signature = {
      enabled = true,
      auto_open = { enabled = true, trigger = true, luasnip = true, throttle = 50 },
      view = nil,
      opts = {},
    },
    message = { enabled = true, view = "notify", opts = {} },
    documentation = {
      view = "hover",
      opts = {
        lang = "markdown",
        replace = true,
        render = "plain",
        format = { "{message}" },
        win_options = { concealcursor = "n", conceallevel = 3 },
      },
    },
  },
  markdown = {
    hover = {
      ["|(%S-)|"] = vim.cmd.help,
      ["%[.-%]%((%S-)%)"] = noice_open,
    },
    highlights = {
      ["|%S-|"] = "@text.reference",
      ["@%S+"] = "@parameter",
      ["^%s*(Parameters:)"] = "@text.title",
      ["^%s*(Return:)"] = "@text.title",
      ["^%s*(See also:)"] = "@text.title",
      ["{%S-}"] = "@parameter",
    },
  },
  health = { checker = true },
  presets = {
    bottom_search = false,
    command_palette = false,
    long_message_to_split = false,
    inc_rename = false,
    lsp_doc_border = true,
  },
  throttle = 1000 / 30,
  views = {},
  routes = {
    { filter = { event = "msg_show", kind = "shell_out" }, view = "popup" },
    { filter = { event = "msg_show", kind = "shell_err" }, view = "popup" },
    { filter = { event = "msg_show", kind = "shell_ret" }, view = "popup" },
    { filter = { event = "msg_show", kind = "emsg" }, view = "popup" },
    { filter = { event = "msg_show", kind = "lua_print" }, view = "popup" },
    { filter = { event = "msg_show", kind = "echo" }, view = "popup" },
  },
  status = {},
  format = {},
})
