set -gx GPG_TTY (tty)
set -gx EDITOR nvim
set -gx TERMINAL alacritty

alias c chezmoi
alias vi nvim
alias vim nvim
alias ls lsd
alias cat "bat --style=plain"

thefuck --alias | source

function prs
  curl --data-binary @$argv https://paste.rs/
end

function fish_title
  set title (status current-command)
  if [ "$title" = "fish" ]
    echo (pwd)
  else
    echo $argv
  end
end
