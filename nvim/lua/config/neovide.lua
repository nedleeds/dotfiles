-- Neovide 전용 설정
if not vim.g.neovide then
  return
end

--------------------------------------------------
-- Font
--------------------------------------------------
vim.o.guifont = "JetBrainsMono Nerd Font:h11"

--------------------------------------------------
-- Opacity (NEW)
--------------------------------------------------
vim.g.neovide_opacity = 1.0

--------------------------------------------------
-- Rendering
--------------------------------------------------
vim.g.neovide_refresh_rate = 120

--------------------------------------------------
-- Cursor
--------------------------------------------------
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_size = 0.3
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_vfx_mode = ""

--------------------------------------------------
-- Padding
--------------------------------------------------
vim.g.neovide_padding_top = 6
vim.g.neovide_padding_bottom = 6
vim.g.neovide_padding_left = 6
vim.g.neovide_padding_right = 6

--------------------------------------------------
-- Clipboard
--------------------------------------------------
vim.opt.clipboard = "unnamedplus"
vim.g.neovide_input_use_logo = true

--------------------------------------------------
-- Misc
--------------------------------------------------
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_remember_window_size = true
