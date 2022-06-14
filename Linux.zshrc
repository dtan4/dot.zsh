# -*- mode: sh -*-

export LESSOPEN='| /usr/bin/source-highlight-esc.sh %s'

alias ls='ls --color=auto'

if which wsl-open >/dev/null 2>&1; then
  # WSL2
  alias open=wsl-open
  alias xdg-open=wsl-open

  # for X410
  # https://x410.dev/cookbook/wsl/using-x410-with-wsl2/
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

  # use only one ssh-agent process throughout the login session
  ssh_agent_file=/tmp/ssh-agent

  if ! pgrep ssh-agent; then
    rm -f "${ssh_agent_file}" || true
    ssh-agent -s >"${ssh_agent_file}"
  fi

  if [[ -z "${SSH_AGENT_PID}" ]]; then
    if [[ ! -f "${ssh_agent_file}" ]]; then
      ssh-agent -s >"${ssh_agent_file}"
    fi

    eval "$(cat "${ssh_agent_file}")"
  fi
else
  # Linux Desktop
  alias open=xdg-open
fi

if [[ -d "${HOME}/google-cloud-sdk" ]]; then
  export PATH="${HOME}/google-cloud-sdk/bin":$PATH

  if [[ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "${HOME}/google-cloud-sdk/completion.zsh.inc"
  fi
fi
