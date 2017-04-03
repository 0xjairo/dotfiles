[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

# try to use an ssh-agent that is already running
#################################################
# if this fails (returns 2), then find a socket in /tmp
ssh-add -l &>/dev/null
if [[ "$?" == 2 ]];  then
    # find sockets in /tmp that begin with "agent."
    agent_sockets=`find /tmp -type s -name agent.\* 2>/dev/null`
    # use the first one
    for sock in $agent_sockets; do
        export SSH_AUTH_SOCK=$sock
        break
    done
fi

export PATH=$HOME/.local/bin:$PATH

# zsh history
export SAVEHIST=50000
export HISTSIZE=$SAVEHIST
export HISTFILE=~/.zhistory
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt PROMPT_SUBST

export HISTORY_IGNORE="(ls|cd|cd ..)"

# aliases
#########
#alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls --color=auto -A'
alias l='ls --color=auto -CF'


# vi mode
#########
bindkey -v
export KEYTIMEOUT=1

# use ripgrep
#############
if type rg >/dev/null; then
    # use ripgrep to filter with fzf
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!build/*" --glob "!*.pyc"'
fi


# zplug initialization
######################
source ~/.zplug/init.zsh
zplug "zsh-users/zsh-history-substring-search"
zplug load

# load fzf
##########
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

ZSH_THEME_GIT_PROMPT_PREFIX="%F{242}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

if [ "$color_prompt" = yes ]; then
    # logic cof return status. If zero, print nothing (stuff between first ::
    # if it's non-zero, print stuff between : and )
    local ret_status="%(?::%{$fg_bold[red]%}[%?])%{$reset_color%}"
    local timenow="%F{236%}%D{%F %H:%M:%S}%f"
    local cwd="%{$fg[cyan]%}%~%{$reset_color%}"
    local promptchar="%{$fg[magenta]%}%(!.#.❯)%{$reset_color%}"
else
    # logic cof return status. If zero, print nothing (stuff between first ::
    # if it's non-zero, print stuff between : and )
    local ret_status="%(?::[%?])"
    local timenow="%D{%F %H:%M:%S}"
    local cwd="%~"
    local promptchar="%(!.#.❯)"
fi

# assemble prompt
PROMPT='
 $cwd $(git_prompt_info) $timenow
$ret_status $promptchar '

# print time execution information for commands taking longer than this
export REPORTTIME=3
