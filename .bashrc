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
. "$HOME/.cargo/env"
source /home/space/Documents/alacritty/extra/completions/alacritty.bash
eval "$(starship init bash)"
