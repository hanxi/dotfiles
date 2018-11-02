case $- in
    *i*) ;;
    *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

EDITOR=vimdiff
export EDITOR

PATH=$PATH:$HOME/bin
PATH=/usr/local/bin:$PATH
export PATH

#PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/local/lib/pkgconfig
#export PKG_CONFIG_PATH

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/local/lib
export LD_LIBRARY_PATH

#export http_proxy=http://192.168.16.12:1080/
export http_proxy=
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy

export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/local/nvim/bin:$PATH"
export PATH="$HOME/software:$PATH"
export PATH="$HOME/neovim/bin:$PATH"
export PATH="$HOME/software/node/bin:$PATH"
export PATH="$HOME/software/python3/bin:$PATH"
export LIBRARY_PATH="$HOME/software/python3/lib:$HOME/local/lib"
export LD_LIBRARY_PATH=$LIBRARY_PATH
export LD_RUN_PATH=$LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH
alias vim=nvim
#[[ -s "/home/hlm0842/.gvm/scripts/gvm" ]] && source "/home/hlm0842/.gvm/scripts/gvm"

export TERM=xterm-256color
export TERM_ITALICS=true

# tmux
[ -z "$TMUX"  ] && { tmux attach || exec tmux new && exit;}

# promptline
. $HOME/.shell_prompt.sh
. $HOME/.git-completion.bash
