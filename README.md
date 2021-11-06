# Juan's dotfiles

## Dependencies

- git
- tmux
- vim
- zsh

## Installation

```
targets=".git .tmux.conf .vim .vimrc .zshrc"

setopt shwordsplit
for f in $targets; do
  ln -s $f ~
done
unsetopt shwordsplit
```
