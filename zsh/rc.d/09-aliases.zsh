# Always set aliases _last,_ so they don't get used in function definitions.

setopt AUTO_CD

# gm
alias sar='service apache2 restart'
alias rt="bin/rails test"
alias rtc='COVERAGE=true bin/rails test:all'
alias srt="PARALLEL_WORKERS=1 rt"  # sequential
alias srtd="PARALLEL_WORKERS=1 DEBUG=1 rt"  # sequential debug
alias reset_test_db="RAILS_ENV=test rails db:reset db:fixtures:load"
alias bv='docker exec -it gm-dev /usr/bin/zsh'  # && tmux -CC new -A -s foo'
alias charlie='docker exec -it prolego-dev /usr/bin/zsh'  # && tmux -CC new -A -s foo'
alias bv_etc_hosts="echo 'Faction.to_etc_hosts("127.0.0.1", "dev")' | bundle exec rails c"
alias cpd="cap production deploy"

alias ls='ls -AFp --color=always'
alias ll='ls -l'
alias history="history 1"
