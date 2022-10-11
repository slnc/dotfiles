#!/usr/bin/zsh
#
# How to install:
# curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh


DOT_FILES_DIR=~/files/settings/dotfiles

mkdir ~/files
git clone https://github.com/slnc/dotfiles.git $DOT_FILES_DIR

targets=".gitconfig .gitignore .tmux.conf .vim .vimrc .zshrc"

setopt shwordsplit
for f in $targets; do
  if [[ -f ~/$f ]]; then
    mv ~/$f ~/$f.bak
  fi
  ln -s $DOT_FILES_DIR/$f ~
done
unsetopt shwordsplit

vim +PlugInstall +qall
