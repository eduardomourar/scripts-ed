#!/bin/bash
clear

destination=~/Desktop/Mac\ OS\ X\ Install\ DVD

#make destination folder
[ ! -d "$destination" ] && mkdir "$destination"

#make sure disc is in drive
while [ ! -d /Volumes/Mac\ OS\ X\ Install\ DVD ] ; do
echo Please insert Mac OS X Install DVD and press Enter
read
done

#get device node for block copy
device=$(diskutil info /Volumes/Mac\ OS\ X\ Install\ DVD/ | grep Node | cut -f2 -d:)

#create disk image from device (retains Finder window custom background)
echo "Creating Disc image at $destination, please wait..."
/usr/bin/hdiutil create -srcdevice $device -format UDRW "$destination"/Mac\ OS\ X\ Install\ DVD.dmg
#disk image using source folder (loses custom Finder background)
#/usr/bin/hdiutil create -srcfolder /Volumes/Mac\ OS\ X\ Install\ DVD/ -format UDRW "$destination"/Mac\ OS\ X\ Install\ DVD.dmg

#eject media
/usr/bin/drutil eject

#tell user to take out disc
echo -e $'\a'$'\a'$'\a'$'\n'"Please Remove the disc and press Enter"$'\n'
read

echo "Modifying Image"
#mount r/w image
hdiutil attach "$destination"/Mac\ OS\ X\ Install\ DVD.dmg
#expand OSINstall.mpkg
/usr/sbin/pkgutil --expand /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.mpkg /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.expanded
#modify Distribution script in place with no backup
/usr/bin/sed -i '' "s/modelProp\ \=\=\ hwbeSupportedMachines\[i\]/1/g" /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.expanded/Distribution

#modify Distribution script in place with backup (for sissies)
#/usr/bin/sed -i '.original' "s/modelProp\ \=\=\ hwbeSupportedMachines\[i\]/1/g" /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.expanded/Distribution

#remove original OSInstall.mpkg package
/bin/rm -rf /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.mpkg

#flatten new package
/usr/sbin/pkgutil --flatten /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.expanded /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.mpkg

#remove expanded folder
/bin/rm -rf /Volumes/Mac\ OS\ X\ Install\ DVD/System/Installation/Packages/OSInstall.expanded

### image is now ready to be burned ###

#eject disk image
hdiutil eject /Volumes/Mac\ OS\ X\ Install\ DVD/

#burn disc image
/usr/bin/drutil burn "$destination"/Mac\ OS\ X\ Install\ DVD.dmg

echo -e $'\a'$'\a'$'\a'$'\n'"Disc Complete, Please Remove the disc"$'\n'
