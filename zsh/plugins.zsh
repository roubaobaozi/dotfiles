#export ZPLUG_HOME=/usr/local/opt/zplug
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

#export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "tysonwolker/zsh-tab-colors"
zplug "lukechilds/zsh-nvm"
