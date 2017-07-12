case $- in
    *i*) ;;
    *) return;;
esac

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

EDITOR=vimdiff
export EDITOR

PATH=$PATH:$HOME/bin
#PATH=$PATH:$HOME/local/bin
export PATH

#PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/local/lib/pkgconfig
#export PKG_CONFIG_PATH

#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/local/lib
#export LD_LIBRARY_PATH

# promptline
. $HOME/.shell_prompt.sh
. $HOME/.git-completion.bash

export TERM=screen-256color

# tmux
S_FILE="$HOME/.tmux/sessions.sh"
if command -v tmux>/dev/null; then
    [[ $- != *i* ]] && return
    if [[ -z $TMUX && `wc $S_FILE | cut -b 1` != '0' ]]; then
        alias tmux=$S_FILE
        exec "$S_FILE"
    fi
fi

