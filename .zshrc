function cch {
  ssh -t $@ "tmux -CC new -A -s foo"
}

alias sar='service apache2 restart'
alias ls='ls -AFpG'
alias ll='ls -l'
alias cdblog="cd ~/files/juan/juan.al/hugo_website/content"
alias rt="bin/rails test"
alias rtc='COVERAGE=true bin/rails test:all'
alias srt="PARALLEL_WORKERS=1 rt"  # sequential
alias srtd="PARALLEL_WORKERS=1 DEBUG=1 rt"  # sequential debug
alias reset_test_db="RAILS_ENV=test rails db:reset db:fixtures:load"
alias rubocop_clean="rubocop -c .rubocop-pre-commit.yml -a app config lib script test"
alias history="history 1"
# alias sr='cch slnc@rick'
alias sr='cch rick'
alias bv='docker exec -it gm-dev /usr/bin/zsh'  # && tmux -CC new -A -s foo'
alias charlie='docker exec -it prolego-dev /usr/bin/zsh'  # && tmux -CC new -A -s foo'
alias cpd="cap production deploy"
alias aseprite_export="cd /Users/slnc/files/juan/gamersmafia/src && ./script/sprites/aseprite_export.sh"
alias regen_sprites="cd /var/www/gamersmafia/current && echo 'Sprites.gen_all && User.find(1).user_avatar.save' | bundle exec rails c && sar"
alias bv_etc_hosts="echo 'Faction.to_etc_hosts("127.0.0.1", "dev")' | bundle exec rails c"
alias rick_etc_hosts="echo 'Faction.to_etc_hosts("192.168.31.103", "com")' | bundle exec rails c"


histsearch() { fc -lim "*$@*" 1 }

export PATH=~/bin:/$PATH
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows/645612
unsetopt PROMPT_SP

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1200000
SAVEHIST=1000000

# Colors table: https://jonasjacek.github.io/colors/
if [ $(hostname) = 'rick' ]; then
  PROMPT='%F{007}%* %F{43}%1~%f '
elif [ $(hostname) = 'charlie' ]; then
  PROMPT='%F{007}%* %F{226}%1~%f '
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
setopt interactivecomments
unsetopt AUTO_MENU
unsetopt LIST_BEEP

export EDITOR=vim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' max-errors 10
zstyle :compinstall filename '~/.zshrc'

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

buildbv () {
  # docker image prune -a -f
  cd ~/files/juan/gamersmafia/src
  docker build -t gm-dev-ubuntu-22-04 .
}

buildcharlie () {
  # docker image prune -a -f
  cd ~/files/juan/prolego/prolego-src
  docker build -t prolego-dev-ubuntu-22-04 .
}

startbv () {
  ~/files/juan/gamersmafia/ssh-agent/run.sh -s
  ~/files/juan/gamersmafia/ssh-agent/run.sh

  cd ~/files/juan/gamersmafia/src
  echo "Run this after docker container starts: tmux -CC new -A -s foo"
  docker run -i \
      --rm \
      -h boinaverde \
      --name gm-dev \
      -p80:80 -p443:443 \
      -v ~/files/juan/gamersmafia/src:/var/www/gamersmafia/current \
      -v ~/files/juan/gamersmafia/prod-db/:/var/lib/postgresql \
      --volumes-from=ssh-agent \
      -e SSH_AUTH_SOCK=/.ssh-agent/socket \
      gm-dev-ubuntu-22-04:latest
}

runcharlie () {
  cd ~/files/juan/prolego/prolego-src
  echo "Run this after docker container starts: tmux -CC new -A -s foo"
  docker run -i \
      --rm \
      -h boinaverde \
      --name prolego-dev \
      -p443:443 \
      -v ~/files/juan/prolego/prolego-src:/var/www/prolego/current \
      -v ~/files/juan/prolego/prod-db/:/var/lib/postgresql \
      --volumes-from=ssh-agent \
      -e SSH_AUTH_SOCK=/.ssh-agent/socket \
      prolego-dev-ubuntu-22-04:latest
}

if [[ `uname` == "Darwin" ]]; then
  rpl() {
    find . -type f -name "*" -exec sed -i '' "s/$1/$2/g" {} +
  }
fi

prolego_start() {
  cd ~/files/juan/prolego_web
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
