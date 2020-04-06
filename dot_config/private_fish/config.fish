set -gx GPG_TTY (tty)
set -gx EDITOR nvim

alias c chezmoi
alias vi nvim
alias vim nvim
alias ls lsd
alias cat bat

thefuck --alias | source

function prs
  curl --data-binary @$argv https://paste.rs/
end
