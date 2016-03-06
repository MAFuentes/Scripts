#!/bin/bash
echo "Updating system:"
path=/var/log/updateGentoo/$(date +%y-%m-%d)_$(date +%H-%M-%S);
mkdir $path
echo "   Sync..."
eix-sync > $path/eix-sync.log 2>&1;
echo "   Emerge..."
emerge -vuDN --with-bdeps y --keep-going world > $path/emerge.log 2>&1;
echo "   Configuring..."
gcc-config $(gcc-config -l | wc -l) > $path/gcc-config.log 2>&1;
perl-cleaner --all > $path/perl-cleaner.log 2>&1;
python-updater > $path/python-updater.log 2>&1;
eselect kernel set $(eselect kernel list | tail -n +2 | wc -l); 
if test $(ls -l /usr/src/linux | cut -d'-' -f3-) = $(uname -a | cut -d' ' -f3)
then
    echo "You are using the last kernel installed." > $path/kernel.log;
else
echo "   Updating Kernel..."
    echo "Installing new kernel..." >> $path/kernel.log 2>&1;
    cd /usr/src/linux/ >> $path/kernel.log;
    cp /root/kernel/.config /usr/src/linux/;
    yes "" | make silentoldconfig >> $path/kernel.log 2>&1;
    make && make modules_install >> $path/kernel.log 2>&1;
    cp arch/x86_64/boot/bzImage /boot/kernel-$(ls -l /usr/src/linux | cut -d">" -f2 | cut -d"-" -f2)-gentoo;
    grub2-mkconfig -o /boot/grub/grub.cfg >> $path/kernel.log 2>&1;
    make modules_prepare >> $path/kernel.log 2>&1;
    emerge @module-rebuild >> $path/kernel.log 2>&1;
fi
echo "   Updating system configure files..."
etc-update -c > $path/etc-update.log 2>&1;
echo "   Delete old dependency package..."
emerge -v --depclean > $path/depclean.log 2>&1;
echo "   Update new dependency package..."
revdep-rebuild > $path/revdep-rebuild.log 2>&1;
echo "   Delete old package and sources..."
eclean -d distfiles > $path/eclean.log 2>&1;
echo "The update has finish. You can see the log on: $path"
