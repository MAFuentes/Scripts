## Prepare Disk ##
mkfs.ext4 /dev/sda1;
mkfs.ext4 /dev/sda3;
mkswap /dev/sda2;
swapon /dev/sda2;
mkdir /mnt/gentoo;
mount /dev/sdb3 /mnt/gentoo;
mkdir /mnt/gentoo/boot/;
mount /dev/sdb1 /mnt/gentoo/boot;

## Donload System ##
cd /tmp/;
rm latest-stage3.txt;
rm stage3-*;
wget ftp://de-mirror.org/gentoo/releases/amd64/autobuilds/latest-stage3.txt;
wget "ftp://de-mirror.org/gentoo/releases/amd64/autobuilds/$(cat latest-stage3.txt | grep stage3 | cut -d" " -f1 | head -n 1)";
tar vxfpj stage3-amd64*.tar.bz2 -C /mnt/gentoo/;
wget http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2;
tar vxjf portage-latest.tar.bz2 -C /mnt/gentoo/usr;

## Prepare System ##
cp -L /etc/resolv.conf /mnt/gentoo/etc/;
mount -t proc proc /mnt/gentoo/proc;
mount --rbind /sys /mnt/gentoo/sys;
mount --rbind /dev /mnt/gentoo/dev;
chroot /mnt/gentoo /bin/bash;
source /etc/profile;
export PS1="(chroot) $PS1";
#eselect profile list; <--Show profiles list
eselect profile set 3;
env-update && source /etc/profile;
# Prepare make.conf
echo "## Compile Features ##"> /etc/portage/make.conf
echo "CFLAGS=\"-O2 -pipe -march=native\"" >> /etc/portage/make.conf
echo "CXXFLAGS=\"\${CFLAGS}\"" >> /etc/portage/make.conf
echo "CHOST=\"x86_64-pc-linux-gnu\"" >> /etc/portage/make.conf
echo "MAKEOPTS=\"-j5\"" >> /etc/portage/make.conf
echo "" >> /etc/portage/make.conf
echo "## Portage stuff ##" >> /etc/portage/make.conf
echo "ACCEPT_KEYWORDS=\"~amd64\"" >> /etc/portage/make.conf
echo "FEATURES=\"parallel-fetch protect-owned compressdebug splitdebug\"" >> /etc/portage/make.conf
echo "CCACHE_SIZE=\"5G\"" >> /etc/portage/make.conf
echo "CCACHE_DIR=\"/var/ccache\"" >> /etc/portage/make.conf
echo "PORTDIR=\"/usr/portage\"" >> /etc/portage/make.conf
echo "DISTDIR=\"${PORTDIR}/distfiles\"" >> /etc/portage/make.conf
echo "PKGDIR=\"${PORTDIR}/packages\"" >> /etc/portage/make.conf
echo "PORTAGE_TMPDIR=\"/tmp\"" >> /etc/portage/make.conf
echo "" >> /etc/portage/make.conf
echo "## USE ##" >> /etc/portage/make.conf
echo "USE=\"bindist mmx sse sse2 sse3 threads wifi\"" >> /etc/portage/make.conf
echo "" >> /etc/portage/make.conf
echo "## Hardware ##" >> /etc/portage/make.conf
echo "INPUT_DEVICES=\"evdev void\"" >> /etc/portage/make.conf
echo "VIDEO_CARDS=\"vesa intel nouveau\"" >> /etc/portage/make.conf
echo "LIRC_DEVICES=\"audio audio_alsa serial pctv\"" >> /etc/portage/make.conf
echo "ALSA_CARDS=\"emu10k1x darla20 darla24 emu10k1 gina20 gina24 hdsp hdspm ice1712 indigo indigoio layla20 layla24 mia mixart  mona pcxhr rme32 rme96 sb16 sbawe sscape usbusx2y vx222 usb-usx2y\"" >> /etc/portage/make.conf
echo "" >> /etc/portage/make.conf
echo "## Mirrors ##" >> /etc/portage/make.conf
echo "GENTOO_MIRRORS=\"ftp://de-mirror.org/gentoo/\"" >> /etc/portage/make.conf
echo "SYNC=\"rsync://rsync.de.gentoo.org/gentoo-portage\"" >> /etc/portage/make.conf

## Prepare Kernel ##
emerge gentoo-sources dhcpcd grub linux-firmware ntp sys-process/cronie;
cd /usr/src/linux;
make menuconfig;
make && make modules_install;
cp arch/x86_64/boot/bzImage /boot/kernel-$(ls -l /usr/src/linux | cut -d">" -f2 | cut -d"-" -f2)-gentoo;


## Basic Configurations ##
# /etc/fstab
## Use discard for SSD disk drive
echo "/dev/sda1 /boot ext4 noauto,noatime,discard 1 2" > /etc/fstab;
echo "/dev/sda3 / ext4 noatime,discard 0 1" >> /etc/fstab;
echo "/dev/sda2 none swap sw 0 0" >> /etc/fstab;
#echo "tmpfs /tmp tmpfs noatime,nodiratime,size=4G 0 0" >> /etc/fstab;
# Local time
cp /usr/share/zoneinfo/Europe/Madrid /etc/localtime;
echo "Europe/Madrid" > /etc/timezone;
echo "hostname=\"gnoo\"" > /etc/conf.d/hostname;
# Optimize the boot
sed 's/#rc_parallel=\"NO\"/rc_parallel=\"YES\"/' /etc/rc.conf > /etc/rc.conf.new;
mv /etc/rc.conf.new /etc/rc.conf;
# Add .cache to /tmp
echo "XDG_CACHE_HOME=\"/tmp/.cache\"" > /etc/env.d/30xdg-data-local
# rc-update defaults
rc-update add cronie default;
# Grub
grub2-install /dev/sda;
grub2-mkconfig -o /boot/grub/grub.cfg;
#sed 's/set timeout=5/set timeout=0/' /boot/grub/grub.cfg > /boot/grub/grub.cfg.new;
#mv/boot/grub/grub.cfg.new /boot/grub/grub.cfg
# Root Password
clear;
echo "Set the password for root."
passwd;

#For SSD (More info in: http://chmatse.github.io/SSDcronTRIM/)
cd /tmp
wget https://raw.github.com/chmatse/SSDcronTRIM/master/SSDcronTRIM
sed 's/SSD_MOUNT_POINTS="\/"/SSD_MOUNT_POINTS="\/ \/boot"/' /tmp/SSDcronTRIM > /tmp/SSDcronTRIM.new;
mv /tmp/SSDcronTRIM.new /tmp/SSDcronTRIM;
chmod 740 SSDcronTRIM
./SSDcronTRIM

#Reboot
exit;
cd;
umount -l /mnt/gentoo/dev{/shm,/pts,};
umount -l /mnt/gentoo{/boot,/proc,};
reboot;

#post-install
useradd -m -G users,wheel,audio,video,usb,cdrom -s /bin/bash sitron;
passwd sitron;
emerge xorg-drivers xorg-server;
env-update && source /etc/profile;
emerge bumblebee;

