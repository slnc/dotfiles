bindkey -e  # Make ^A/^E go to beginning/end of line
bindkey \^U backward-kill-line
bindkey '^R' history-incremental-pattern-search-backward

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
