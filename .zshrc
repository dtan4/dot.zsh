fpath=("$HOME/zsh-completions/src" $fpath)

autoload -Uz compinit
compinit

autoload colors
colors

export LANG=ja_JP.UTF-8
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# http://qiita.com/mollifier/items/8d5a627d773758dd8078
function rprompt-git-not-pushed() {
    local count
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    count=`git rev-list origin/master..master 2>/dev/null | wc -l | tr -d ' '`
    if [[ $count -ne 0 ]]; then
        echo "[%{${fg_bold[red]}%}${count}%{$reset_color%}]"
    fi
    return 0
}

function rprompt-git-stash() {
    local count
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    count=`git stash list 2>/dev/null | wc -l | tr -d ' '`
    if [[ $count -ne 0 ]]; then
        echo "[%{${fg_bold[yellow]}%}${count}%{$reset_color%}]"
    fi
    return 0
}

function rprompt-git-current-branch {
    local name st color

    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=$(git symbolic-ref --short HEAD 2> /dev/null)
    if [[ -z $name ]]; then
        return
    fi
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
        color=${fg_bold[red]}
    else
        color=${fg[red]}
    fi

    echo "[%{$color%}$name%{$reset_color%}]"
}

setopt prompt_subst
PROMPT="%{${fg[magenta]}%}%n@%m ${fg[yellow]}%}%(5~,%-2~/.../%2~,%~)%{${reset_color}%} [%D{%Y-%m-%d %T}] [%h]
% "
precmd(){
    PROMPT="%{${fg[magenta]}%}%n@%m ${fg[yellow]}%}%(5~,%-2~/.../%2~,%~)%{${reset_color}%} [%D{%Y-%m-%d %T}] [%h]
%{%(?.${reset_color}.${fg[red]})%}%#%{${reset_color}%} "
}
PROMPT2='[%n]> '
RPROMPT='`rprompt-git-not-pushed``rprompt-git-stash``rprompt-git-current-branch`'

case "${TERM}" in
    kterm*|xterm)
	precmd(){
	    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
	}
	;;
    dumb | emacs)
	PROMPT="%m:%~> "
	unsetopt zle
	;;
esac

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

alias javac="javac -J-Dfile.encoding=UTF8"
# alias java="java -J-Dfile.encoding=UTF8"

export LESS='-R'
export TERM=xterm-256color

bindkey "" backward-delete-char

# reload .zshrc
# alias sourcez='source ~/.zshrc'
alias reload='exec zsh -l'

# extend cd
alias cddown='cd ~/Downloads'
alias cdtmp='cd ~/tmp'
alias cddrop='cd ~/Dropbox'
alias cdarc='cd ~/Dropbox/Archives'
alias cdmemo='cd ~/Dropbox/memo'

### cd to the top level of git project ###
function cdtop() {
    if git rev-parse --is-inside-work-tree > /dev/null 2&>1; then
        cd `git rev-parse --show-toplevel`
    fi
}

### completion of ~/git ###
function cdgit {
    cd ~/git/$1
}

function _g {
    _files -W ~/git/ && return 0;
    return 1;
}

compdef _g cdgit
### ###

# extend existed command
alias curl='noglob curl'
alias gp='grep -n --color=auto'
alias gcc='gcc -Werror -Wall'
alias be='bundle exec'
alias bi='bundle install'
alias bg='bundle gem'

function frep {
    find . -type f -name $1 | xargs grep $2
}

function pdfgrep {
    find . -name '*.pdf.txt' | xargs grep -i $1 2> /dev/null | sed -e 's/\.pdf\.txt/\.pdf/g'
}

if [[ -x `which colordiff` ]]; then
    alias diff='colordiff -u'
else
    alias diff='diff -u'
fi

function server() {
    ruby -rwebrick -e 'WEBrick::HTTPServer.new({:DocumentRoot => "./", :Port => 8080}).start'
}

REPORTTIME=3

export PATH=$PATH:$HOME/local
export PATH=~/.cabal/bin:$PATH

if [[ -d $HOME/.plenv ]]; then
    export PATH=~/.plenv/bin:$PATH
    export PATH=~/.plenv/shims:$PATH
    eval "$(plenv init -)"
fi

if [[ -d $HOME/.pyenv ]]; then
    export PATH=~/.pyenv/bin:$PATH
    export PATH=~/.pyenv/shims:$PATH
    eval "$(pyenv init -)"
fi

if [[ -d $HOME/.rbenv ]]; then
    export PATH=~/.rbenv/bin:$PATH
    export PATH=~/.rbenv/shims:$PATH
    eval "$(rbenv init -)"
fi

if [[ -d $HOME/.ndenv ]]; then
    export PATH=~/.ndenv/bin:$PATH
    export PATH=~/.ndenv/shims:$PATH
    eval "$(ndenv init -)"
fi

export PATH=$HOME/.nodebrew/current/bin:$PATH

# disable completion
compdef -d rake
compdef -d npm
compdef -d scp
compdef -d gem
compdef -d thor

[ -f ~/.zshrc.`uname` ] && source ~/.zshrc.`uname`
