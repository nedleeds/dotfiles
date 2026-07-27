vim.pack.add({
    "https://github.com/nvim-mini/mini.files",
    "https://github.com/nvim-mini/mini.tabline",
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-mini/mini.sessions",
    "https://github.com/nvim-mini/mini.surround",
    "https://github.com/nvim-mini/mini.move",
    "https://github.com/nvim-mini/mini.starter",
})

local map = vim.keymap.set

-- ── mini.files ───────────────────────────────────────────────
local MiniFiles = require("mini.files")

MiniFiles.setup({
    windows = {
        max_number  = 1,
        preview     = false,
        width_focus = 50,
    },
})

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
        vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
    end,
})

map("n", "<leader>-", function()
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  if path == "" or not vim.uv.fs_stat(path) then
    local dir = vim.fs.dirname(path)
    path = (dir ~= "" and vim.uv.fs_stat(dir)) and dir or vim.fn.getcwd()
  end
  MiniFiles.open(path)
end, { desc = "file explorer" })

-- ── mini.tabline ─────────────────────────────────────────────
require("mini.tabline").setup()

-- ── mini.pick ────────────────────────────────────────────────
local pick = require('mini.pick')
local function preview_move(by)
  return function()
    local m = pick.get_picker_matches()
    if not m or not m.all_inds or #m.all_inds == 0 then return end
    local n = #m.all_inds
    local cur = m.current_ind or 1
    local new_pos = ((cur - 1 + by) % n) + 1
    pick.set_picker_match_inds({ m.all_inds[new_pos] }, 'current')

    -- 이동 후 현재 항목을 target 창에 열고 가운데 정렬
    local m2 = pick.get_picker_matches()
    local st = pick.get_picker_state()
    local target = st and st.windows and st.windows.target
    local main = st and st.windows and st.windows.main
    if not (m2 and m2.current and target and vim.api.nvim_win_is_valid(target)) then return end

    vim.api.nvim_win_call(target, function()
      pick.default_choose(m2.current)   -- files/grep/buffers 모두 파싱해서 열어줌
      vim.cmd('normal! zz')             -- 가운데 정렬
    end)
    if main and vim.api.nvim_win_is_valid(main) then
      vim.api.nvim_set_current_win(main)  -- picker로 포커스 복귀
    end
  end
end

require("mini.pick").setup({
    window = {
        config = function()
            return {
                border = "rounded",
                height = math.floor(0.2 * vim.o.lines),
                width = math.floor(0.4 * vim.o.columns),
            }
        end,
    },
    mappings = {
        move_down = '',   -- 기본 이동 비활성화
        move_up = '',
        preview_down = { char = '<C-n>', func = preview_move(1) },
        preview_up   = { char = '<C-p>', func = preview_move(-1) },
    },
})

map("n", "<leader>ff", "<cmd>Pick files<CR>",     { desc = "Find file" })
map("n", "<leader>fg", "<cmd>Pick grep_live<CR>", { desc = "Live grep" })
map("n", "<leader>fb", function()
  require("mini.pick").builtin.buffers()
  vim.schedule(function()
    vim.api.nvim_feedkeys(vim.keycode("<Tab>"), "t", false)
  end)
end, { desc = "Find buffer" })
map("n", "<leader>fh", "<cmd>Pick help<CR>",      { desc = "Search help" })


-- ── mini.sessions ────────────────────────────────────────────
local MiniSessions = require("mini.sessions")

MiniSessions.setup({
  autoread  = false,
  autowrite = true,
})

map("n", "<leader>ss", function()
  local current = vim.v.this_session
  local default = current ~= "" and vim.fn.fnamemodify(current, ":t") or ""

  local name = vim.fn.input("세션 이름: ", default)
  if name ~= "" then
    MiniSessions.write(name)
  end
end, { desc = "세션 저장" })
map("n", "<leader>sl", function() MiniSessions.select("read") end,   { desc = "세션 불러오기" })
map("n", "<leader>sd", function()
  local names = vim.tbl_keys(MiniSessions.detected)

  vim.ui.select(names, { prompt = "삭제할 세션:" }, function(name)
    if not name then return end
    local ok = vim.fn.confirm(("'%s' 세션을 삭제할까요?"):format(name), "&Yes\n&No", 2) == 1
    if ok then
      MiniSessions.delete(name, { force = true })
    end
  end)
end, { desc = "세션 삭제" })


-- ── mini.surround ────────────────────────────────────────────
require("mini.surround").setup({
  mappings = {
    add = "sa",
    delete = "sd",
    replace = "sr",
    find = "sf",
    find_left = "sF",
    highlight = "sh",
  },
})


-- ── mini.move ────────────────────────────────────────────
require("mini.move").setup({
  mappings = {
    left  = "H",
    right = "L",
    down  = "J",
    up    = "K",
  },
})


-- ── mini.starter ────────────────────────────────────────────
local starter = require("mini.starter")

local function session_items()
  local sessions = require("mini.sessions").detected

  local names = vim.tbl_keys(sessions)
  -- 대괄호 뗀 이름 기준으로 정렬 (표시는 원본 유지)
  table.sort(names, function(a, b)
    local ka = a:gsub("^%[", ""):gsub("%]$", "")
    local kb = b:gsub("^%[", ""):gsub("%]$", "")
    return ka:lower() < kb:lower()
  end)

  local items = {}
  for i, name in ipairs(names) do
    items[i] = {
      name = string.format("%d. %s", i, name),   -- 표시: 원본 (대괄호 살림)
      action = function() require("mini.sessions").read(name) end,
      section = "Sessions",
    }
  end
  return items
end

starter.setup({
  items = {
    session_items(),
    { name = "New file", action = "enew",        section = "Actions" },
    { name = "Config",   action = "edit $MYVIMRC", section = "Actions" },
    { name = "Quit",     action = "qa",           section = "Actions" },
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(),
    starter.gen_hook.aligning("center", "center"),
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniStarterOpened",
  callback = function(args)
    local buf = args.buf
    local starter = require("mini.starter")

    vim.keymap.set("n", "j", function()
      starter.update_current_item("next", buf)
    end, { buffer = buf })

    vim.keymap.set("n", "k", function()
      starter.update_current_item("prev", buf)
    end, { buffer = buf })

    vim.schedule(function()
      starter.update_current_item("next", buf)
      starter.refresh()
    end)
  end,
})
