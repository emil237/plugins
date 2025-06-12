#!/bin/sh
#
cd /tmp

rm -rf /dev/null 2>&1

rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPTV_Checker

wget -O /var/volatile/tmp/ip_checker_all.ipk "https://raw.githubusercontent.com/emil237/plugins/main/ip_checker_all.ipk"

sleep 1

opkg install --force-overwrite /var/volatile/tmp/*.ipk

sleep 1

rm -rf /var/volatile/tmp/ip_checker_all.ipk

echo ">>>UPLOADDED BY EMIL_NABIL <<<"

sleep 2

killall -9 enigma2

exit 0

