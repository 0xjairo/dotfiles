if test -d $HOME/.local/bin
    set -x PATH $HOME/.local/bin $PATH $HOME/.pixi/bin
end

if test -d $HOME/.pixi/bin
    set -x PATH $PATH $HOME/.pixi/bin
end

if test -f ~/.config/fish/.fish_private
    source ~/.config/fish/.fish_private
end

if test -f ~/.cargo/env
    bass source ~/.cargo/env
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x STARSHIP_CONFIG "$HOME/dotfiles/home/.config/starship.toml"
    starship init fish | source
end

function re
    bass source ~/rover_env/bash/main.bash
end

#function source_catkin --on-variable PWD
#    status --is-command-substitution; and return
#    if test -e ".catkin_tools"
#        echo "Configured the folder as a workspace"
#        re
#        bass source devel/setup.bash end
#    end
#end

set fish_greeting ""


