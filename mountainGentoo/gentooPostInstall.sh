#!/bin/bash
echo "Install Programs:"
#Gentoo Tools
echo "  - Gentoo Tools";
# dev-lang/perl
emerge --backtrack=90 app-portage/portage-utils app-portage/gentoolkit app-portage/genlop app-portage/eix > /root/InstallLog/emerge-GentooTools.log 2>&1;

# X Server
echo "  - X Serve";
emerge --backtrack=30 app-admin/eselect
emerge x11-base/xorg-drivers x11-base/xorg-server > /root/InstallLog/emerge-XServer.log 2>&1;

# Terminal
echo "  - Terminal";
emerge x11-terms/rxvt-unicode > /root/InstallLog/emerge-Terminal.log 2>&1;

# Browsers
echo "  - Browsers";
emerge sys-libs/glibc
emerge www-client/chromium > /root/InstallLog/emerge-chromium.log 2>&1;
emerge www-client/firefox > /root/InstallLog/emerge-firefox.log 2>&1;

# Tools
echo "  - Tools";
emerge app-arch/zip app-arch/unrar media-sound/alsa-utils app-misc/screen net-ftp/gftp > /root/InstallLog/emerge-Tools.log 2>&1;

# Java
echo "  - Java";
emerge dev-java/icedtea-bin > /root/InstallLog/emerge-Java.log 2>&1;

# Files System tools
echo "  - Files System tools";
emerge sys-fs/dosfstools sys-fs/btrfs-progs sys-fs/reiserfsprogs sys-fs/jfsutils sys-fs/e2fsprogs > /root/InstallLog/emerge-FileSystemTools.log 2>&1;

# Torrent
echo  "  - Torrent";
emerge net-p2p/deluge > /root/InstallLog/emerge-Torrents.log 2>&1;

# Video Player
echo "  - Video Player";
emerge media-video/vlc > /root/InstallLog/emerge-vlc.log 2>&1;

# Editor
echo "  - Editor";
emerge app-editors/emacs app-emacs/ess > /root/InstallLog/emerge-Emacs.log 2>&1;

# Office
echo "  - Office";
emerge app-office/libreoffice > /root/InstallLog/emerge-LibreOffice.log 2>&1;

# PaintBrush
echo "  - Paint";
emerge media-gfx/pinta

# Programing
echo "  - Programing";
emerge dev-vcs/git > /root/InstallLog/emerge-Git.log 2>&1;

# Network
echo "  - Network";
#emerge net-misc/wicd > /root/InstallLog/emerge-Network.log 2>&1;
#rc-update add wicd default;
rc-update add dhcpcd default;
emerge wpa_supplicant
rc-update add wpa_supplicant default;
echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel" > /etc/wpa_supplicant/wpa_supplicant.conf;
echo "update_config=1" >> /etc/wpa_supplicant/wpa_supplicant.conf;
cp /usr/share/dhcpcd/hooks/10-wpa_supplicant /lib/dhcpcd/dhcpcd-hooks;
echo "modules_wlan0=\"wpa_supplicant\"" > /etc/conf.d/net;
echo "config_wlan0=\"dhcp\"" > /etc/conf.d/net;
chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf;

# WM
echo "  - WM";
emerge x11-wm/fluxbox > /root/InstallLog/emerge-Fluxbox.log 2>&1;

# Lock X session
echo "  - X session";
x11-misc/xlockmore > /root/InstallLog/emerge-LockX.log 2>&1;

# Login
echo "  - Login";
emerge x11-misc/slim > /root/InstallLog/emerge-Login.log 2>&1;
rc-update add xdm default;
echo "DISPLAYMANAGER=\"slim\"" >> /etc/conf.d/xdm;
echo "XSESSION=\"custom\"" > /etc/env.d/90xsession 

# Fluxbox
echo "  - Fluxbox";
emerge x11-themes/commonbox-styles x11-themes/commonbox-styles-extra x11-themes/fluxbox-styles-fluxmod x11-themes/gentoo-artwork app-admin/conky media-gfx/imagemagick > /root/InstallLog/emerge-FluxboxTools.log 2>&1;

# DisplayManager
echo "  - DisplayManager";
emerge x11-misc/arandr > /root/InstallLog/emerge-DisplayManager.log 2>&1;

# SSD
echo "  - SSD";
mkdir /tmp/ssdFstrim;
cd /tmp/ssdFstrim;
#rm master 2> /dev/null;
wget --no-check-certificate https://github.com/dobek/fstrimDaemon/tarball/master;
tar xvf master;
cd $(find ./ -type d -name 'dobek*')/
sh install.sh > /root/InstallLog/emerge-SSD.log 2>&1;
cd /;
rm -r /tmp/ssdFstrim;
rc-update add fstrimDaemon default;
