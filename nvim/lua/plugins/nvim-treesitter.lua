vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

require("nvim-treesitter").setup()
require("nvim-treesitter-textobjects").setup({ select = { lookahead = true } })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "python", "json", "yaml", "markdown", "html", "bash", "zig", "rust", "javascript", "java", "powershell"},
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})


local sel = require("nvim-treesitter-textobjects.select")
local map = function(key, obj)
  vim.keymap.set({ "x", "o" }, key, function()
    sel.select_textobject(obj, "textobjects")
  end)
end
map("if", "@function.inner")   -- vif
map("af", "@function.outer")   -- vaf
map("ic", "@class.inner")
map("ac", "@class.outer")
