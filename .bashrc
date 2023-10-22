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
PS1="\e[1;45m\W\e[0m\e[1;35m\$\e[0m "
. "$HOME/.cargo/env"
source /home/space/Documents/alacritty/extra/completions/alacritty.bash
