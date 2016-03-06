#Mountain Laptop Gentoo

## Prepare Disk ##
mkfs.btrfs -f /dev/sdb;
mount /dev/sdb /mnt/gentoo;
mount -t proc proc /mnt/gentoo/proc;
mount --rbind /sys /mnt/gentoo/sys;
mount --rbind /dev /mnt/gentoo/dev;

## Donload System ##
cd /tmp/;
rm latest-stage3.txt 2> /dev/null;
rm stage3-*  2> /dev/null;
wget http://de-mirror.org/gentoo/releases/amd64/autobuilds/latest-stage3.txt;
wget "http://de-mirror.org/gentoo/releases/amd64/autobuilds/$(cat latest-stage3.txt | grep stage3 | cut -d" " -f1 | head -n 1)";
tar vxfpj stage3-amd64*.tar.bz2 -C /mnt/gentoo/;
wget http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2;
tar vxjf portage-latest.tar.bz2 -C /mnt/gentoo/usr;

## Prepare System ##
cp -L /etc/resolv.conf /mnt/gentoo/etc/;
cp /root/SecCop/make.conf /mnt/gentoo/etc/portage/
cp /root/SecCop/package.use /mnt/gentoo/etc/portage/package.use/default
cp /root/SecCop/gentooMountainInstallChroot.sh /mnt/gentoo/
# tar vxfpj /root/SecCop/root.tar.bz2 -C /mnt/gentoo/root/


## Chroot ##
cp /root/SecCop/gentooMountainInstallChroot.sh /mnt/gentoo/
chmod +x /mnt/gentoo/gentooMountainInstallChroot.sh
chroot /mnt/gentoo ./gentooMountainInstallChroot.sh

## Finish ##
exit;
cd;
umount -l /mnt/gentoo/dev{/shm,/pts,};
umount -l /mnt/gentoo{/boot,/proc,};
