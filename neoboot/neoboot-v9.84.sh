#!/bin/bash
# ### wget -q --no-check-certificate https://github.com/emilnabil/neoboot/raw/refs/heads/main/neoboot-v9.84.sh -O - | /bin/sh
#####################
echo "Removing previous version ..."
sleep 2

if [ -d "/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot" ]; then
    rm -rf "/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo 'Package removed successfully.'
    else
        echo 'Failed to remove package.'
        exit 1
    fi
else
    echo "No previous version found."
fi

echo ""
echo "Updating opkg package list..."
opkg update > /dev/null 2>&1
sleep 1

echo "Installing curl if not present..."
if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    opkg install curl wget
    if [ $? -ne 0 ]; then
        echo "Failed to install curl/wget. Trying alternative..."
        
        opkg install curl || opkg install wget
        if [ $? -ne 0 ]; then
            echo "Failed to install download tools. Exiting."
            exit 1
        fi
    fi
else
    echo "Download tools already installed."
fi

sleep 2

cd /tmp || {
    echo "Failed to change directory to /tmp"
    exit 1
}

echo "Downloading NeoBoot package..."
DOWNLOAD_URL="https://github.com/emil237/plugins/raw/refs/heads/main/neoboot/neoboot-v9.84.tar.gz"
DOWNLOAD_FILE="/tmp/neoboot-v9.84.tar.gz"

rm -f "$DOWNLOAD_FILE" > /dev/null 2>&1

if command -v wget &> /dev/null; then
    wget -O "$DOWNLOAD_FILE" "$DOWNLOAD_URL" --timeout=30 --tries=3
    DOWNLOAD_RESULT=$?
elif command -v curl &> /dev/null; then
    curl -L "$DOWNLOAD_URL" -o "$DOWNLOAD_FILE" --connect-timeout 30 --retry 3
    DOWNLOAD_RESULT=$?
else
    echo "No download tool available. Exiting."
    exit 1
fi

if [ $DOWNLOAD_RESULT -ne 0 ]; then
    echo "Download failed. Exiting."
    rm -f "$DOWNLOAD_FILE" > /dev/null 2>&1
    exit 1
fi

sleep 1

if [ -f "$DOWNLOAD_FILE" ]; then
    FILE_SIZE=$(stat -c%s "$DOWNLOAD_FILE" 2>/dev/null || wc -c < "$DOWNLOAD_FILE" 2>/dev/null)
    if [ "$FILE_SIZE" -lt 1000 ]; then
        echo "Downloaded file is too small (may be empty). Exiting."
        rm -f "$DOWNLOAD_FILE"
        exit 1
    fi
    
    echo "Extracting package..."
    tar -xzf "$DOWNLOAD_FILE" -C /
    if [ $? -ne 0 ]; then
        echo "Extraction failed. Exiting."
        rm -f "$DOWNLOAD_FILE"
        exit 1
    fi
else
    echo "Downloaded file not found. Exiting."
    exit 1
fi

echo ""
echo ""
sleep 1

rm -f "$DOWNLOAD_FILE"
echo "Cleaned up temporary files."

echo ">>>>>>>>>> Uploaded By Emil Nabil <<<<<<<<<<"
sleep 2

if [ -d "/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot" ]; then
    echo "NeoBoot installation completed successfully!"
    echo "Please restart enigma2 to complete installation."
else
    echo "Warning: Installation may not have completed correctly."
    echo "Check if the directory exists: /usr/lib/enigma2/python/Plugins/Extensions/NeoBoot"
fi
reboot
exit 0


