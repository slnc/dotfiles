#!/usr/bin/bash
#
# How to install:
# curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh

set -uex
DOT_FILES_DIR=~/files/settings/dotfiles

mkdir ~/files
git clone https://github.com/slnc/dotfiles.git $DOT_FILES_DIR

targets=".gitconfig .gitignore .tmux.conf .vim .vimrc .zshrc"

# setopt shwordsplit
for f in $targets; do
  ln -s $DOT_FILES_DIR/$f ~
done
# unsetopt shwordsplit

vim +PlugInstall +qall
