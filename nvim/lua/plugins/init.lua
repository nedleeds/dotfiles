-- UI
require("plugins.ui.colorscheme")   -- 테마 먼저
require("plugins.ui.noice")         -- 메시지/알림 UI
require("plugins.ui.lualine")       -- 상태줄
require("plugins.ui.mini-tabline")  -- 탭라인
require("plugins.ui.oil")           -- 파일 탐색
require("plugins.ui.fzf")           -- 검색/피커
require("plugins.ui.toggleterm")    -- 터미널
require("plugins.ui.zoom")          -- 윈도우 줌(유틸)

-- Dev / Tools
require("plugins.dev.treesitter")
require("plugins.dev.lsp")
require("plugins.dev.dap")
require("plugins.dev.dap-python")
require("plugins.dev.dap-cpp")
require("plugins.dev.lazygit")
