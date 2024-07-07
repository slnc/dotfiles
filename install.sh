#!/bin/sh
# - curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh
set -uex

DOTFILES_DIR=~/.dotfiles
git clone https://github.com/slnc/dotfiles.git "${DOTFILES_DIR}"

if command -v apt-get > /dev/null 2>&1; then
  curl https://pyenv.run | bash
  apt-get update && apt-get install -y zsh vim silversearcher-ag
elif command -v brew > /dev/null 2>&1; then
  brew install pyenv vim
else
  echo "Unable to determine the package manager. Install pyenv manually."
fi

for f in ".vimrc .zshenv"; do
  ln -s "${DOTFILES_DIR}/${f}" ~
done

vim +PlugInstall +qall
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
chsh -s /bin/zsh