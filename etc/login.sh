# auto start tmux
if command -v tmux > /dev/null 2>&1; then
    tmux a || tmux
fi

