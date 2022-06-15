# -*- mode: sh -*-

# shellcheck source=/dev/null

export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'

alias ls="ls -G -w"

if [[ -d /usr/local/opt/llvm/bin ]]; then
  export PATH=/usr/local/opt/llvm/bin:$PATH
fi

# Since /usr/local/kubebuilder/bin has its own kubectl, it should be placed at the loweest priority
export PATH=$PATH:/usr/local/kubebuilder/bin

export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10

[[ -d $(brew --prefix)/share/zsh/site-functions ]] && fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

if [[ -e /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]]; then
  source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
fi

if [[ -e /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc ]]; then
  source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

if [[ -e /usr/local/share/zsh/site-functions/_aws ]]; then
  source /usr/local/share/zsh/site-functions/_aws
fi

# https://github.com/pstadler/keybase-gpg-github#optional-setting-up-tty
export GPG_TTY="$(tty)"
