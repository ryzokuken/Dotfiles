alias c chezmoi
alias login "~/.caa/caa --stop && ~/.caa/caa --daemon"
set -x GPG_TTY (tty)

# One editor to rule them all
set EDITOR nvim
alias vi="nvim"
alias vim="nvim"

thefuck --alias | source
