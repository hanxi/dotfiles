# shell prompt
# from vim ":PromptlineSnapshot ~/.local/etc/shell_prompt.sh airline"
if [ -f "$HOME/.local/etc/shell_prompt.sh" ]; then
    . $HOME/.local/etc/shell_prompt.sh
fi

# enable bash completion
# yum install bash-completion
[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion ]] && \
    . /usr/local/share/bash-completion/bash_completion

# git completion
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.local/etc/git-completion.bash
if [ -f "$HOME/.local/etc/git-completion.bash" ]; then
    . $HOME/.local/etc/git-completion.bash
fi


# for .local lib
export LD_RUN_PATH=$HOME/.local/lib::$LD_RUN_PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

# for tmux
export TERM=screen-256color
export TERM_ITALICS=true

# for http proxy
#export http_proxy=http://192.168.29.221:5719/
export http_proxy=
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy

# alias
alias vim=nvim
alias svn=svn-color.py

export HISTTIMEFORMAT="%d/%m/%y %T "

# Alias for tree view of commit history.
git config --global alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"
