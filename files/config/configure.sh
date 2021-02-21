#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get purge -y iproute2 iputils-ping

cp /root/shamir-background.png /usr/share/pixmaps/shamir-background.png

cat > /etc/systemd/system/user-autologin.service << EOF
[Unit]
Description=X session autologin
After=getty.target

[Service]
Type=simple
ExecStart=/usr/bin/startx
Restart=always

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /root/.icewm
cat > /root/.icewm/prefoverride << EOF
DesktopBackgroundScaled=1
DesktopBackgroundImage="/usr/share/pixmaps/shamir-background.png"
EOF

cat > /root/.xinitrc << EOF
exec icewm-session
EOF

#cat > /root/.profile << EOF
#if [[ -z \$DISPLAY ]]; then
#    exec startx
#fi
#EOF

systemctl enable  user-autologin.service
