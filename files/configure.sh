#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get purge -y iproute2 iputils-ping

cat > /root/.xinitrc << EOF
exec icewm-session
EOF

cat > /root/.profile << EOF
startx
EOF

