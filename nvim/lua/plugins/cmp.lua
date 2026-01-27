return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- completion sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",

      -- snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- optional: snippet collections
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- friendly-snippets 로드(선택)
      pcall(function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end)

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

          window = {
            completion = cmp.config.window.bordered({
              border = "rounded",  -- single | double | rounded | solid | shadow
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            }),
            documentation = cmp.config.window.bordered({
              border = "rounded",
            }),
          },
        -- UI/동작 기본값
        completion = {
          completeopt = "menu,menuone,noselect",
        },

        mapping = cmp.mapping.preset.insert({
          -- 닫기: Ctrl-e
          ["<C-e>"] = cmp.mapping.abort(),

          -- 확정: Ctrl-y (현재 선택 항목 확정)
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          -- 이동: Ctrl-n / Ctrl-p
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

          -- (선택) 스크롤
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),

          -- (선택) Tab으로 스니펫 점프까지 같이
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
