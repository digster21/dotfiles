#!/usr/bin/env bash

set -e





if [[ "$(uname -m)" == "x86_64" ]]; then
    wget "https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb"

    echo "Installed J-Link (x86_64)"
    exit 0
fi

echo "J-Link installation not supported"
