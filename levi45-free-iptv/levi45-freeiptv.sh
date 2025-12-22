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
URL="https://github.com/emil237/plugins/raw/refs/heads/main/levi45-free-iptv

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

pyv="$(python -V 2>&1)"
echo "$pyv"
echo "Checking Dependencies"
echo ""

if [ -d /etc/opkg ]; then
    opkg update
    case "$pyv" in
        *Python\ 3*) opkg install python3-requests ;;
        *) opkg install python-requests ;;
    esac
else
    apt-get update
    case "$pyv" in
        *Python\ 3*) apt-get -y install python3-requests ;;
        *) apt-get -y install python-requests ;;
    esac
fi

echo "> Downloading $PLUGIN_NAME package, please wait..."
cd $TEMPATH
set -e

if which dpkg > /dev/null 2>&1; then
    wget -q "$URL/$MY_DEB"
    if dpkg -i --force-overwrite $MY_DEB; then
        apt-get install -f -y
        INSTALL_OK=1
    fi
    rm -f $MY_DEB
else
    wget -q "$URL/$MY_IPK"
    if $OPKGINSTALL $MY_IPK; then
        INSTALL_OK=1
    fi
    rm -f $MY_IPK
fi

set +e
cd ..

if [ "$INSTALL_OK" = "1" ]; then
    echo ">>>>  SUCCESSFULLY INSTALLED <<<<"
else
    echo "!!!! INSTALLATION FAILED !!!!"
fi

echo "********************************************************************************"
echo "   UPLOADED BY  >>>>   EMIL_NABIL "   
sleep 3
echo ". >>>>         RESTARTING     <<<<"
echo "**********************************************************************************"

if command -v systemctl > /dev/null 2>&1; then
    systemctl restart enigma2
else
    init 4 && sleep 2 && init 3
fi

exit 0






