#!/usr/bin/env zsh
#
# - curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh
set -uex

DOTFILES_DIR=~/.dotfiles
git clone https://github.com/slnc/dotfiles.git ${DOTFILES_DIR}

if [[ $(uname) = 'Linux' ]]; then
  curl https://pyenv.run | bash
  sudo apt install silversearcher-ag
else
  brew install pyenv
fi

targets=(
  .gitconfig
  .gitignore
  .psqlrc
  .tmux.conf
  .vim
  .vimrc
  .zshenv
)

for f in "${targets[@]}"; do
  ln -s "${DOTFILES_DIR}/${f}" ~
done

vim +PlugInstall +qall

curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
chsh -s /bin/zsh
