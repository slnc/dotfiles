# Set history first to preserve it.

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

SAVEHIST=$(( 100 * 1000 ))  # max entries

HISTSIZE=$(( 1.2 * SAVEHIST ))  # Zsh recommended value

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK  # for safety + performance
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS

histsearch() { fc -lim "*$@*" 1 }
