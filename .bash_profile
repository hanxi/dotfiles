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

export TERM=xterm-256color

# tmux
alias tmux="$HOME/.tmux/sessions.sh"
#if command -v tmux>/dev/null; then
#    [[ $- != *i* ]] && return
#    if [ -z $TMUX ]; then
#        exec "$HOME/.tmux/sessions.sh"
#    fi
#fi

