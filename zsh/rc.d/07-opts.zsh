setopt CORRECT
setopt LIST_PACKED
setopt GLOBDOTS
setopt interactivecomments
unsetopt AUTO_MENU
unsetopt LIST_BEEP

if [[ `uname` != "Darwin" ]]; then
  if (( $+SHELL )); then
    eval `dircolors $(dirname "$(realpath "$0")")/../../dircolors.256dark`
  fi
fi