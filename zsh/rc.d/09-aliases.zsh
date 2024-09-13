# Always set aliases _last,_ so they don't get used in function definitions.

setopt AUTO_CD

# RoR
alias sar='service apache2 restart'
alias rt="bin/rails test"
alias rtc='COVERAGE=true bin/rails test:all'
alias srt="PARALLEL_WORKERS=1 rt"
alias srtd="PARALLEL_WORKERS=1 DEBUG=1 rt"
alias reset_test_db="RAILS_ENV=test rails db:reset db:fixtures:load"

alias cpd="cap production deploy"

alias ls='ls -AFp --color=always'
alias ll='ls -l'
alias history="history 1"
alias vim=nvim
alias vi=nvim
alias v=nvim
