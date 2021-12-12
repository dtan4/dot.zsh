# -*- mode: sh -*-

function peco_select_history() {
  local tac
  if which gtac >/dev/null 2>&1; then
    tac="gtac"
  elif which tac >/dev/null 2>&1; then
    tac="tac"
  else
    tac="tail -r"
  fi

  BUFFER="$(fc -l -n 1 | eval "${tac}" | peco --query "$LBUFFER")"
  CURSOR=$#BUFFER # move cursor
  zle -R -c       # refresh
}
zle -N peco_select_history
bindkey "^R" peco_select_history

function peco-src() {
  local selected_dir
  selected_dir="$(ghq list | peco --query "${LBUFFER}")"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    CURSOR=$#BUFFER # move cursor
  fi
  zle -R -c # refresh
}
zle -N peco-src
bindkey "^W" peco-src

function open-gcp-dashboard() {
  local project
  project="$(gcloud projects list | tail -n+2 | peco | awk '{ print $1 }')"

  if [ -n "$project" ]; then
    open "https://console.cloud.google.com/home/dashboard?project=${project}"
  fi
}

function switch-gcp-projects() {
  local project
  project="$(gcloud projects list | tail -n+2 | peco | awk '{ print $1 }')"

  if [ -n "$project" ]; then
    gcloud config set project "${project}"
  fi
}

function switch-k8s-context() {
  local context
  context="$(kubectl config get-contexts -o name | peco)"

  if [ -n "$context" ]; then
    kubectl config use-context "${context}"
  fi
}

# http://k0kubun.hatenablog.com/entry/2014/07/06/033336
alias -g B='`git branch | peco | sed -e "s/^\*[ ]*//g"`'
alias -g C='`git log --oneline --branches | peco | cut -d" " -f1`'
alias -g F='`git ls-files | peco`'
