[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

source ~/.zplug/init.zsh

zplug "themes/robbyrussell", from:oh-my-zsh 
zplug "zsh-users/zsh-history-substring-search"
zplug "plugins/git",   from:oh-my-zsh

zplug load

# vi mode
bindkey -v
export KEYTIMEOUT=1
