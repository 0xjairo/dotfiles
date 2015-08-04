# Add the following lines to your ~/.bashrc file:
# if [ -e $HOME/dotfiles/home/bash-goodies.sh ]; then
#     source $HOME/dotfiles/home/bash-goodies.sh
# fi

# enable 256 color
export TERM=xterm-256color

# enable dirty status from __git_ps1()
export GIT_PS1_SHOWDIRTYSTATE=1

# bash colors
if [ -e "$HOME/dotfiles/home/bash-colors.sh" ]; then
    source $HOME/dotfiles/home/bash-colors.sh
fi

# set prompt colors
#PS1="\[$txtblk\]\t \[$txtylw\]\u@\h \[$txtblu\]\w"

# Make it look like the default Ubuntu prompt
PS1='$([ \j -gt 0 ] && echo [\j])${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'

# check if __git_ps1 exists, if so, append git info
type -t __git_ps1 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
    # show current branch
    PS1="$PS1\[$txtcyn\]\$(__git_ps1)\[$txtrst\]"
fi


# finalize prompt
export PS1="$PS1\$ "

# trim "\w" in PS1 if the current working directory is > 3 levels
export PROMPT_DIRTRIM=3

# set bash to vi mode
set -o vi

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

VIMPAGER="vim -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'map q :q<CR>' -"
alias vless=$VIMPAGER
# use vi for man pages
export MANPAGER="/bin/sh -c \"col -b | ${VIMPAGER} \""

# enable global menu and rid of warning message as found in
# at http://askubuntu.com/a/132993/16365
function gvim () { (/usr/bin/gvim -f "$@" &) }

# source tmuxiantor if it exists
# install via: # gem install tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

if [ -e $HOME/dotfiles/home/qc/qc/qc.sh ]; then
    alias qc="$HOME/dotfiles/home/qc/qc/qc.sh"
fi

alias ipymath=ipython --profile=math
