export PATH=$PATH:~/bin

# Load git completion functionality
if [[ `uname` == 'Darwin' ]]; then
  # Use MacVim in terminal mode instead of builtin Vim in order to get +conceal.
  alias vim='mvim -v'
  alias ls='ls -AFpG'
  alias ll='ls -l'

  source ~/core/dotfiles/git-completion.bash
  source ~/core/dotfiles/git-prompt.sh
  export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
else
  source ~/dotfiles/git-completion.bash
  source ~/dotfiles/git-prompt.sh

  # Show colorized output, show all files except "." and ".." and add a slash at
  # the end of directory names
  alias ls='ls -ApG --color=auto'

  alias ll='ls -l'

  eval `dircolors ~/dotfiles/.dir_colors`

  # SSH_ENV="$HOME/.ssh/environment"

  # function start_agent {
  #      echo "Initialising new SSH agent..."
  #      /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  #      echo succeeded
  #      chmod 600 "${SSH_ENV}"
  #      . "${SSH_ENV}" > /dev/null
  #      /usr/bin/ssh-add;
  # }

  # # Source SSH settings, if applicable

  # if [ -f "${SSH_ENV}" ]; then
  #      . "${SSH_ENV}" > /dev/null
  #      #ps ${SSH_AGENT_PID} doesn't work under cywgin
  #      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
  #          start_agent;
  #      }
  # else
  #      start_agent;
  # fi
fi

# Don't show duplicated entries when using 'history' command.
export HISTCONTROL=erasedups

export EDITOR=vim

# Store up to 50k entries in history
export HISTSIZE=50000

export HISTTIMEFORMAT="%Y%m%d %H:%M:%S "

export JAVA_HOME=/Library/Java/Home

# http://superuser.com/questions/180257/bash-prompt-how-to-have-the-initials-of-directory-path
function shorten_pwd {
    # This function ensures that the PWD string does not exceed $MAX_PWD_LENGTH characters
    PWD=$(pwd)

    # if truncated, replace truncated part with this string:
    REPLACE="/.."

    # determine part of path within HOME, or entire path if not in HOME
    RESIDUAL=${PWD#$HOME}

    # compare RESIDUAL with PWD to determine whether we are in HOME or not
    if [ X"$RESIDUAL" != X"$PWD" ]
    then
        PREFIX="~"
    fi

    # check if residual path needs truncating to keep total length below MAX_PWD_LENGTH
    # compensate for replacement string.
    TRUNC_LENGTH=$(($MAX_PWD_LENGTH - ${#PREFIX} - ${#REPLACE} - 1))
    NORMAL=${PREFIX}${RESIDUAL}
    if [ ${#NORMAL} -ge $(($MAX_PWD_LENGTH)) ]
    then
        newPWD=${PREFIX}${REPLACE}${RESIDUAL:((${#RESIDUAL} - $TRUNC_LENGTH)):$TRUNC_LENGTH}
    else
        newPWD=${PREFIX}${RESIDUAL}
    fi

    # return to caller
    echo $newPWD
}

# Show short bash prompt. Change the last digit of 1;34 to change colors (it
# goes from 0 up to 7).
# Set a custom prompt color with:
# PS_MODE=1
# Meaningful values for solarice theme: 1 to 8
SLNC_PS1_COLOR=${SLNC_PS1_COLOR:=8}
export PS1='\[\033[0;3${SLNC_PS1_COLOR}m\]\t \[\033[0;38m\]$(shorten_pwd)\[\033[1;32m\]$(__git_ps1 " (%s)")\[\033[0m\] '

# The history list is appended to the history file when the shell exits,
# rather than overwriting the history file.
shopt -s histappend

# Shortcut for list mode (my default).
MAX_PWD_LENGTH=20

alias cdgm="cd /srv/www/gamersmafia/current"
alias rtest="ruby -Itest"

function last_modified_file {
  local last=`find $1 -type f -printf "%T@\0%p\0" | awk '
       {
           if ($0>max) {
               max=$0;
               getline mostrecent
           } else
               getline
       }
       END{print mostrecent}' RS='\0'`
  ll $last
}
