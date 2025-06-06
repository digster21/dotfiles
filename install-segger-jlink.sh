#!/usr/bin/env bash

set -e

JLINK_DEB="SEGGER_JLink.deb"

if [[ "$(uname -m)" == "x86_64" ]]; then
    wget -o "$JLINK_DEB" "https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb"

    sudo dpkg -i "$JLINK_DEB"

    sudo apt-get install -f -y

    rm "$JLINK_DEB"

    if command -v JLinkExe >/dev/null 2>&1; then    
        echo "Installed J-Link (x86_64)"
    else
        echo "J-Link installation failed: JLinkExe not found"
    fi
else
    echo "J-Link installation not supported"
fi

