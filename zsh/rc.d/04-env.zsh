export COLORTERM=truecolor
export EDITOR=nvim
export LESS="--no-init --quit-if-one-screen -R"  # for git branch on devcontainers
# Don't rely on this, too many things break (gitstatus, tmux)
# export GIT_CONFIG_GLOBAL=~/.dotfiles/.gitconfig
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# export TMUX_CONF=${DOTFILES_DIR}/.tmux.conf
export PSQLRC=~/.dotfiles/.psqlrc
export PYTHONSTARTUP=${DOTFILES_DIR}/.pythonrc
export ZSH_COMPDUMP=~/.cache/.zcompdump-$HOST

export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath

if type ag &> /dev/null; then
  export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

path=(
    /opt/homebrew/bin(N)
    ~/bin
    ~/bin/nvim/bin
    ~/.dotfiles/.local/bin
    /usr/local/lib/ruby/gems/3.3.0/bin(N)
    ~/.local/bin
    $path
)

fpath=(
  $ZDOTDIR/functions
  $fpath
  ~/.local/zsh/site-functions
)

autoload -U $fpath[1]/*(.:t)

# This version doesn't rehash on every keystroke. This removes the ~1s delay on mac.
# However, with this we now need to manually clear caches with aliases around pip/pip3
# and remember to call this command after installing new py versions.
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash zsh)"
[[ -f "$PYENV_ROOT/plugins/pyenv-virtualenv/bin/pyenv-virtualenv-init" ]] && \
    eval "$(pyenv virtualenv-init - --no-rehash zsh)"
[[ -f "$HOME/.rbenv/bin/rbenv" ]] && \
    eval "$(rbenv init - --no-rehash zsh)"

pip() {
  command pip "$@"
  local ret=$?
  if [[ "$1" == "install" ]] || [[ "$1" == "uninstall" ]]; then
    echo "Running pyenv rehash..."
    pyenv rehash
  fi
  return $ret
}

pip3() {
  command pip3 "$@"
  local ret=$?
  if [[ "$1" == "install" ]] || [[ "$1" == "uninstall" ]]; then
    echo "Running pyenv rehash..."
    pyenv rehash
  fi
  return $ret
}

# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# if which pyenv-virtualenv-init > /dev/null; then
#   eval "$(pyenv virtualenv-init -)";
# fi
#
# if which rbenv > /dev/null; then
#   eval "$(rbenv init - --no-rehash zsh)"
# fi
