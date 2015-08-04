[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

source $HOME/antigen/antigen.zsh
antigen use oh-my-zsh

antigen bundle gitfast # better git completion (more bash like)
antigen bundle tmux
antigen bundle vi-mode
antigen bundle python
antigen bundle history
antigen bundle vundle
antigen bundle command-not-found
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle nojhan/liquidprompt

# tell antigen that you're done
antigen apply

## right prompt with time
eval gray='$FG[237]'
#RPROMPT='$gray%m:%*%{$reset_color%}%'

# Quick calculator
alias qc='~/dotfiles/home/qc/qc/qc.sh'
hex() { qc "hex($*)"; }

# cow calendar
alias cowcal="cal -h $(date +%G) | cowsay -n"

# shortcuts
alias tma='tmux attach -d -t'
alias lt='LightTable 2>/dev/null'
alias up='cd ..'

if type "xdg-open" > /dev/null; then
    alias open='xdg-open'
    #
    # suffix aliases to open files in default program
    alias -s pdf='xdg-open' # open pdf's with xdg-open
fi


# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
#DISABLE_UNTRACKED_FILES_DIRTY="true"

# allow parameter expansion/command substitution/arithmetic expansion
setopt PROMPT_SUBST

if type "gnome-keyring-daemon" > /dev/null; then
    # seahorse session manager
    export $(gnome-keyring-daemon --daemonize --start)
fi

export EDITOR='vim'
export TERM='xterm-256color'

# bind k and j to serach history a la vim
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# don't share history between terminals
setopt inc_append_history
unsetopt sharehistory

# don't provide autocorrection
unsetopt correct_all

# enable brace expansion a la bash
# for example: echo {a-c} returns
# echo a b c
setopt BRACE_CCL

# modified from https://coderwall.com/p/powgbg
# with this function, you will attach to existing tmux session,
# create new if one does not exist or just start bash
# if there is no tmux available.
# usage:
#
#     $ sshtx user@host
#
function sshtx() {
    ssh $* -tXC 'tmux a || tmux || /bin/bash'
}

if [[ -d $HOME/bin ]]; then
    export PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

VIMPAGER="vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'map q :q<CR>' -"
alias vless=$VIMPAGER
# use vi for man pages
export MANPAGER="/bin/sh -c \"col -b | ${VIMPAGER} \""

# alias to look for a process
alias psg="ps -ef | grep -v grep | grep"

# alias to launch ipython with math profile
alias ipymath="ipython --profile=math"

if [[ `uname` == 'Darwin' ]]; then
    vmrun-headless() {
        /Applications/VMware\ Fusion.App/Contents/Library/vmrun -T fusion start $1 nogui
    }
fi

if [[ -f $HOME/.zshrc_local ]]; then
    source $HOME/.zshrc_local
fi

# NVIM true color if not in tmux
if [[ -z "$TMUX" ]]; then
    export NVIM_TUI_ENABLE_TRUE_COLOR=1
else
    unset NVIM_TUI_ENABLE_TRUE_COLOR
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
