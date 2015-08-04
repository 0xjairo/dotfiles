#!/bin/bash

# choose window manager
WINDOW_MANAGER=awesome
#WINDOW_MANAGER=gnome-session

# user
if [ -z "${LOGNAME}" -a -z "${USER}" ]; then
    echo "Unknown user. Neither \$LOGNAME or \$USER is set"
    exit 1
else
    user=$LOGNAME
fi

# window manager PID
wmpid=$(ps -au $user | grep -i $WINDOW_MANAGER | awk '{print $1}')

# set the DBUS session to access keyring
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/${wmpid}/environ | sed 's/DBUS_SESSION_BUS_ADDRESS=//')

# call offline imap
offlineimap -u Basic
