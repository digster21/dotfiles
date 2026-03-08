alias glot='git log --oneline --decorate -20'
alias glof='git log --oneline --decorate -5'
alias glogt='git log --oneline --decorate --graph -20'
alias glogf='git log --oneline --decorate --graph -5'

alias nrfusearch='nrfutil sdk-manager search'
alias nrfulist='nrfutil sdk-manager list'
alias nrfuinstall='nrfutil sdk-manager install'
alias nrfuuninstall='nrfutil sdk-manager uninstall'
alias nrfushell='_nrf_shell() { nrfutil sdk-manager toolchain launch --ncs-version "$1" --shell; }; _nrf_shell'

alias ccb='xclip -selection clipbaord'

alias daily="zk new --template todo.md --title 'Daily Tasks'"
alias ntodo="zk new --template todo.md --title"
alias nmeeting="zk new --template meeting.md --title"
