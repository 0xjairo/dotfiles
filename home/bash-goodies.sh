# Add the following lines to your ~/.bashrc file:
# if [ -e $HOME/dotfiles/home/bash-goodies.sh ]; then
#     source $HOME/dotfiles/home/bash-goodies.sh
# fi

# enable 256 color
export TERM=xterm-256color

# bash colors
if [ -e "$HOME/dotfiles/home/bash-colors.sh" ]; then
    source $HOME/dotfiles/home/bash-colors.sh
fi

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

if [ -e $HOME/dotfiles/home/qc/qc/qc.sh ]; then
    alias qc="$HOME/dotfiles/home/qc/qc/qc.sh"
fi

alias ipymath=ipython --profile=math

export XDG_CONFIG_HOME=$HOME/.config

alias dispssh="export DISPLAY=localhost:10.0"
alias displocal="export DISPLAY=:0.0"

export EDITOR="vim"
