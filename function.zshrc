# -*- mode: sh -*-

# cd to the top level of git project
function cdtop() {
  if git rev-parse --is-inside-work-tree >/dev/null; then
    cd "$(git rev-parse --show-toplevel)" || return
  fi
}

function ng() {
  git --no-pager "${@}"
}

# Omit some items from `ls` result
# http://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059
function ls_abbrev() {
  if [[ ! -r $PWD ]]; then
    return
  fi
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-CF' '--color=always')
  case "${OSTYPE}" in
  freebsd* | darwin*)
    if type gls >/dev/null 2>&1; then
      cmd_ls='gls'
    else
      opt_ls=('-CFG')
    fi
    ;;
  esac

  local ls_result
  ls_result="$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls "${opt_ls[@]}" | sed $'/^\e\[[0-9;]*m$/d')"

  local ls_lines
  ls_lines="$(echo "${ls_result}" | wc -l | tr -d ' ')"

  if [ "${ls_lines}" -gt 10 ]; then
    echo "${ls_result}" | head -n 5
    echo '...'
    echo "${ls_result}" | tail -n 5
    echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}

function chpwd() {
  ls_abbrev

  if [ -n "$TMUX" ]; then
    # http://qiita.com/usobuku/items/fce0f69586d82f963cbb
    tmux rename-window "zsh:$PWD:t"
  fi
}

function current-gcp-project() {
  gcloud config get-value project
}

function current-k8s-context() {
  kubectl config current-context
}

function dbu() {
  docker build -t "${1}" .
}

function update-go() {
  local go_version
  go_version="${1}"

  if [[ "${go_version}" == "" ]]; then
    echo "go_version is required" >&2
    return 1
  fi

  go install "golang.org/dl/go${go_version}@latest"
  "go${go_version}" download
  ln -sf "${GOPATH}/bin/go${go_version}" "${GOPATH}/bin/go"

  go version
}
