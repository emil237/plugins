#!/bin/sh
#
TEMPATH=/tmp
OPKGINSTALL="opkg install --force-reinstall"
MY_IPK="enigma2-plugin-extensions-levi45iptv_all.ipk"
MY_DEB="enigma2-plugin-extensions-levi45iptv_all.deb"
PLUGIN_DIR="/usr/lib/enigma2/python/Plugins/Extensions/Levi45FreeIPTV"
STATUS_FILE="/var/lib/opkg/status"
PACKAGE_NAME="enigma2-plugin-extensions-levi45iptv"
PLUGIN_NAME="levi45-free-iptv"
URL="https://raw.githubusercontent.com/emil237/plugins/refs/heads/main/levi45-free-iptv"

if [ -d "$PLUGIN_DIR" ] || grep -q "$PACKAGE_NAME" "$STATUS_FILE" 2>/dev/null; then
    echo "> Removing old $PLUGIN_NAME plugin, please wait..."
    
    if grep -q "$PACKAGE_NAME" "$STATUS_FILE" 2>/dev/null; then
        opkg remove "$PACKAGE_NAME" > /dev/null 2>&1
    fi
    
    rm -rf "$PLUGIN_DIR" > /dev/null 2>&1
    
    echo "*******************************************"
    echo "* Removal Finished                        *"
    echo "*******************************************"
fi

if python3 --version >/dev/null 2>&1; then
    pyv="$(python3 -V 2>&1)"
elif python --version >/dev/null 2>&1; then
    pyv="$(python -V 2>&1)"
else
    pyv="Python not found"
fi

echo "$pyv"
echo "Checking Dependencies"
echo ""

if [ -d /etc/opkg ]; then
    opkg update > /dev/null 2>&1
    if echo "$pyv" | grep -q "Python 3"; then
        opkg install python3-requests --force-depends > /dev/null 2>&1
    else
        opkg install python-requests --force-depends > /dev/null 2>&1
    fi
else
    apt-get update > /dev/null 2>&1
    if echo "$pyv" | grep -q "Python 3"; then
        apt-get -y install python3-requests > /dev/null 2>&1
    else
        apt-get -y install python-requests > /dev/null 2>&1
    fi
fi

echo "> Downloading $PLUGIN_NAME package, please wait..."
cd $TEMPATH
set -e
INSTALL_OK=0

if which dpkg > /dev/null 2>&1; then
    echo "Using DEB package system..."
    wget -q "$URL/$MY_DEB"
    if dpkg -i --force-overwrite "$MY_DEB" 2>/dev/null; then
        apt-get install -f -y > /dev/null 2>&1
        INSTALL_OK=1
    else
        echo "DPKG installation failed"
    fi
    rm -f "$MY_DEB" > /dev/null 2>&1
else
    echo "Using IPK package system..."
    wget -q "$URL/$MY_IPK"
    if $OPKGINSTALL "$MY_IPK" 2>/dev/null; then
        INSTALL_OK=1
    else
        echo "OPKG installation failed"
    fi
    rm -f "$MY_IPK" > /dev/null 2>&1
fi

set +e
cd ..

if [ "$INSTALL_OK" = "1" ]; then
    echo "*******************************************"
    echo "*  SUCCESSFULLY INSTALLED                 *"
    echo "*******************************************"
else
    echo "*******************************************"
    echo "*  INSTALLATION FAILED                    *"
    echo "*******************************************"
    exit 1
fi

echo "********************************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
sleep 3
echo ". >>>>         RESTARTING     <<<<"
echo "**********************************************************************************"

if command -v systemctl > /dev/null 2>&1; then
    systemctl restart enigma2 > /dev/null 2>&1
elif command -v init > /dev/null 2>&1; then
    init 4 && sleep 2 && init 3
else
    killall -9 enigma2 > /dev/null 2>&1
fi

exit 0

