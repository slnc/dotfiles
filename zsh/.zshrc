() {
  # Load all of the files in rc.d that start with <number>- and end in `.zsh`.
  # (n) sorts the results in numerical order.
  #  <->  is an open-ended range. It matches any non-negative integer.
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file   # like `source`, but don't search $path
  done
} "$@"  # pass-through args to zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc ] && source ~/.zshrc

if command -v tmux >/dev/null 2>&1 && [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux attach -s default || tmux new -s default
fi
