local M = {}

local session_dir = vim.fn.stdpath("data") .. "/sessions/"
_G.CURRENT_SESSION_NAME = _G.CURRENT_SESSION_NAME or nil

local function ensure_session_dir()
  if vim.fn.isdirectory(session_dir) == 0 then
    vim.fn.mkdir(session_dir, "p")
  end
end

local function default_session_name()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ":t")
end

local function normalize_name(x)
  if x == nil then
    return nil
  end
  if type(x) == "string" then
    return x
  end
  if type(x) == "table" then
    if type(x[1]) == "string" then
      return x[1]
    end
    if type(x.line) == "string" then
      return x.line
    end
    return tostring(x)
  end
  return tostring(x)
end

local function first_selected(selected)
  if type(selected) ~= "table" then
    return normalize_name(selected)
  end
  return normalize_name(selected[1])
end

local function session_path(name)
  name = normalize_name(name)
  if not name or name == "" then
    return nil
  end
  return session_dir .. name .. ".vim"
end

local function list_sessions()
  ensure_session_dir()
  local out = {}

  for _, f in ipairs(vim.fn.readdir(session_dir)) do
    if type(f) == "string" and f:match("%.vim$") then
      local name = (f:gsub("%.vim$", "")) -- gsub multi-return 방지
      table.insert(out, name)
    end
  end

  table.sort(out)
  return out
end

local function save_session(name)
  ensure_session_dir()
  name = name or _G.CURRENT_SESSION_NAME or default_session_name()

  local path = session_path(name)
  if not path then
    vim.notify("세션 이름이 비어있습니다.", vim.log.levels.WARN)
    return
  end

  vim.cmd("silent! mksession! " .. vim.fn.fnameescape(path))
  _G.CURRENT_SESSION_NAME = name
  vim.notify("세션 저장: " .. name, vim.log.levels.INFO)
end

local function load_session(name)
  ensure_session_dir()
  name = normalize_name(name)

  local path = session_path(name)
  if not path or vim.fn.filereadable(path) ~= 1 then
    vim.notify("세션을 찾을 수 없음: " .. (name or "(nil)"), vim.log.levels.WARN)
    return
  end

  vim.cmd("silent! %bdelete!")
  vim.cmd("silent! source " .. vim.fn.fnameescape(path))
  _G.CURRENT_SESSION_NAME = name
  vim.notify("세션 로드: " .. name, vim.log.levels.INFO)
end

local function delete_session(name)
  ensure_session_dir()
  name = normalize_name(name)

  local path = session_path(name)
  if not path or vim.fn.filereadable(path) ~= 1 then
    vim.notify("세션을 찾을 수 없음: " .. (name or "(nil)"), vim.log.levels.WARN)
    return
  end

  vim.fn.delete(path)
  vim.notify("세션 삭제: " .. name, vim.log.levels.INFO)
end

local function rename_session(old_name, new_name)
  ensure_session_dir()
  old_name = normalize_name(old_name)
  new_name = normalize_name(new_name)

  if not old_name or old_name == "" then
    vim.notify("기존 세션 이름이 비어있습니다.", vim.log.levels.WARN)
    return
  end
  if not new_name or new_name == "" then
    vim.notify("새 세션 이름이 비어있습니다.", vim.log.levels.WARN)
    return
  end

  local old_path = session_path(old_name)
  local new_path = session_path(new_name)

  if not old_path or vim.fn.filereadable(old_path) ~= 1 then
    vim.notify("세션을 찾을 수 없음: " .. old_name, vim.log.levels.WARN)
    return
  end
  if new_path and vim.fn.filereadable(new_path) == 1 then
    vim.notify("이미 존재하는 세션 이름입니다: " .. new_name, vim.log.levels.WARN)
    return
  end

  local ok, err = os.rename(old_path, new_path)
  if not ok then
    vim.notify(("세션 이름 변경 실패: %s"):format(err or "unknown error"), vim.log.levels.ERROR)
    return
  end

  if _G.CURRENT_SESSION_NAME == old_name then
    _G.CURRENT_SESSION_NAME = new_name
  end

  vim.notify(("세션 이름 변경: %s -> %s"):format(old_name, new_name), vim.log.levels.INFO)
end

