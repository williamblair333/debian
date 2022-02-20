#!/bin/bash
#################################################################################
##https://unix.stackexchange.com/questions/632977/how-do-i-disable-the-pc-speaker-beep-on-debian-buster
#Run example: ./pcspkr_disable.sh
#File:        pcspkr_disable.sh
#Date:        2022FEB06
#Author:      telcoM
#Contact:     https://unix.stackexchange.com/users/258991/telcom
#Tested on:   Debian 10+?
#To test:     ?
#
#This script is intended to do the following:
#
#- Disable PC speaker bell on terminal and gui session via systemd services
#- and startup script for X11
#
#- In Debian, the PC speaker (the bell) support is built into the main kernel, as 
#- opposed to being a separate loadable module like in Arch. 
#- The other methods mentioned in the Arch wiki should still work.
#################################################################################

#immediately silence the bell
# --blength       [0-2000]          duration of the bell in milliseconds
setterm -blength 0
#################################################################################

#set systemd service to silence pcspkr at boot time
path_systemd='etc/systemd/system'

cat >> /$path_systemd/pcspkr.service <<EOL
[Unit]
Description=Silence pcspkr console default beep

[Service]
Type=oneshot
Environment=TERM=linux
StandardOutput=tty
TTYPath=/dev/console
ExecStart=/usr/bin/setterm -blength 0

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable pcspkr
systemctl start pcspkr
#################################################################################

#For X11 GUI sessions start-up script:
#To turn bell off: -b or b off or b 0
path_x11=etc/X11/Xsession.d

cat >> /$path_x11/91custom-silence-pcspkr <<EOL
#!/bin/sh

xset -b
EOL
#################################################################################
