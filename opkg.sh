#!/bin/sh
# setup command:
# wget https://github.com/emil237/plugins/raw/refs/heads/main/opkg.sh -O - | /bin/sh
##################################################

IPK="/tmp/opkg-tools_all.ipk"
URL="https://raw.githubusercontent.com/emil237/plugins/main/opkg-tools_all.ipk"

echo "Downloading opkg-tools..."
wget -q --no-check-certificate "$URL" -O "$IPK"

if [ -f "$IPK" ]; then
    echo "Installing opkg-tools..."
    opkg install --force-overwrite "$IPK"

    echo "Cleaning up..."
    rm -f "$IPK"
else
    echo "Download failed!"
fi

sleep 2
exit 0


