#!/bin/sh
set -uex


if command -v apt > /dev/null 2>&1; then
  sudo apt-get install -q -yy git ripgrep tmux zsh polybar rofi dunst
  curl https://pyenv.run | bash
elif command -v brew > /dev/null 2>&1; then
  brew install fzf git pyenv ripgrep tmux
else
  echo "Unsupported OS"
fi

DST_DIR=~/files/projects/.dotfiles
mkdir -p "${DST_DIR}"
git clone https://github.com/slnc/dotfiles.git "${DST_DIR}"
ln -s "${DST_DIR}" ~/.dotfiles

for f in .tmux.conf .zshenv; do
  ln -s "${DST_DIR}/${f}" ~/
done

mkdir -p ~/.config
ln -s "${DST_DIR}/nvim" ~/.config/
ln -s "${DST_DIR}/.pylintrc" ~/.config/


sudo chsh -s /bin/zsh

# TODO: replace w/ XDG var?
mkdir -p ~/.local/bin
export bin_path=~/.local/bin
curl -sfL https://direnv.net/install.sh | bash

echo "Remember to run install_neovim.sh"
echo "Remember to ln -s ~/.config/alacritty/hosts/`hostname`.toml ~/.config/alacritty/hosts/current.toml"
echo "Remember to ln -s ~/.config/polybar/`hostname`.ini ~/.config/alacritty/config.ini"

# TODO: cleanup this, optimize for "does it all by default", but separate into
# linux_driver, linux_srv, mac
ln -s ~/.dotfiles/polybar ~/.config
ln -s ~/.dotfiles/.pylintrc ~/.config/pylintrc
ln -s ~/.dotfiles/pycodestyle ~/.config
ln -s ~/.dotfiles/nvim ~/.config
ln -s ~/.dotfiles/picom ~/.config
ln -s ~/.dotfiles/flake8 ~/.config
ln -s ~/.dotfiles/rofi ~/.config
cd ~/.dotfiles/rofi && ln -s `hostname`.rasi config.rasi && cd -


mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux

echo "Add the following line to your tmux.conf file: run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux."
