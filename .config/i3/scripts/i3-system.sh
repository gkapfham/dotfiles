#!/usr/bin/env bash

# i3-system.sh
# Use rofi to call systemctl for shutdown, reboot, etc

# 2016 Oliver Kraitschy - http://okraits.de

OPTIONS="Lock System\nReboot System\nShutdown System\nSuspend System"

# source configuration or use default values
if [ -f $HOME/.config/rofi-power/config ]; then
  source $HOME/.config/rofi-power/config
else
  LAUNCHER="rofi -width 30 -dmenu -i -p system:"
  USE_LOCKER="true"
  LOCKER="i3lock --indicator -e --greetertext='login' --greeterpos='100:225' --greetercolor=875f87ff --indpos='100:100' --wrongtext='Incorrect' --veriftext='Verifying' --locktext='Locking' --radius=75 --insidecolor=875f87ff --ringvercolor=5f8700ff --keyhlcolor=b5bd68ff --linecolor=875f87ff --ringwrongcolor=5f8700ff --insidevercolor=81a2beff --insidewrongcolor=de935fff --line-uses-inside --separatorcolor=5f8700ff -i ~/configure/wallpaper/mountains.png"
fi

# Show exit wm option if exit command is provided as an argument
if [ ${#1} -gt 0 ]; then
  OPTIONS="Log Out\n$OPTIONS"
fi

option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $1}' | tr -d '\r\n'`
if [ ${#option} -gt 0 ]
then
    case $option in
      Log)
        eval $1
        ;;
      Lock)
        eval $LOCKER
        ;;
      Reboot)
        systemctl reboot
        ;;
      Shutdown)
        systemctl poweroff
        ;;
      Suspend)
        $($USE_LOCKER) && "$LOCKER"; systemctl suspend
        ;;
      Hibernate)
        $($USE_LOCKER) && "$LOCKER"; systemctl hibernate
        ;;
      *)
        ;;
    esac
fi
