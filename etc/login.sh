# auto start tmux
[ -z "$TMUX"  ] && { tmux attach || exec tmux new && exit;}

