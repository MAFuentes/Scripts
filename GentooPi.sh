# Prepare Disk
cfdisk;
mkfs.vfat -F 16 /dev/mmcblk0p1;
mkswap /dev/mmcblk0p2;
mkfs.ext4 /dev/mmcblk0p3;
mkdir /mnt/gentoo;
mount /dev/mmcblk0p3 /mnt/gentoo;
mkdir /mnt/gentoo/boot/;
mount /dev/mmcblk0p1 /mnt/gentoo/boot;

# Donload System
cd /tmp/;
rm latest-stage3-armv7a.txt
rm stage3-armv7a*
wget ftp://de-mirror.org/gentoo/releases/arm/autobuilds/latest-stage3-armv7a.txt
wget "ftp://de-mirror.org/gentoo/releases/arm/autobuilds/$(cat latest-stage3-armv7a.txt | grep stage3 | cut -d" " -f1)"
tar vxfpj stage3-armv7a*.tar.bz2 -C /mnt/gentoo/;
wget http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2
tar vxjf portage-latest.tar.bz2 -C /mnt/gentoo/usr;

# Donwload Kernel
git clone --depth 1 git://github.com/raspberrypi/firmware/;
cd firmware/boot;
cp -r * /mnt/gentoo/boot/;
cp -r ../modules /mnt/gentoo/lib/;

# Basic Configurations
echo "/dev/mmcblk0p1 /boot auto noauto,noatime 1 2" > /mnt/gentoo/etc/fstab;
echo "/dev/mmcblk0p3 / ext4 noatime 0 1" >> /mnt/gentoo/etc/fstab; 
echo "/dev/mmcblk0p2 none swap sw 0 0" >> /mnt/gentoo/etc/fstab;
echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p3 rootfstype=ext4 elevator=deadline rootwait" > /mnt/gentoo/boot/cmdline.txt;
cp /mnt/gentoo/usr/share/zoneinfo/Europe/Madrid /mnt/gentoo/etc/localtime;
echo "Europe/Madrid" > /mnt/gentoo/etc/timezone;
echo "hostname=\"gentooberry\"" > /mnt/gentoo/etc/conf.d/hostname;

chroot /mnt/gentoo /mnt/gentoo/bin/bash;
cd /etc/init.d/;
cp net.lo net.eth0;
rc-update add net.eth0 boot;
rc-update add swclock boot;
rc-update del hwclock boot;
rc-update add sshd default;

