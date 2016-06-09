#!/bin/bash

echo "Node Linux Installer by www.github.com/taaem"
if [[ $EUID -ne 0 ]]; then
    echo "Need Root for installing NodeJS"
    sudo sh -c 'echo "Got Root!"' 
else
    echo "Running as Root User"
fi

echo "Get Latest Version Number..."

node_latest=$(curl http://nodejs.org/dist/latest/ 2>/dev/null)
if [[ ! $node_latest ]]
    then
        echo "ERROR: No Internet Connection" >&2
        exit 1
fi

ARCH=$(uname -m)

if [ $ARCH = arm64 ] || [ $ARCH = aarch64 ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-arm64.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-arm64.tar.gz') 

    elif [ $ARCH = armv6l ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-armv6l.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-armv6l.tar.gz') 

    elif [ $ARCH = armv7l ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-armv7l.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-armv7l.tar.gz') 
        
    elif [ $ARCH = x86_64 ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-x64.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-x64.tar.gz') 

    else
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-x86.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-x86.tar.gz') 
fi

echo "Done"

echo "Downloading latest stable Version $VER..."

URL=http://nodejs.org/dist/latest/$VER
FILE_PATH=/tmp/node.tar.gz

curl -o $FILE_PATH $URL 2>/dev/null
exit_status=$(echo "$?")
if [[ $exit_status -ne "0" ]]
    then
        echo "ERROR: Target tar not found"
        exit $exit_status
fi

echo "Done"

echo "Installing..."
cd /usr/local && sudo tar --strip-components 1 -xzf /tmp/node.tar.gz
exit_status=$(echo "$?")
if [[ $exit_status -ne "0" ]]
    then
        echo "ERROR: Couldn't extract tar"
        exit $exit_status
fi

rm $FILE_PATH

echo "Finished installing!"
exit 0
