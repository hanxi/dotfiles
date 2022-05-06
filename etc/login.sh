# auto start tmux
if command -v tmux &> /dev/null; then
    tmux a || tmux
fi

