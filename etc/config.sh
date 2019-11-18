# shell prompt
# from vim ":PromptlineSnapshot ~/.local/etc/shell_prompt.sh airline"
if [ -f "$HOME/.local/etc/shell_prompt.sh" ]; then
    . $HOME/.local/etc/shell_prompt.sh
fi

# enable bash completion
# yum install bash-completion
[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion ]] && \
    . /usr/local/share/bash-completion/bash_completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# git completion
if [ -f /etc/bash_completion.d/git ]; then
    . /etc/bash_completion.d/git
fi


# for .local lib
export LD_RUN_PATH=$HOME/.local/lib::$LD_RUN_PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

# for tmux
export TERM=xterm-256color
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

# set pwd for tmux
function set_tmux_pwd() {
    $([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")
}
function my_cd() {
    \cd $1
    set_tmux_pwd
}
set_tmux_pwd
alias cd=my_cd

