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
if [ "`uname`" = "Darwin" ]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias ll='ls -alF'
alias la='ls -G -A'
alias l='ls -G -CF'


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

# load fzf
##########
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# git/svn info in prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' max-exports 2
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "%F{red}*%f"
zstyle ':vcs_info:*' stagedstr "%F{green}+%f"
zstyle ':vcs_info:*' formats "%F{242}%s:%F{green}%b%f %m%u%c"
zstyle ':vcs_info:*' actionformats "%F{242}%s:%F{green}%b%f %F{yellow}(%a)%f %m%u%c"
precmd () { vcs_info }

if [ "$color_prompt" = yes ]; then
    # logic cof return status. If zero, print nothing (stuff between first ::
    # if it's non-zero, print stuff between : and )
    local ret_status="%(?:: %B%F{red}[%?])%b%f"
    local cwd="%F{cyan}%~%{$reset_color%}%f"
    local userhost="%F{242}:: %n@%m%f"
    local timenow="%F{242}:: %D{%F %H:%M:%S}%f"
    local promptchar="%F{magenta}%(!.#.❯)%f"
else
    # logic cof return status. If zero, print nothing (stuff between first ::
    # if it's non-zero, print stuff between : and )
    local ret_status="%(?::[%?])"
    local cwd="%~"
    local userhost="%n@%m"
    local timenow="%D{%F %H:%M:%S}"
    local promptchar="%(!.#.❯)"
fi

PROMPT='
 $cwd $userhost $timenow
${vcs_info_msg_0_} $promptchar$ret_status '

# print time execution information for commands taking longer than this
export REPORTTIME=3

