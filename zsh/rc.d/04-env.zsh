export EDITOR=vim
export GIT_CONFIG_GLOBAL=~/.dotfiles/.gitconfig
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export MYVIMRC="~/.dotfiles/.vimrc"
export PGUSER=postgres
export PSQLRC=~/.dotfiles/.psqlrc
export PYTHONSTARTUP=${DOTFILES_DIR}/.pythonrc
export TMUXCONF=~/.dotfiles/.tmux.conf
export VIMINIT='source $MYVIMRC'
export ZSH_COMPDUMP=~/.cache/.zcompdump-$HOST

export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath

if type ag &> /dev/null; then
  export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

path=(
    $path
    ~/bin(N)
    /opt/homebrew/bin(N)
    ~/.local/bin
)

fpath=(
  $ZDOTDIR/functions
  $fpath
  ~/.local/zsh/site-functions
)

autoload -U $fpath[1]/*(.:t)

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then
eval "$(pyenv virtualenv-init -)";
fi
