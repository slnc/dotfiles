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

# lt
alias aseprite_export="cd $GM_WORK_DIR && ./script/sprites/aseprite_export.sh"
alias regen_sprites="cd /var/www/gamersmafia/current && echo 'Sprites.gen_all && User.find(1).user_avatar.save' | bundle exec rails c && sar"

alias ls='ls -AFpG --color=always'
alias ll='ls -l'
alias yt-dlp_macos="~/bin/yt-dlp_macos --ffmpeg-location=~/bin/ffmpeg"
alias history="history 1"

alias sn='cch necromancer.internal'
alias sm='cch nomind.internal'
alias sw='cch whispers.internal'