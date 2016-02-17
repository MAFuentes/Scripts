#!/bin/bash
eix-sync &&
emerge -avuDN --with-bdeps y --keep-going world &&
gcc-config $(gcc-config -l | wc -l) &&
perl-cleaner --all &&
python-updater &&
eselect kernel set $(eselect kernel list | tail -n +2 | wc -l) &&
if test $(ls -l /usr/src/linux | cut -d'-' -f3-) = $(uname -a | cut -d' ' -f3)
then
    echo "You are using the last kernel installed."
else
    echo "Installing new kernel..."
    cd /usr/src/linux/
    cp /root/kernel/.config /usr/src/linux/
    yes "" | make silentoldconfig
    make && make modules_install;
    cp arch/x86_64/boot/bzImage /boot/kernel-$(ls -l /usr/src/linux | cut -d">" -f2 | cut -d"-" -f2)-gentoo;
    grub2-mkconfig -o /boot/grub/grub.cfg;
    make modules_prepare
    emerge @module-rebuild    
fi &&
dispatch-conf &&
emerge -av --depclean &&
revdep-rebuild &&
eclean -d distfiles
