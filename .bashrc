# Load git completion functionality
source ~/core/projects/macbookpro/git-completion.bash

function parse_git_branch {
  local branch=$(__git_ps1 "%s")
  [[ $branch ]] && echo "[$branch]"
}

# Don't show duplicated entries when using 'history' command.
export HISTCONTROL=erasedups

# Store up to 50k entries in history
export HISTSIZE=50000

export JAVA_HOME=/Library/Java/Home

# Show short bash prompt. Change the last digit of 1;34 to change colors (it
# goes from 0 up to 7).
export PS1='\[\033[1;34m\]\w\[\033[0m\]$(parse_git_branch)$ '

# The history list is appended to the history file when the shell exits,
# rather than overwriting the history file.
shopt -s histappend

# Show colorized output, show all files except "." and ".." and add a slash at
# the end of directory names
alias ls='ls -ApG'

# Shortcut for list mode (my default).
alias ll='ls -l'

unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  # Use MacVim in terminal mode instead of builtin Vim in order to get +conceal.
  alias vim='mvim -v'
fi
