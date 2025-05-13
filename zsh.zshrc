export EDITOR=vim
export BROWSER=google-chrome-stable
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="kolo"
ZSH_THEME="theunraveler"
ZSH_THEME="gallois"
ZSH_THEME="sorin"
ZSH_THEME="muse"

plugins=(git)

source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle :compinstall filename "/$HOME/.zshrc"

autoload -Uz compinit
compinit

unsetopt share_history

eval "$(direnv hook zsh)"
