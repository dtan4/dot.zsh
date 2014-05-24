fpath=("$ZDOTDIR/zsh-completions/src" $fpath)

[[ -d $(brew --prefix)/share/zsh/site-functions ]] && fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

source $ZDOTDIR/z/z.sh
source $ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -Uz compinit
compinit

autoload colors
colors

export LANG=ja_JP.UTF-8
export PATH=/usr/local/bin:/usr/local/sbin:/sbin:$PATH

# http://d.hatena.ne.jp/naoya/20130108/1357630895
function precmd () {
   z --add "$(pwd -P)"
}

HISTFILE=${HOME}/.zsh_hisrory
HISTSIZE=10000000
SAVELIST=10000000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt extended_history
setopt share_history

bindkey -e

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^[[Z" reverse-menu-complete  # reverse completion menu by Shift-Tab

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

setopt auto_cd
setopt auto_pushd
setopt list_packed
setopt nolistbeep
setopt noautoremoveslash
setopt nonomatch
setopt correct

autoload predict-on
# predict-on
zle-line-init() { predict-on }
zle -N zle-line-init

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
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' ignore-parents parent pwd ..
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

bindkey "" backward-delete-char

REPORTTIME=3

if [[ -d $HOME/.anyenv ]]; then
    export PATH=~/.anyenv/bin:$PATH
    export PATH=~/.anyenv/shims:$PATH
    eval "$(anyenv init - zsh)"

    # http://qiita.com/luckypool/items/f1e756e9d3e9786ad9ea
    for D in `ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done
fi

if which direnv > /dev/null 2>&1 ; then
    eval "$(direnv hook zsh)"
fi

# completion alias
compdef mosh=ssh

# disable completion
compdef -d rake
compdef -d npm
compdef -d scp
compdef -d gem
compdef -d thor
compdef -d knife

[ -f $ZDOTDIR/.zshrc.prompt ] && source $ZDOTDIR/.zshrc.prompt
[ -f $ZDOTDIR/.zshrc.alias ] && source $ZDOTDIR/.zshrc.alias
[ -f $ZDOTDIR/.zshrc.`uname` ] && source $ZDOTDIR/.zshrc.`uname`
