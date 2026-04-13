return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    vim.g.VM_maps = {
      ["Find Under"]         = "<A-d>",
      ["Find Subword Under"] = "<A-d>",}
  end,
}
