setopt CORRECT
setopt LIST_PACKED
setopt GLOBDOTS
setopt interactivecomments
unsetopt AUTO_MENU
unsetopt LIST_BEEP

if [[ `uname` != "Darwin" ]]; then
  if (( $+SHELL )); then
    eval `dircolors ${DOTFILES_DIR}/dircolors.256dark`
  fi
fi
