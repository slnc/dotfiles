#!/bin/sh
set -uex

DOTFILES_DIR=~/.dotfiles
PROJECTS_DIR=~/files/projects
mkdir -p ${PROJECTS_DIR}
git clone https://github.com/slnc/dotfiles.git "${PROJECTS_DIR}/${DOTFILES_DIR}"
ln -s "${PROJECTS_DIR}/${DOTFILES_DIR}" "${DOTFILES_DIR}"

if command -v apt > /dev/null 2>&1; then
  sudo apt git install ripgrep tmux zsh 
  curl https://pyenv.run | bash
elif command -v brew > /dev/null 2>&1; then
  brew install fzf git pyenv ripgrep tmux
else
  echo "Unsupported OS"
fi

for f in .zshenv .tmux.conf; do
  ln -s "${DOTFILES_DIR}/${f}" ~/
done

mkdir -p ~/.config
ln -s ~/.dotfiles/nvim ~/.config/

sudo chsh -s /bin/zsh
echo "Remember to run install_neovim.sh"
