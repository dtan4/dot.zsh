# shellcheck source=/dev/null

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

typeset -x ZPLUG_HOME=$ZDOTDIR/zplug

source "${ZPLUG_HOME}/init.zsh"

zplug "zsh-users/zsh-completions", at:0.32.0
zplug "zsh-users/zsh-syntax-highlighting", at:0.7.1, defer:2
zplug "marzocchi/zsh-notify", at:v1.0

if ! zplug check --verbose; then
  echo
  zplug install
fi

fpath=("$ZPLUG_HOME/repos/zsh-users/zsh-completions/src/" $fpath)

if which rustup >/dev/null 2>&1; then
  mkdir -p ~/.zfunc
  fpath+=~/.zfunc
  rustup completions zsh rustup >~/.zfunc/_rustup
  rustup completions zsh cargo >~/.zfunc/_cargo
fi

autoload colors
colors

autoload -Uz add-zsh-hook

export PATH=/usr/local/bin:/usr/local/sbin:/sbin:$PATH

bindkey -e

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^[[Z" reverse-menu-complete # reverse completion menu by Shift-Tab

setopt auto_pushd
setopt list_packed
setopt nolistbeep
setopt noautoremoveslash
setopt noclobber # stop overwrite redirect
setopt nonomatch
setopt correct

# autoload predict-on
# predict-on
# zle-line-init() { predict-on }
# zle -N zle-line-init

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-chars unspecified

export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

[[ $TERM = "eterm-color" ]] && TERM=xterm-color

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache true
# zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' ignore-parents parent pwd ..
# http://gihyo.jp/dev/serial/01/zsh-book/0005
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' menu select

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export LESS='-R --LONG-PROMPT'
export TERM=xterm-256color

export EDITOR=vim

bindkey "" backward-delete-char

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
setopt histignorealldups
setopt noincappendhistory
setopt nosharehistory

REPORTTIME=3

for xenv in rbenv nodenv; do
  export PATH="${HOME}/.${xenv}/bin:${PATH}"
  export PATH="${HOME}/.${xenv}/shims:${PATH}"
done

# settings for Go
export GOPATH=$HOME
export PATH=$GOPATH/bin:$PATH

if which direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if which peco >/dev/null 2>&1; then
  [ -f "${ZDOTDIR}/peco.zshrc" ] && source "${ZDOTDIR}/peco.zshrc"
fi

for rctype in "alias" "function" "prompt" "local" "$(uname)"; do
  [ -f "${ZDOTDIR}/${rctype}.zshrc" ] && source "${ZDOTDIR}/${rctype}.zshrc"
done

function tmux-show-command() {
  if [ -n "$TMUX" ]; then
    cmd="$(echo "${1}" | cut -d' ' -f1)"
    tmux rename-window "$cmd:$PWD:t"
  fi
}

add-zsh-hook preexec tmux-show-command

function tmux-show-pwd() {
  if [ -n "$TMUX" ]; then
    tmux rename-window "zsh:$PWD:t"
  fi
}

add-zsh-hook precmd tmux-show-pwd

# configure completion again after all other files are loaded
zplug load

# disable completion
compdef -d npm
compdef -d scp
compdef -d gem
compdef -d thor
compdef -d knife
compdef -d kitchen
compdef -d gradle
compdef -d docker
compdef -d mvn
compdef -d mysql

if [ -f /usr/local/bin/terraform ]; then
  # terraform -install-autocomplete
  complete -C /usr/local/bin/terraform terraform
elif [ -f /usr/bin/terraform ]; then
  complete -C /usr/bin/terraform terraform
fi

# Enable zsh completion of kubectl
# http://kubernetes.io/docs/user-guide/kubectl/kubectl_completion/
if which kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if [[ -d "${HOME}/.local/bin" ]]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi
