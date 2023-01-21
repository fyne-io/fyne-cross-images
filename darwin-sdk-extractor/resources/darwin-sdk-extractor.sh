#!/bin/sh
set -e

arg="Command_Line_Tools*.dmg"
if [ -n "$1" ]; then
    arg=$1
fi

dmg="/mnt/$1"

cd /tmp
7z e -so $dmg 'Command Line Developer Tools/Command Line Tools*.pkg' > pkg
xar -xf pkg
mkdir out
for pkg in `ls -1 *.pkg/Payload`; do 
    pbxz -n $pkg | cpio -i -D out; 
done

mv /tmp/out/Library/Developer/CommandLineTools/SDKs /mnt/SDKs
