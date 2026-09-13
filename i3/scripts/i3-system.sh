#!/usr/bin/env bash

# i3-system.sh
# Use rofi to call systemctl for shutdown, reboot, etc

# 2016 Oliver Kraitschy - http://okraits.de
# Script customized with special messages and icons
# by Gregory M. Kapfhammer

# Configure the options with icons and a label;
# note that the Hibernate System is not reliable
OPTIONS=" Lock System\n Restart System\n Shutdown System\n󰒲 Suspend System"

# Configure rofi's launcher commands
LAUNCHER="rofi -dmenu -i -p 󰑣"

# Always support the lock command
USE_LOCKER="true"

# Use a customized i3lock command suitable only for the forked version
# the customized i3lock is run through a script to promote reuse in i3 config
LOCKER="~/.config/i3/scripts/i3-lock-screen-betterlock.sh"

# Show exit wm option if exit command is provided as an argument
if [ ${#1} -gt 0 ]; then
  OPTIONS="󰍃 Log Out\n$OPTIONS"
fi

# Use the $2 variable to skip over the symbol and extract the command
option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $2}' | tr -d '\r\n'`
if [ ${#option} -gt 0 ]
then
    case $option in
      Log)
        eval $1
        ;;
      Lock)
        eval $LOCKER
        ;;
      Restart)
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
