#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
files ()
{
	nohup nautilus --browser $1 &>/dev/null
}
PS1="\[\033[1;45m\]\W\[\033[0m\]\[\033[1;35m\]\$\[\033[0m\] "
. "$HOME/.cargo/env"
source /home/space/Documents/alacritty/extra/completions/alacritty.bash
