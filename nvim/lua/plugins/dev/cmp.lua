-- lua/plugins/dev/cmp.lua
local M = {}

-- completeopt는 cmp UX에서 사실상 표준값
vim.o.completeopt = "menu,menuone,noinsert"

local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then
  return M
end

local ok_luasnip, luasnip = pcall(require, "luasnip")
if not ok_luasnip then
  return M
end

-- LSP completion capabilities 확장 (LSP에 주입할 값)
local ok_caps, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_caps then
  M.capabilities = cmp_lsp.default_capabilities()
else
  M.capabilities = vim.lsp.protocol.make_client_capabilities()
end

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert",
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    -- Tab: completion 선택 > snippet 점프/확장 > fallback
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
    { name = "buffer" },
  }),
})

return M
