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
[ -f ~/.private_zshrc ] && source ~/.private_zshrc

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
