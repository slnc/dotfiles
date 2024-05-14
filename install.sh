#!/usr/bin/bash
#
# How to install:
# - apt-get install zsh tmux
# - curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh

set -uex

if [ -d "$(dirname "$(realpath "$0")")/.git" ]; then
  # devcontainer
  DOTFILES_DIR=$(dirname "$(realpath "$0")")
else
  DOTFILES_DIR=~/files/settings/dotfiles
  mkdir -p ~/files
  git clone https://github.com/slnc/dotfiles.git $DOTFILES_DIR
fi

if [ $(uname) = 'Linux' ]; then
  # sudo apt-get install -qq -y zsh tmux
  curl https://pyenv.run | bash
else
  brew install pyenv
fi

targets=".gitconfig .gitignore .psqlrc .tmux.conf .vim .vimrc .zshenv"

# setopt shwordsplit
for f in $targets; do
  ln -s $DOTFILES_DIR/$f ~
done
# unsetopt shwordsplit

vim +PlugInstall +qall  # This may leave the console broken for some reason.

curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

chsh -s /usr/bin/zs
