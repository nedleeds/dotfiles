return {
  {
    "SmiteshP/nvim-navic",
    event = "BufReadPre",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local navic = require("nvim-navic")
      -- 기본 아이콘 설정 (Nerd Font 필요)
      navic.setup({
        lazy_update_context = true,  -- CursorMoved 대신 CursorHold 에만 업데이트
        icons = {
          File          = "󰈙 ",
          Module        = " ",
          Namespace     = "󰌗 ",
          Package       = " ",
          Class         = "󰌗 ",
          Method        = "󰆧 ",
          Property      = " ",
          Field         = " ",
          Constructor   = " ",
          Enum          = "󰒻 ",
          Interface     = "󰕘 ",
          Function      = "󰊕 ",
          Variable      = "󰆧 ",
          Constant      = "󰏿 ",
          String        = "󰀬 ",
          Number        = "󰎠 ",
          Boolean       = "◩ ",
          Array         = "󰅪 ",
          Object        = "󰅩 ",
          Key           = "󰌋 ",
          Null          = "󰟢 ",
          EnumMember    = " ",
          Struct        = "󰌗 ",
          Event         = " ",
          Operator      = "󰆕 ",
          TypeParameter = "󰊄 ",
        },
        highlight = true,
      })

      -- LSP가 시작될 때 nvim-navic을 자동으로 연결하는 설정
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("navic_auto_attach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- 언어 서버가 'Document Symbol' 기능을 지원할 때만 연결
          if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, args.buf)
          end
        end,
      })
    end,
  }
}
