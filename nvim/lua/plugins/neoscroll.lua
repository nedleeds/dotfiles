vim.pack.add({ "https://github.com/karb94/neoscroll.nvim" })

local neoscroll = require("neoscroll")

neoscroll.setup({
  hide_cursor          = true,
  cursor_scrolls_alone = true,

  stop_eof             = true,
  respect_scrolloff    = true,

  easing_function      = "quadratic",
  mappings             = {},   -- 기본 매핑 끄고 아래에서 직접 정의
})

local mappings = {
  ["<C-u>"] = function() neoscroll.scroll(-5,   { move_cursor = true,  duration = 100 }) end,
  ["<C-d>"] = function() neoscroll.scroll( 5,   { move_cursor = true,  duration = 100 }) end,
  ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end,
  ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end,
  ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 }) end,
  ["<C-e>"] = function() neoscroll.scroll( 0.1, { move_cursor = false, duration = 100 }) end,
  ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end,
  ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end,
  ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end,
}

for key, fn in pairs(mappings) do
  vim.keymap.set({ "n", "v", "x" }, key, fn)
end
