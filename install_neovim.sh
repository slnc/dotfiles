
sudo apt update && sudo apt install -y zsh vim ripgrep tmux cmake gettext dh-cmake fzf
# Use nightly to help detect bugs soon.
git clone https://github.com/neovim/neovim && \
  cd neovim && \ 
  make CMAKE_BUILD_TYPE=RelWithDebInfo && \
  cd build && \
  cpack -G DEB && \
  sudo dpkg -i nvim-linux64.deb
