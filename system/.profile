# ~/.profile: executed by the command interpreter for login shells.
# Reference: https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

# set PATH so that it includes:

# --> a "user" bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# --> a "local" bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# # export a variable that supports the use of dunst for notifications
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}

export GDK_SCALE=2
export GDK_DPI_SCALE=1.25

export XDG_DATA_HOME="$HOME/.local/share"

export QT_QPA_PLATFORMTHEME=gtk2


if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
