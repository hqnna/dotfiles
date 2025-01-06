#!/bin/zsh

source "$HOME/.config/zsh/environment"
source "$XDG_CONFIG_HOME/zsh/completion"
source "$XDG_CONFIG_HOME/zsh/antidote"
eval   "$(starship init zsh)"
eval   "$(mise activate zsh)"
