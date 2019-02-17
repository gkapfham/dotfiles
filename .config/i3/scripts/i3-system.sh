#!/usr/bin/env bash

# i3-system.sh
# Use rofi to call systemctl for shutdown, reboot, etc

# 2016 Oliver Kraitschy - http://okraits.de

OPTIONS="Lock System\nReboot System\nShutdown System\nSuspend System"

# source configuration or use default values
if [ -f $HOME/.config/rofi-power/config ]; then
  source $HOME/.config/rofi-power/config
else
  # LAUNCHER="rofi -width 30 -dmenu -i -p system"
  LAUNCHER="rofi -dmenu -i -p system"
  USE_LOCKER="true"
  # use a customized i3lock command suitable only for the forked version
  # the customized i3lock is run through a script to promote reuse in i3 config
  LOCKER="~/.config/i3/scripts/i3-lock-screen.sh"
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
