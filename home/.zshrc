[ -e "${HOME}/dotfiles/bin" ] && export PATH=$HOME/dotfiles/bin:$PATH
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

# pass completion suggested by @d4ndo (#362)
# to trigger call: `pass  **<TAB>`
_fzf_complete_pass() {
_fzf_complete '+m' "$@" < <(
  local pwdir=${PASSWORD_STORE_DIR-~/.password-store/}
  local stringsize="${#pwdir}"
  find "$pwdir" -name "*.gpg" -print |
      cut -c "$((stringsize + 1))"-  |
      sed -e 's/\(.*\)\.gpg/\1/'
)
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# git/svn info in prompt
autoload -U compinit && compinit

local ret_status="%(?::[%?])"
# truncate paths longer than 50 characters and replace with "..."
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Conditional-Substrings-in-Prompts
local cwd="%50<...<%~%<<"
local userhost="%n@%m "
local timenow="%D{%H:%M:%S} "
local promptchar="$"
if [ "$color_prompt" = yes ]; then
    # logic cof return status. If zero, print nothing (stuff between first ::
    # if it's non-zero, print stuff between : and )
    local ret_status="%(?:: %F{red}[return:%?])%f"
    local cwd="%F{62}$cwd%f"
    local userhost="%F{242}$userhost%f"
    local timenow="%F{242}$timenow%f"
    local promptchar="%F{magenta}%(!.#.$promptchar)%f"
fi

PROMPT='$userhost$timenow$cwd $promptchar$ret_status '

# print time execution information for commands taking longer than this
export REPORTTIME=3

# plugins
[ -e "${HOME}/.zsh/zsh-histdb/history-timer.zsh" ] && source "${HOME}/.zsh/zsh-histdb/history-timer.zsh"
[ -e "${HOME}/.zsh/zsh-histdb/sqlite-history.zsh" ] && source "${HOME}/.zsh/zsh-histdb/sqlite-history.zsh"

[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

