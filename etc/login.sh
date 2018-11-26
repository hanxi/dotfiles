# auto start tmux
if [ -z "$TMUX"  ]; then
    tmux a || tmux
fi

