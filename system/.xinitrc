# make Caps Lock behave like Ctrl:
setxkbmap -option ctrl:nocaps

# make short-pressed Ctrl behave like Escape:
xcape -e 'Control_L=Escape'

# fix palm scrolling while typing
synclient PalmMinZ=100

# start the ssh agent
eval "$(ssh-agent -s)"

# set the wallpaper for i3
# note that xsetroot does not work
hsetroot -solid "#1C1C1C"

# start the gnome keyring for storing passwords,
# which supports the connection between VSCode and GitHub
eval $(/usr/sbin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export $(/usr/sbin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
dbus-update-activation-environment --systemd DISPLAY

# startx /usr/sbin/i3
#
exec i3
