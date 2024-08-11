#!/bin/sh
set -uex

DST_DIR=~/files/projects/.dotfiles
mkdir -p "${DST_DIR}"
git clone https://github.com/slnc/dotfiles.git "${DST_DIR}"
ln -s "${DST_DIR}" ~/.dotfiles

if command -v apt > /dev/null 2>&1; then
  sudo apt-get install -q -yy git ripgrep tmux zsh 
  curl https://pyenv.run | bash
elif command -v brew > /dev/null 2>&1; then
  brew install fzf git pyenv ripgrep tmux
else
  echo "Unsupported OS"
fi

for f in .tmux.conf .zshenv; do
  ln -s "${DST_DIR}/${f}" ~/
done

mkdir -p ~/.config
ln -s "${DST_DIR}/nvim" ~/.config/

sudo chsh -s /bin/zsh

echo "Remember to run install_neovim.sh"
