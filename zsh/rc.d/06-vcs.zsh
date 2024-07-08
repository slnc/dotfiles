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
# Full prompt overriden later. Leaving this here for educational purposes.
PS1="${PS1}\$vcs_info_msg_0_"

zstyle ':vcs_info:git:*' formats '%b %u%c'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%K{16} %F{242}%b%F{162}%c%u%f%F{240} %f%k '
zstyle ':vcs_info:*' enable git

+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
    local untracked_count
    untracked_count=$(git status --porcelain 2>/dev/null | grep '^??' | wc -l)
    if [[ $untracked_count -gt 0 ]]; then
      hook_com[unstaged]+='?%f'
    fi
  fi
}
