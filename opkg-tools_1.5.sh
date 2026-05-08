#!/bin/bash
##Command=wget https://github.com/emil237/plugins/raw/refs/heads/main/opkg-tools_1.5.sh -O - | /bin/sh 
#######################
# Download and extract the package
cd /tmp || exit
curl -k -Lbk --max-time 55532 --connect-timeout 555104 "https://github.com/emil237/plugins/raw/refs/heads/main/opkg-tools_1.5.tar.gz" -o /tmp/opkg-tools_1.5.tar.gz
sleep 1
echo "Installing ...."
tar -xzf /tmp/opkg-tools_1.5.tar.gz -C /
echo ""
echo ""
sleep 1
rm -f /tmp/opkg-tools_1.5.tar.gz
sleep 2

BASE="/media/hdd/ipkg-tools"

if [ -d "$BASE" ]; then
    chmod -R 755 "$BASE/"
else
    echo "Warning: Directory $BASE does not exist"
    exit 1
fi

if [ -f "$BASE/ar" ]; then
    ln -sfn "$BASE/ar" /usr/bin/ar 2>/dev/null || ln -sfn "$BASE/ar" /bin/ar 2>/dev/null
fi

if [ -f "$BASE/debian-binary" ]; then
    ln -sfn "$BASE/debian-binary" /usr/bin/debian-binary 2>/dev/null || ln -sfn "$BASE/debian-binary" /bin/debian-binary 2>/dev/null
fi

if [ -f "$BASE/ipkg-build" ]; then
    ln -sfn "$BASE/ipkg-build" /usr/bin/ipkg-build 2>/dev/null || ln -sfn "$BASE/ipkg-build" /bin/ipkg-build 2>/dev/null
    ln -sfn "$BASE/ipkg-build" /usr/bin/opkg-build 2>/dev/null || ln -sfn "$BASE/ipkg-build" /bin/opkg-build 2>/dev/null
    ln -sfn "$BASE/ipkg-build" /usr/bin/maak 2>/dev/null || ln -sfn "$BASE/ipkg-build" /bin/maak 2>/dev/null
    ln -sfn "$BASE/ipkg-build" /usr/bin/pack 2>/dev/null || ln -sfn "$BASE/ipkg-build" /bin/pack 2>/dev/null
fi

if [ -f "$BASE/ipkg-unbuild" ]; then
    ln -sfn "$BASE/ipkg-unbuild" /usr/bin/ipkg-unbuild 2>/dev/null || ln -sfn "$BASE/ipkg-unbuild" /bin/ipkg-unbuild 2>/dev/null
    ln -sfn "$BASE/ipkg-unbuild" /usr/bin/opkg-unbuild 2>/dev/null || ln -sfn "$BASE/ipkg-unbuild" /bin/opkg-unbuild 2>/dev/null
    ln -sfn "$BASE/ipkg-unbuild" /usr/bin/pakuit 2>/dev/null || ln -sfn "$BASE/ipkg-unbuild" /bin/pakuit 2>/dev/null
    ln -sfn "$BASE/ipkg-unbuild" /usr/bin/unpack 2>/dev/null || ln -sfn "$BASE/ipkg-unbuild" /bin/unpack 2>/dev/null
fi

echo "Installation completed successfully"
sleep 3 
exit 0

