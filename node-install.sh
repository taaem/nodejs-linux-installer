#!/bin/bash

echo 'Node Linux Installer by www.github.com/taaem'
if [[ $EUID -ne 0 ]]
    then
        echo 'Need root for installing NodeJS'
        sudo sh -c 'echo "Got root!"'
    else
        echo 'Running as root user'
fi

ARCH=$(uname -m)
echo "Getting latest stable version for $ARCH ..."
URL='https://nodejs.org/dist/'
if [[ $ARCH == 'arm64' || $ARCH == 'aarch64' ]]
    then
        URL+='latest/'
        NAME=$(curl -sf "$URL" | grep -o '>node-v.*-linux-arm64.tar.gz')
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-arm64.tar.gz')

    elif [[ $ARCH == 'armv6l' ]]
    then
        URL+='latest-v11.x/'
        NAME=$(curl -sf "$URL" | grep -o '>node-v.*-linux-armv6l.tar.gz')
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-armv6l.tar.gz')

    elif [[ $ARCH == 'armv7l' ]]
    then
        URL+='latest/'
        NAME=$(curl -sf "$URL" | grep -o '>node-v.*-linux-armv7l.tar.gz')
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-armv7l.tar.gz')

    elif [[ $ARCH == 'x86_64' ]]
    then
        URL+='latest/'
        NAME=$(curl -sf "$URL" | grep -o '>node-v.*-linux-x64.tar.gz')
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-x64.tar.gz')

    else
        URL+='latest-v9.x/'
        NAME=$(curl -sf "$URL" | grep -o '>node-v.*-linux-x86.tar.gz')
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-x86.tar.gz')
fi
if [[ ! $VER ]]
    then
        echo "ERROR: Failed to find latest stable version for $ARCH" >&2
        exit 1
fi
echo "Found latest stable version for $ARCH: $VER"

URL+="$VER"
echo "Downloading $URL ..."
FILE_PATH='/tmp/node.tar.gz'
curl -fo "$FILE_PATH" "$URL"
exit_status=$?
if [[ $exit_status -ne 0 ]]
    then
        echo "ERROR: Failed to download $URL" >&2
        exit $exit_status
fi
echo 'Finished downloading!'

echo "Installing $FILE_PATH ..."
cd /usr/local && sudo tar --strip-components 1 -xzf "$FILE_PATH"
exit_status=$?
if [[ $exit_status -ne 0 ]]
    then
        echo "ERROR: Failed to extract $FILE_PATH" >&2
        exit $exit_status
fi
rm "$FILE_PATH"
echo 'Finished installing!'

exit 0
