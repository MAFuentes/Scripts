#!/bin/bash
## Prepare Environment ##
echo "Prepare Environment"
source /etc/profile;
eselect profile set 3;
env-update && source /etc/profile;
mkdir /root/InstallLog;

## Intalling Kernel ##
echo "Intalling Kernel"
emerge gentoo-sources dhcpcd grub linux-firmware > /root/InstallLog/emerge-system.log 2>&1;
cd /usr/src/linux;
cp /root/kernel/.config /usr/src/linux/;
yes "" | make silentoldconfig &&
make && make modules_install &&
cp arch/x86_64/boot/bzImage /boot/kernel-$(ls -l /usr/src/linux | cut -d">" -f2 | cut -d"-" -f2)-gentoo;


## Basic Configurations ##
echo "Basic Configurations"
echo "/dev/sdb / btrfs noatime,discard 0 1" >> /etc/fstab;
cp /usr/share/zoneinfo/Europe/Madrid /etc/localtime;
echo "Europe/Madrid" > /etc/timezone;
echo "hostname=\"gnoo\"" > /etc/conf.d/hostname;
sed 's/#rc_parallel=\"NO\"/rc_parallel=\"YES\"/' /etc/rc.conf > /etc/rc.conf.new;
mv /etc/rc.conf.new /etc/rc.conf;

## Grub ##
echo "Grub"
grub2-install /dev/sda;
grub2-mkconfig -o /boot/grub/grub.cfg;
sed 's/set timeout=5/set timeout=0/' /boot/grub/grub.cfg > /boot/grub/grub.cfg.new;
mv /boot/grub/grub.cfg.new /boot/grub/grub.cfg

## Install Programs ##
sh /root/Scripts/gentooPostInstall.sh

## Add User ##
useradd -m -G users,wheel,audio,video,usb,cdrom -s /bin/bash sitron;
