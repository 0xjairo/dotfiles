[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

export PATH=$HOME/.local/bin:$PATH

# zsh history
export SAVEHIST=5000
export HISTFILE=~/.zhistory
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS

# aliases
#########
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# load fzf
##########
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vi mode
#########
bindkey -v
export KEYTIMEOUT=1

# use ripgrep
#############
if type rg >/dev/null; then
    # use ripgrep to filter with fzf
    export FZF_DEFAULT_COMMAND='rg --files'
fi


# zplug initialization
######################
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-history-substring-search"
zplug load



setopt PROMPT_SUBST
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%} %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"
PROMPT='${ret_status} %{$fg[cyan]%}%~%{$reset_color%}$(git_prompt_info) '
RPROMPT="%*"
