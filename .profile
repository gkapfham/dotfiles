# ~/.profile: executed by the command interpreter for login shells.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# GTK configuration
export APPMENU_DISPLAY_BOTH=1
if [ -n "$GTK_MODULES" ]
then
  GTK_MODULES="$GTK_MODULES:unity-gtk-module"
else
  GTK_MODULES="unity-gtk-module"
fi

if [ -z "$UBUNTU_MENUPROXY" ]
then
  UBUNTU_MENUPROXY=1
fi
export GTK_MODULES
export UBUNTU_MENUPROXY

# add rust to the path
export PATH="$HOME/.cargo/bin:$PATH"

# set the wallpaper for i3
feh --bg-fill ~/configure/wallpaper/mountains.png

# run the gnome keyring manager
if [ -n "$DESKTOP_SESSION" ];then
    # eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh) &
    # export SSH_AUTH_SOCK
    # run the daemon
    eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh) &
    export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
    /usr/bin/ssh-agent
    /usr/bin/ssh-add -t 432000
    # eval $(ssh-agent)
fi

# SSH_ENV="$HOME/.ssh/environment"
# function start_agent {
#   echo "Initialising new SSH agent..."
#   /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#   echo succeeded
#   chmod 600 "${SSH_ENV}"
#   . "${SSH_ENV}" > /dev/null
#   /usr/bin/ssh-add -t 432000 ;
# }

# if [ -f "${SSH_ENV}" ]; then
#   . "${SSH_ENV}" > /dev/null
#   ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#     start_agent;
#   }
# else
#   start_agent;
# fi
