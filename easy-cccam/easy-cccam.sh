#!/bin/sh
#
PLUGIN_DIR="/usr/lib/enigma2/python/Plugins/Extensions/ECCcam"
STATUS_FILE="/var/lib/opkg/status"
PACKAGE_NAME="enigma2-plugin-extensions-ecccam"
PLUGIN_NAME="easy-cccam"
URL="https://github.com/emil237/plugins/raw/refs/heads/main/easy-cccam/easy-cccam.tar.gz"
DOWNLOAD_PATH="/var/volatile/tmp/$PLUGIN_NAME.tar.gz"

# 
if [ -d "$PLUGIN_DIR" ]; then
    echo "> Removing old ECCcam plugin, please wait..."
    rm -rf "$PLUGIN_DIR" > /dev/null 2>&1

    # #
    if grep -q "$PACKAGE_NAME" "$STATUS_FILE"; then
        opkg remove "$PACKAGE_NAME" > /dev/null 2>&1
    fi

    echo "*******************************************"
    echo "* Removal Finished                        *"
    echo "*******************************************"
fi
# 
echo "> Downloading $PLUGIN_NAME package, please wait..."
sleep 1
wget -O "$DOWNLOAD_PATH" --no-check-certificate "$URL"

# 
tar -xzf "$DOWNLOAD_PATH" -C /
EXTRACT_STATUS=$?
rm -rf "$DOWNLOAD_PATH" > /dev/null 2>&1
echo ""

if [ $EXTRACT_STATUS -eq 0 ]; then
    echo "> $PLUGIN_NAME package installed successfully"
    sleep 2
else
    echo "> $PLUGIN_NAME package installation failed"
fi

exit 0


