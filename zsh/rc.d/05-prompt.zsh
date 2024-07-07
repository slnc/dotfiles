# https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows/645612
unsetopt PROMPT_SP

PROMPT='%F{6}%* %F{38}%1~%f '
