return {
  "stevearc/oil.nvim",
  -- Oil은 디렉터리 버퍼/열기 동작에 관여하니 보통 lazy-load를 과하게 걸지 않는 편이 안전합니다.
  -- 필요하면 event = "VeryLazy" 같은 식으로 조정하세요.
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  opts = {
    default_file_explorer = true,
    columns = {
      "icon",
      "mtime",
    },
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    delete_to_trash = false,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = false,
    },
    constrain_cursor = "editable",
    watch_for_changes = false,
    keymaps = {},
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, bufnr)
        local m = name:match("^%.")
        return m ~= nil
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
      natural_order = "fast",
      case_insensitive = false,
      sort = {
        { "type", "asc" },
        { "name", "asc" },
      },
      highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        return nil
      end,
    },
    float = {
      padding = 2,
      max_width = 0.5,
      max_height = 0.3,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
      get_win_title = nil,
      preview_split = "right",
      override = function(conf)
        return conf
      end,
    },
    preview_win = {
      update_on_cursor_moved = true,
      preview_method = "fast_scratch",
      disable_preview = function(filename)
        return false
      end,
      win_options = {},
    },
    confirmation = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = nil,
      minimized_border = "none",
      win_options = {
        winblend = 0,
      },
    },
    ssh = {
      border = nil,
    },
    keymaps_help = {
      border = nil,
    },
  },
}
