[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

export PATH=$HOME/.local/bin:$PATH

# zsh history
export SAVEHIST=5000
export HISTFILE=~/.zhistory
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS

# aliases
#########
#alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls --color=auto -A'
alias l='ls --color=auto -CF'


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
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!build/*"'
fi


# zplug initialization
######################
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-history-substring-search"
zplug load



setopt PROMPT_SUBST
ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# logic cof return status. If zero, print nothing (stuff between first ::
# if it's non-zero, print stuff between : and )
local ret_status="%(?:: %{$fg_bold[red]%}[%?])%{$reset_color%}"

# assemble prompt
PROMPT='%{$fg[cyan]%}[%n@%m]%{$reset_color%} %{$fg[blue]%}[%D %*]%{$reset_color%} $(git_prompt_info) 
%{$fg[magenta]%}%~${ret_status}%{$reset_color%} %# '

