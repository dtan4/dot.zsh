# -*- mode: sh -*-

# reload .zshrc
alias reload='exec zsh -l'

# extend cd
alias cddown='cd ~/Downloads'
alias cdtmp='cd ~/tmp'
alias cdgit='cd ~/src/github.com/dtan4'

# extend existing command
alias curl='noglob curl' # Do not expand wildcards in URL
alias g='git'
alias gcc='gcc -Werror -Wall'

alias alpine='docker run -it --rm alpine:3.15 /bin/sh'
alias ubuntu='docker run -it --rm ubuntu:22.04 /bin/bash'

# Escape from MOJIBAKEd shell
# http://orangeclover.hatenablog.com/entry/20110201/1296511181
alias mojibake="echo -e '\026\033c'"

if [[ -x "$(which colordiff)" ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

if [[ -x "$(which bazelisk)" ]]; then
  alias bazel='bazelisk'
fi

if command -v bat >/dev/null 2>&1; then
  alias bl="bat --paging always --style plain"
fi
