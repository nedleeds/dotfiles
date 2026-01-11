#!/usr/bin/env bash
# Execution context indicator for tmux status bar
#
# Priority:
# 1) Container   -> blue   + white name
# 2) SSH host    -> white host:<hostname>
# 3) Local macOS -> white  local
# 4) Local Linux -> white  local

# -------------------------------------------------
# tmux color helpers (GitHub Dark friendly)
# -------------------------------------------------
BLUE="#[fg=#58a6ff]"
WHITE="#[fg=#c9d1d9]"
MUTED="#[fg=#8b949e]"
RESET="#[fg=default]"

# -------------------------------------------------
# Helpers
# -------------------------------------------------
is_container() {
  [ -f "/.dockerenv" ] || \
  grep -qaE '(docker|kubepods|containerd)' /proc/1/cgroup 2>/dev/null
}

is_ssh() {
  [ -n "${SSH_CONNECTION}" ] || [ -n "${SSH_TTY}" ]
}

os_name() {
  uname -s 2>/dev/null
}

# -------------------------------------------------
# 1) Container
# -------------------------------------------------
if is_container; then
  cid="$(grep -aoE '([0-9a-f]{64}|[0-9a-f]{32})' /proc/1/cgroup 2>/dev/null | head -n 1)"
  cname=""

  # Try docker inspect → name
  if command -v docker >/dev/null 2>&1 && [ -n "${cid}" ]; then
    cname="$(docker inspect --format '{{.Name}}' "${cid}" 2>/dev/null | sed 's#^/##')"
  fi

  # Fallbacks
  [ -z "${cname}" ] && cname="$(hostname 2>/dev/null)"
  [ -z "${cname}" ] && [ -n "${cid}" ] && cname="ctr:${cid:0:12}"

  echo "${BLUE}  ${WHITE}${cname}${RESET}"
  exit 0
fi

# -------------------------------------------------
# 2) SSH Host
# -------------------------------------------------
if is_ssh; then
  echo "${WHITE}host:$(hostname)${RESET}"
  exit 0
fi

# -------------------------------------------------
# 3) Local (OS-based)
# -------------------------------------------------
case "$(os_name)" in
  Darwin)
    echo "${WHITE} local${RESET}"
    ;;
  Linux)
    echo "${WHITE} local${RESET}"
    ;;
  *)
    echo "${MUTED}local${RESET}"
    ;;
esac
