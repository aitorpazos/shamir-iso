#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get purge -y iproute2 iputils-ping

cp /root/shamir-background.png /usr/share/pixmaps/shamir-background.png
chmod a+r /usr/share/pixmaps/shamir-background.png

cp /root/hal /usr/bin/
cp /root/scrypt-rs /usr/bin/
cp /root/create-key-share-card /usr/bin/
chmod a+rx /usr/bin/hal /usr/bin/scrypt-rs /usr/bin/create-key-share-card

cat > /etc/skel/.config/epiphany/web-extension-settings.ini << EOF
[org/gnome/epiphany]
homepage-url='http://127.0.0.1:631/admin'
EOF

mkdir -p /etc/skel/Desktop
mv /root/README.txt /etc/skel/Desktop/README.txt 

cat > /etc/skel/Desktop/Manage\ printers.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Link
Name=Manage printers
Comment=
URL=http://user:user@127.0.0.1:631/admin

Icon=printer
EOF
chmod +x /etc/skel/Desktop/Manage\ printers.desktop

cat > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/pixmaps/shamir-background.png"/>
        </property>
        <property name="workspace1" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/pixmaps/shamir-background.png"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

useradd -m -s /bin/bash -G adm,lp,cdrom,audio,plugdev,users,systemd-journal,scanner,lpadmin user
passwd user << EOF
user
user
EOF

mkdir -p /etc/sddm.conf.d/
cat > /etc/sddm.conf.d/autologin.conf << EOF
[Autologin]
User=user
Session=xfce.desktop
EOF
