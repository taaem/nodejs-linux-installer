#!/bin/bash

echo "IoJS Linux Installer by www.github.com/taaem"
echo "Need Root for installing iojs"
sudo sh -c 'echo "Got Root!"' 

echo "Get Latest Version Number..."
{
wget --output-document=iojs-updater.html https://iojs.org/dist/latest/

ARCH=$(uname -m)

if [ $ARCH = x86_64 ]
then
	grep -o '>iojs-v.*-linux-x64.tar.gz' iojs-updater.html > iojs-cache.txt 2>&1

	VER=$(grep -o 'iojs-v.*-linux-x64.tar.gz' iojs-cache.txt)
else
	grep -o '>iojs-v.*-linux-x86.tar.gz' iojs-updater.html > iojs-cache.txt 2>&1
	
	VER=$(grep -o 'iojs-v.*-linux-x86.tar.gz' iojs-cache.txt)
fi
rm ./iojs-cache.txt
rm ./iojs-updater.html
} &> /dev/null

echo "Done"

DIR=$( cd "$( dirname $0 )" && pwd )

echo "Downloading latest stable Version $VER..."
{
wget https://iojs.org/dist/latest/$VER -O $DIR/$VER
} &> /dev/null

echo "Done"

echo "Installing..."
cd /usr/local && sudo tar --strip-components 1 -xzf $DIR/$VER

rm $DIR/$VER

echo "Finished installing!"
