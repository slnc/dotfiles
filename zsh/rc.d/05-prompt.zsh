# https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows/645612
unsetopt PROMPT_SP

# Colors table: https://jonasjacek.github.io/colors/
if [ $(hostname) = 'nomind' ]; then
  PROMPT='%F{033}%* %F{195}%1~%f '
elif [ $(hostname) = 'tempest' ]; then
  PROMPT='%F{160}%* %F{251}%1~%k%f '
elif [ $(hostname) = 'whispers' ]; then
  PROMPT='%F{007}%* %F{141}%1~%f '
elif [ -f /.dockerenv ]; then  # assume GM dev docker instance
  PROMPT='%F{28}%* %F{94}%1~%f '  # boina verde
elif [ $(uname) = 'Linux' ]; then
  PROMPT='%F{6}%* %F{38}%1~%f '
else  # Mac
  if which scutil &>/dev/null && [ $? -eq 0 ]; then
    local cn=$(scutil --get LocalHostName)
    if [ $cn = 'mbpro2019j' ]; then
      PROMPT='%F{6}%* %F{172}%1~%f '
    elif [ $cn = 'mbpro23jj' ]; then
#       autoload -Uz vcs_info
#       zstyle ':vcs_info:git:*' formats '%b'
#       zstyle ':vcs_info:git:*' actionformats '%b'
#       precmd() {
#         vcs_info
#       }
#
      PROMPT='%F{45}%* %F{251}%1~%f '
    else
      echo "Unknown mac host, setting default prompt"
    fi
  else
    echo "Unknown host type, setting default prompt"
    PROMPT='%F{6}%* %F{172}%1~%f '
  fi
fi
