# ~/.profile: executed by the command interpreter for login shells.

# # if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
#     . "$HOME/.bashrc"
#     fi
# fi

# set PATH so that it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

## enable the GTK configuration
#export APPMENU_DISPLAY_BOTH=1
#if [ -n "$GTK_MODULES" ]
#then
#  GTK_MODULES="$GTK_MODULES:unity-gtk-module"
#else
#  GTK_MODULES="unity-gtk-module"
#fi
##
#if [ -z "$UBUNTU_MENUPROXY" ]
#then
#  UBUNTU_MENUPROXY=1
#fi
#export GTK_MODULES
#export UBUNTU_MENUPROXY

# # add rust to the path
# export PATH="$HOME/.cargo/bin:$PATH"

# # set the wallpaper for i3
# # note that xsetroot does not work
# hsetroot -solid "#1C1C1C"

# # export a variable that supports the use of dunst for notifications
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}

export GDK_SCALE=2
export GDK_DPI_SCALE=1.25

export XDG_DATA_HOME="$HOME/.local/share"

export QT_QPA_PLATFORMTHEME=gtk2

export PATH="$PATH:$HOME/.local/bin"

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
