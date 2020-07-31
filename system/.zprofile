# ~/.profile: executed by the shell at the time of login
#
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

# Configure where the system will look for
# the, as an example, .desktop files
export XDG_DATA_HOME="$HOME/.local/share"

# Scale the display correctly to 2.25
# This enables the support of HiDPI

# --> double the size
# NOTE: this variable only supports integer
# scaling and thus writing 2.25 will still
# result in a doubling of the scale
export GDK_SCALE=2

# --> further increase the size
# NOTE: this variable supports fractional scaling
# and it is "additive" with respect to the GDK_SCALE
export GDK_DPI_SCALE=1.25

# Ensure that QT applications take on the same these
# as was selected through lxappearance for a GTK theme
export QT_QPA_PLATFORMTHEME=gtk2

# Start the i3 window manager using the startx command
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
