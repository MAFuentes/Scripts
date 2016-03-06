
#Gentoo Tools
emerge app-portage/portage-utils app-portage/gentoolkit app-portage/genlop app-portage/eix

# X Server
emerge x11-base/xorg-drivers x11-base/xorg-server

# Terminal
echo ">=x11-terms/rxvt-unicode-1 256-color xft" >> /etc/portage/package.use
emerge x11-terms/rxvt-unicode

# Browsers
emerge www-client/chromium www-client/firefox

# Tools
emerge app-arch/zip app-arch/unrar media-sound/alsa-utils app-misc/screen net-ftp/gftp 

# Java
emerge dev-java/icedtea-bin

# Files System tools
emerge sys-fs/dosfstools sys-fs/btrfs-progs sys-fs/reiserfsprogs sys-fs/jfsutils sys-fs/e2fsprogs

# Torrent
emerge net-p2p/deluge

# Video Player
emerge media-video/vlc

# Editor
emerge app-editors/emacs app-emacs/ess

# Office
emerge app-office/libreoffice

# Programing
emerge dev-vcs/git

# Network
emerge net-misc/wicd
rc-update add wicd default

# WM
emerge x11-wm/fluxbox

# Lock X session
x11-misc/xlockmore

# Login
emerge x11-misc/slim
rc-update add xdm default
echo "DISPLAYMANAGER=\"slim\"" >> /etc/conf.d/xdm

# Fluxbox
emerge x11-themes/commonbox-styles x11-themes/commonbox-styles-extra x11-themes/fluxbox-styles-fluxmod x11-themes/gentoo-artwork app-admin/conky media-gfx/imagemagick

# DisplayManager
emerge x11-misc/arandr

# SSD
mkdir /tmp/ssdFstrim
cd /tmp/ssdFstrim
rm master 2> /dev/null
wget --no-check-certificate https://github.com/dobek/fstrimDaemon/tarball/master
tar xvf master
sh $(find ./ -type d -name 'dobek*')/install.sh
cd /
rm -r /tmp/ssdFstrim
rc-update add fstrimDaemon default
rc-update start fstrimDaemon
