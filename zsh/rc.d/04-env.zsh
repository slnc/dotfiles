export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim
export PGUSER=postgres  # TODO: do only if necessary

# -U ensures each entry in these is unique (that is, discards duplicates).
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.

export ZSH_COMPDUMP=~/.cache/.zcompdump-$HOST

export PROLEGO_WORK_DIR=~/files/juan/prolego/prolego-src
export GM_WORK_DIR=~/files/juan/gamersmafia/src

# determines search program for fzf
if type ag &> /dev/null; then
  export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
path=(
    $path
    ~/bin(N)
    /opt/homebrew/bin(N)
)

# Add your functions to your $fpath, so you can autoload them.
fpath=(
  $ZDOTDIR/functions
  $fpath
  ~/.local/zsh/site-functions
)

# Disabled because most fns are rarely-used
autoload -U $fpath[1]/*(.:t)
