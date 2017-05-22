case $- in
    *i*) ;;
    *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
