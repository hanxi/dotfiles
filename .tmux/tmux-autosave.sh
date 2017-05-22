#!/bin/bash

# __ __|                              ___|                    _)
#    |  __ `__ \   |   | \ \  /     \___ \    _ \   __|   __|  |   _ \   __ \    __|
#    |  |   |   |  |   |  `  <            |   __/ \__ \ \__ \  |  (   |  |   | \__ \
#   _| _|  _|  _| \__,_|  _/\_\     _____/  \___| ____/ ____/ _| \___/  _|  _| ____/
#
####################################################################################
# save the windows, panes and layouts
# of all running tmux sessions to a bash script

CURRENT_DIR=$(cd $(dirname $0); pwd)
save_command_interpolation="#($CURRENT_DIR/tmux-save-session.sh)"

get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

set_tmux_option() {
    local option="$1"
    local value="$2"
    tmux set-option -gq "$option" "$value"
}

add_resurrect_save_interpolation() {
	local status_right_value="$(get_tmux_option "status-right" "")"
	# check interpolation not already added
	if ! [[ "$status_right_value" == *"$save_command_interpolation"* ]]; then
		local new_value="${save_command_interpolation}${status_right_value}"
		set_tmux_option "status-right" "$new_value"
	fi
}

add_resurrect_save_interpolation
