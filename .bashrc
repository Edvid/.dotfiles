#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- == *i* ]] && source ~/blesh/ble.sh --noattach
[[ -s /home/space/.autojump/etc/profile.d/autojump.sh ]] && source /home/space/.autojump/etc/profile.d/autojump.sh
alias v='nvim'

alias ls='ls --color=auto'
alias ll='ls -Ahlt --color=auto'
llh () {
  ls -Ahlt --color=always | head -n$(
  if [[ $# -eq 1 ]]; then
    echo $(($1 + 1))
  else
    echo $((21))
  fi
  )
}
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias privateggv='git graphverbose-default --color=always'

alias weather='
curl -s "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=55.65&lon=12.3" | \
jq ".properties.timeseries[0] |
{
  time: .time,
  temperature: .data.instant.details.air_temperature,
  rain_status: .data.next_1_hours.summary.symbol_code,
  humidity: .data.instant.details.relative_humidity,
  wind_speed: .data.instant.details.wind_speed
}"'

HISTSIZE=20000
HISTFILESIZE=20000

privategg () {
  git graph-default --color=always $1 $2 $3 $4 | head -n20
}

alias gg='privategg --all'
alias gghere='privategg main HEAD'
alias ggbr='privategg main..HEAD'
alias ggv='privateggv --all'
alias ggvhere='privateggv main HEAD'
alias ggvbr='privateggv main..HEAD'

timer ()
{
  xdg-open https://edvid.github.io/timer/?t=$1 >> /dev/null 2>&1
}
files ()
{
  nohup nautilus --browser $1 >> /dev/null 2>&1 &
}
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"
PATH="$HOME/.shell-ipa/scripts:$PATH"
. "$HOME/.cargo/env"
source /home/space/Documents/alacritty/extra/completions/alacritty.bash
eval "$(starship init bash)"

[[ ${BLE_VERSION-} ]] && ble-attach

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
