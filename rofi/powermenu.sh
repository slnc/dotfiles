#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-5"
theme='style-3'

# CMDs
lastlogin="`last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7`"
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
hibernate='hibernate'
shutdown='shutdown'
reboot='reboot'
lock='lock'
suspend='suspend'
logout='logout'
yes='yes'
no='no'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p " $USER@$host" \
		-mesg " Last Login: $lastlogin | Uptime: $uptime"
		# -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--hibernate' ]]; then
			systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
				i3-msg exit
			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			fi
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
      deadbeef --quit
      systemctl poweroff
        ;;
    $reboot)
      deadbeef --quit
      systemctl reboot
        ;;
    $hibernate)
      systemctl hibernate
        ;;
    $lock)
		if [[ -x '/usr/bin/i3lock-fancy' ]]; then
      /usr/bin/i3lock-fancy  # -i ~/files/settings/wallpaper.jpg
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
		fi
        ;;
    $suspend)
      deadbeef --quit
      systemctl suspend
        ;;
    $logout)
      # Terminate deadbeef gracefully to avoid Log window show up at startup
      # DEADBEEF_PID=$(pgrep -x deadbeef)
      # if [ -n "$DEADBEEF_PID" ]; then
      #     kill -15 $DEADBEEF_PID
      #     while kill -0 $DEADBEEF_PID 2>/dev/null; do
      #         sleep 0.25
      #     done
      # fi
      deadbeef --quit
      i3-msg exit
        ;;
esac
