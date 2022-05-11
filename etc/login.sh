# auto start tmux
if [ -z "$TMUX" ]; then
    if command -v tmux > /dev/null 2>&1; then
        tmux a || tmux
    fi
fi

