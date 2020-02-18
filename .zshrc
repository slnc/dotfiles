alias ls='ls -AFpG'
alias ll='ls -l'
alias cdj="cd ~/files/juan/juanalonso.blog/hugo_website/"

export PATH=~/bin:/$PATH

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1200000
SAVEHIST=1000000
# https://jonasjacek.github.io/colors/
PROMPT='%F{240}%D{%K:%M:%S} %F{172}%1~%f %# '

setopt AUTO_CD
setopt EXTENDED_HISTORY
# setopt SHARE_HISTORY
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

#  export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
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
