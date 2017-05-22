#!/bin/bash
export TERM=xterm-256color
if $(tmux has-session 2>/dev/null); then tmux att; exit; fi
tmux new-session -d -n bash -s 0
tmux att
