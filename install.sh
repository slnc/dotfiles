#!/usr/bin/bash
#
# How to install:
# - apt-get install zsh tmux
# - curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh

set -uex
DOT_FILES_DIR=~/files/settings/dotfiles

if [ $(uname) = 'Linux' ]; then
  sudo apt-get install -qq -y zsh tmux
fi

mkdir -p ~/files
git clone https://github.com/slnc/dotfiles.git $DOT_FILES_DIR

targets=".gitconfig .gitignore .psqlrc .tmux.conf .vim .vimrc .zshrc"

# setopt shwordsplit
for f in $targets; do
  ln -s $DOT_FILES_DIR/$f ~
done
# unsetopt shwordsplit

vim +PlugInstall +qall  # This may leave the console broken for some reason.

curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

chsh -s /usr/bin/zs
