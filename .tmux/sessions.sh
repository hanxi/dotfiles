#!/bin/bash
export TERM=screen-256color
if $(tmux has-session 2>/dev/null); then tmux att; exit; fi
tmux new-session -d -n bash -s 0 -c /home/hlm0842/dotfiles
tmux select-layout -t 0:0 "6232,145x36,0,0,32" > /dev/null
tmux new-window -d -n bash -t 0:1 -c /home/hlm0842
tmux select-layout -t 0:1 "6233,145x36,0,0,33" > /dev/null
tmux new-window -d -n bash -t 0:2 -c /home/hlm0842
tmux select-layout -t 0:2 "6234,145x36,0,0,34" > /dev/null
tmux att
