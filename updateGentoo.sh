#!/bin/bash
eix-sync;
emerge -vuDN --with-bdeps y --backtrack=90 --keep-going @world;
if test $(gcc-config -l | wc -l) -gt 1
then
    gcc-config $(gcc-config -l | wc -l);
    env-update && source /etc/profile;
    emerge --oneshot libtool;
    revdep-rebuild --library 'libstdc\+\+.so.6';
fi
perl-cleaner --all;
python-updater;
eselect kernel set $(eselect kernel list | tail -n +2 | wc -l); 
if test $(ls -l /usr/src/linux | cut -d'-' -f3-) = $(uname -a | cut -d' ' -f3)
then
    echo "You are using the last kernel installed.";
else
    echo "   Updating Kernel...";
    cd /usr/src/linux/;
    cp /root/kernel/.config /usr/src/linux/;
    make olddefconfig;
    make -j5 && make -j5 modules_install;
    emerge @module-rebuild;
    cp arch/x86_64/boot/bzImage /boot/kernel-$(ls -l /usr/src/linux | cut -d">" -f2 | cut -d"-" -f2)-gentoo;
    grub2-mkconfig -o /boot/grub/grub.cfg;
    sed 's/set timeout=5/set timeout=0/' /boot/grub/grub.cfg > /boot/grub/grub.cfg.new;
    mv /boot/grub/grub.cfg.new /boot/grub/grub.cfg;
fi
emerge -v --depclean;
revdep-rebuild;
eclean -d distfiles;
