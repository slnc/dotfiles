function cch {
  ssh -t $@ "tmux -CC new -A -s foo"
}

alias sar='service apache2 restart'
alias ls='ls -AFpG'
alias ll='ls -l'
alias cdblog="cd ~/files/juan/juan.al/hugo_website/content"
alias rt="bin/rails test"
alias history="history 1"
alias sr='cch slnc@rick'
alias bv='docker exec -it gm-dev /usr/bin/zsh'  # && tmux -CC new -A -s foo'
alias startbv='docker run -i --rm -h boinaverde --name gm-dev -p22:22 -p80:80 -p443:443 -p5432:5432 -v /Users/juanalonso/files/juan/gamersmafia/src:/var/www/gamersmafia/current -v /Users/juanalonso/files/juan/gamersmafia/prod-db/:/var/lib/postgresql -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent gm-dev-ubuntu-22-04:latest'


histsearch() { fc -lim "*$@*" 1 }

export PATH=~/bin:/$PATH

# https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows/645612
unsetopt PROMPT_SP

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1200000
SAVEHIST=1000000

# Colors table: https://jonasjacek.github.io/colors/
if [ $(hostname) = 'rick' ]; then
  PROMPT='%F{007}%* %F{43}%1~%f '
elif [ -f /.dockerenv ]; then  # assume GM dev docker instance
  PROMPT='%F{28}%* %F{94}%1~%f '  # boina verde
elif [ $(uname) = 'Linux' ]; then
  PROMPT='%F{6}%* %F{38}%1~%f '
else  # Mac
  PROMPT='%F{6}%* %F{172}%1~%f '
fi

setopt AUTO_CD
setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_NO_STORE
setopt CORRECT
setopt HIST_REDUCE_BLANKS
setopt LIST_PACKED
setopt GLOBDOTS
unsetopt AUTO_MENU
unsetopt LIST_BEEP

export EDITOR=vim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' max-errors 10
zstyle :compinstall filename '/Users/juanalonso/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%b %u%c'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'

bindkey -e  # Make ^A/^E go to beginning/end of line
bindkey \^U backward-kill-line

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='T'
    fi
}

sync_hdds(){
  # bob, kevin, stuart
  current=bob
  next=kevin

  echo "Syncing from $current to $next.."
  rsync --exclude=.Trashes \
    --exclude=.Trashes \
    --exclude=.TemporaryItems \
    --exclude=.Spotlight-V100 \
    --exclude=.DocumentRevisions-V100 \
    --exclude=.fseventsd \
    --exclude=.DS_Store \
    -avz /Volumes/${current}/ /Volumes/${next}
  echo "Update current & next"
}

if [[ `uname` == "Darwin" ]]; then
  rpl() {
    find . -type f -name "*" -exec sed -i '' "s/$1/$2/g" {} +
  }
fi

prolego_start() {
  cd /Users/juanalonso/files/juan/prolego_web
  ./prolego
}

# determines search program for fzf
if type ag &> /dev/null; then
  export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

# set directory=$HOME/.vim/swapfiles/
if [ $(hostname) = 'rick' ]; then
  if command -v tmux &> /dev/null && [ -n "$PROMPT" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
      # exec tmux a
  fi
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
export PGUSER=postgres
