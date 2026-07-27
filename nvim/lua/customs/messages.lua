local M = {}

function M.show()
    local lines = vim.split(vim.fn.execute("messages"), "\n", { trimempty = true })
    lines = vim.tbl_map(function(l) return " " .. l end, lines)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = "wipe"

    local win = vim.api.nvim_open_win(buf, true, {
        split  = "below",
        height = math.floor(vim.o.lines * 0.3),
    })

    vim.wo[win].winbar         = " Message History  "
    vim.wo[win].number         = false
    vim.wo[win].relativenumber = false

    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, desc = "닫기" })
end

return M
