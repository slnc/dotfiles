#!/usr/bin/env zsh
#
# - curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh
set -uex

DOTFILES_DIR=~/.dotfiles
git clone https://github.com/slnc/dotfiles.git ${DOTFILES_DIR}

if command -v apt-get &> /dev/null; then
  curl https://pyenv.run | bash
  apt-get update && apt-get install -y silversearcher-ag
elif command -v brew &> /dev/null; then
  brew install pyenv
else
  echo "Unable to determine the package manager. Please install pyenv manually."
fi

targets=(
  .vimrc
  .zshenv
)

for f in "${targets[@]}"; do
  ln -s "${DOTFILES_DIR}/${f}" ~
done

vim +PlugInstall +qall

curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
chsh -s /bin/zsh
