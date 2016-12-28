export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

#export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
zplug "tmuxinator/tmuxinator", use:"completion/tmuxinator.zsh", defer:3
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:3 # Should be loaded 2nd last.
