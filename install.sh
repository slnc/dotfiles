#!/bin/sh
# - curl -L https://raw.githubusercontent.com/slnc/dotfiles/master/install.sh | sh
set -uex

DOTFILES_DIR=~/.dotfiles
PROJECTS_DIR=~/files/projects
mkdir -p ${PROJECTS_DIR}
git clone https://github.com/slnc/dotfiles.git "${PROJECTS_DIR}/${DOTFILES_DIR}"
ln -s "${PROJECTS_DIR}/${DOTFILES_DIR}" "${DOTFILES_DIR}"

if command -v apt-get > /dev/null 2>&1; then
  curl https://pyenv.run | bash
  sudo apt-get update && sudo apt-get install -y zsh vim ripgrep tmux cmake gettext dh-cmake fzf
  echo "install neovim from source"
  echo "git clone https://github.com/neovim/neovim"
  echo "cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo"
  echo "(ubuntu/debian) cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb"
elif command -v brew > /dev/null 2>&1; then
  brew install pyenv vim neovim tmux ripgrep fzf
else
  echo "Unable to determine the package manager. Install pyenv manually."
fi

for f in .zshenv .tmux.conf; do
  ln -s "${DOTFILES_DIR}/${f}" ~
done

ln -s ~/.dotfiles/nvim ~/.config/

# vim +PlugInstall +qall
# curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
sudo chsh -s /bin/zsh