local function pick_session()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("fzf-lua를 로드할 수 없습니다. (packpath/설치 확인 필요)", vim.log.levels.ERROR)
    return
  end

  local sessions = list_sessions()
  if #sessions == 0 then
    vim.notify("저장된 세션이 없습니다.", vim.log.levels.INFO)
    return
  end

  fzf.fzf_exec(sessions, {
    prompt = "Sessions> ",

    -- preview OFF + 창 폭 축소
    winopts = {
      height = 0.65,
      width = 0.55, -- 가로 길이 줄임 (원하면 0.45~0.70 사이 조정)
      row = 0.35,
      col = 0.50,
      preview = { hidden = true },
    },

    fzf_opts = {
      ["--no-multi"] = "",
      ["--cycle"] = "",
      ["--reverse"] = "",

      -- separate info (not inline)
      ["--info"] = "default",
      ["--prompt"] = "Sessions> ",

      -- 키 힌트
      ["--header"] = "Enter: load   Ctrl-D: delete   Ctrl-S: save(overwrite)   Ctrl-R: rename",

      -- fzf가 ctrl-*를 안정적으로 accept 트리거 하도록
      ["--bind"] = "ctrl-d:accept,ctrl-s:accept,ctrl-r:accept",
    },

    actions = {
      ["default"] = function(selected)
        local name = first_selected(selected)
        if name and name ~= "" then
          load_session(name)
        end
      end,

      ["ctrl-d"] = function(selected)
        local name = first_selected(selected)
        if name and name ~= "" then
          delete_session(name)
          vim.schedule(pick_session)
        end
      end,

      ["ctrl-s"] = function(selected)
        local name = first_selected(selected)
        if name and name ~= "" then
          save_session(name)
          vim.schedule(pick_session)
        end
      end,

      ["ctrl-r"] = function(selected)
        local old_name = first_selected(selected)
        if not old_name or old_name == "" then
          return
        end

        vim.ui.input({
          prompt = ("Rename session '%s' to: "):format(old_name),
          default = old_name,
        }, function(input)
          if input == nil then
            return
          end
          local new_name = input:gsub("^%s+", ""):gsub("%s+$", "")
          if new_name == "" or new_name == old_name then
            return
          end
          rename_session(old_name, new_name)
          vim.schedule(pick_session)
        end)
      end,
    },
  })
end

function M.setup()
  ensure_session_dir()

  vim.keymap.set("n", "<leader>ss", function()
    local def = _G.CURRENT_SESSION_NAME or default_session_name()
    vim.ui.input({ prompt = "세션 이름 (기본값: " .. def .. "): " }, function(input)
      if input == nil then
        return
      end
      if input == "" then
        save_session(def)
      else
        save_session(input)
      end
    end)
  end, { desc = "Session: save" })

  vim.keymap.set("n", "<leader>sl", function()
    pick_session()
  end, { desc = "Session: list/load" })

  vim.keymap.set("n", "<leader>sd", function()
    vim.ui.input({ prompt = "삭제할 세션 이름: " }, function(input)
      if input and input ~= "" then
        delete_session(input)
      end
    end)
  end, { desc = "Session: delete" })

  local auto_group = "SessionAutoSave"
  local auto_save_enabled = false

  vim.keymap.set("n", "<leader>sc", function()
    auto_save_enabled = not auto_save_enabled
    if auto_save_enabled then
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup(auto_group, { clear = true }),
        callback = function()
          save_session()
        end,
      })
      vim.notify("세션 자동 저장: ON", vim.log.levels.INFO)
    else
      pcall(vim.api.nvim_del_augroup_by_name, auto_group)
      vim.notify("세션 자동 저장: OFF", vim.log.levels.INFO)
    end
  end, { desc = "Session: toggle autosave" })

  vim.api.nvim_create_user_command("SessionSave", function(opts)
    save_session(opts.args ~= "" and opts.args or nil)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("SessionLoad", function(opts)
    load_session(opts.args)
  end, { nargs = 1, complete = list_sessions })

  vim.api.nvim_create_user_command("SessionDelete", function(opts)
    delete_session(opts.args)
  end, { nargs = 1, complete = list_sessions })

  vim.api.nvim_create_user_command("SessionList", function()
    pick_session()
  end, {})
end

-- M.setup()
return M
