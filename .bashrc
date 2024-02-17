#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- == *i* ]] && source ~/blesh/ble.sh --noattach
[[ -s /home/space/.autojump/etc/profile.d/autojump.sh ]] && source /home/space/.autojump/etc/profile.d/autojump.sh
alias v='nvim'

alias ls='ls --color=auto'
alias ll='ls -Ahlt --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias gg='git graph --color=always | head -n20'
timer() 
{
  xdg-open https://edvid.github.io/timer/?t=$1 >> /dev/null 2>&1
}
files ()
{
  nohup nautilus --browser $1 >> /dev/null 2>&1 &
}
. "$HOME/.cargo/env"
source /home/space/Documents/alacritty/extra/completions/alacritty.bash
eval "$(starship init bash)"

[[ ${BLE_VERSION-} ]] && ble-attach

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
