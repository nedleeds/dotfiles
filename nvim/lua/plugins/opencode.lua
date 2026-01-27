return {
  "NickvanDyke/opencode.nvim",

  dependencies = {
    "folke/snacks.nvim",
  },

  init = function()
    -- Ensure opencode CLI is discoverable from Neovim (before requiring opencode)
    do
        local p = vim.fn.expand("~/.opencode/bin")
        local path = vim.env.PATH or ""
        local sep = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and ";" or ":"

        if not path:find(p, 1, true) then
          vim.env.PATH = p .. sep .. path
        end
    end

    -- opencode opts (global)
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      terminal = {
        toggleterm = false,
        env = {
            NODE_TLS_REJECT_UNAUTHORIZED = "0",
        },
      },
      detect_tmux = false,
      tmux = { enabled = false },
      input = { enabled = true, provider = function(opts, on_submit) return require("snacks").input(opts, on_submit) end },
    }

    -- Required for `opts.events.reload`
    vim.o.autoread = true
  end,

  config = function()
    -- Configure safely
    local ok, opencode = pcall(require, "opencode")
    if not ok then
      return
    end
    -- 대부분 opencode는 vim.g.opencode_opts를 읽고 setup()을 호출해야 적용됩니다.
    -- 플러그인 구현에 따라 setup()이 없을 수도 있으니 pcall로 방어합니다.
    pcall(opencode.setup, vim.g.opencode_opts)
  end,
}
