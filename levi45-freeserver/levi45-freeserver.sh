#!/bin/sh
#
PLUGIN_DIR="/usr/lib/enigma2/python/Plugins/Extensions/Levi45FreeServer"
STATUS_FILE="/var/lib/opkg/status"
PACKAGE_NAME="enigma2-plugin-extensions-levi45-freeserver"
PLUGIN_NAME="levi45-freeserver"
URL="https://github.com/emil237/plugins/raw/refs/heads/main/levi45-freeserver/levi45-freeserver.tar.gz"
DOWNLOAD_PATH="/var/volatile/tmp/$PLUGIN_NAME.tar.gz"

# إزالة النسخة القديمة إن وُجدت
if [ -d "$PLUGIN_DIR" ]; then
    echo "> Removing old $PLUGIN_NAME plugin, please wait..."
    rm -rf "$PLUGIN_DIR" > /dev/null 2>&1

    if grep -q "$PACKAGE_NAME" "$STATUS_FILE"; then
        opkg remove "$PACKAGE_NAME" > /dev/null 2>&1
    fi

    echo "*******************************************"
    echo "* Removal Finished                        *"
    echo "*******************************************"
fi

# التحقق من إصدار بايثون
pyv="$(python -V 2>&1)"
echo "$pyv"
echo "Checking Dependencies"
echo ""
echo "Updating feeds..."
if [ -d /etc/opkg ]; then
    opkg update
    echo ""

    case "$pyv" in
        *Python\ 3*)
            echo "Checking python3-requests"
            if python -c "import requests" 2>/dev/null; then
                echo "Requests library already installed"
            else
                opkg install python3-requests
            fi
            ;;
        *)
            echo "Checking python-requests"
            if python -c "import requests" 2>/dev/null; then
                echo "Requests library already installed"
            else
                opkg install python-requests
            fi
            ;;
    esac

else
    apt-get update
    echo ""

    case "$pyv" in
        *Python\ 3*)
            echo "Checking python3-requests"
            if python -c "import requests" 2>/dev/null; then
                echo "Requests library already installed"
            else
                apt-get -y install python3-requests
            fi
            ;;
        *)
            echo "Checking python-requests"
            if python -c "import requests" 2>/dev/null; then
                echo "Requests library already installed"
            else
                apt-get -y install python-requests
            fi
            ;;
    esac
fi

# تحميل وتثبيت البلجن
echo "> Downloading $PLUGIN_NAME package, please wait..."
sleep 1
wget -O "$DOWNLOAD_PATH" --no-check-certificate "$URL"

tar -xzf "$DOWNLOAD_PATH" -C /
EXTRACT_STATUS=$?
rm -f "$DOWNLOAD_PATH" > /dev/null 2>&1
echo ""

if [ "$EXTRACT_STATUS" -eq 0 ]; then
    echo "> $PLUGIN_NAME package installed successfully"
    sleep 2
else
    echo "> $PLUGIN_NAME package installation failed"
fi

exit 0


