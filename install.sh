#!/bin/zsh
targets=".git .tmux.conf .vim .vimrc .zshrc"

setopt shwordsplit
for f in $targets; do
  if [[ -f ~/$f ]]; then
    mv ~/$f ~/$f.bak
  fi
  ln -s $(pwd)/$f ~
done
unsetopt shwordsplit

vim +PlugInstall +qall
