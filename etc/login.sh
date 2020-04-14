# auto start tmux
if [ -n "$TMUX"  ]; then
    tmux a || tmux
fi

