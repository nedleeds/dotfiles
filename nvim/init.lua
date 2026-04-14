local lsp_env = {
    INCLUDE = [[C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Windows Kits\8.1\include\shared;C:\Program Files (x86)\Windows Kits\8.1\include\um;C:\Program Files (x86)\Windows Kits\8.1\include\winrt;]],
}

vim.api.nvim_create_autocmd('BufReadPre', {
    callback = function() vim.lsp.config('clangd', { cmd_env = lsp_env }) end,
})
require("configs.options")
require("configs.keymaps")
require("configs.lazy")
require("configs.session").setup()
