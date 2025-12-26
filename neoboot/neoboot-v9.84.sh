#!/bin/bash
# ### wget -q --no-check-certificate https://github.com/emilnabil/neoboot/raw/refs/heads/main/neoboot-v9.84.sh -O - | /bin/sh
#####################
echo " SCRIPT : DOWNLOAD AND INSTALL NEOBOOT "
# ###########################################
NEOBOOT='v9.84'
###########################################
# Configure where we can find things here #
MY_EM="*****************************************************************************************************"
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot'
##########################################
REQUIRED='/usr/lib/enigma2/python/Plugins/Extensions/NeoBoot/files'
##########################################
TOOLS='/usr/lib/enigma2/python/Tools'
PREDION='/usr/lib/periodon'
##########################################
PYTHON_VERSION=$(python -c "import platform; print(platform.python_version())")

###########################################

# remove old version
if [ -d $PLUGINPATH ]; then
   rm -rf $PLUGINPATH 
fi

# Python Version Check #
if python --version 2>&1 | grep -q '^Python 3\.'; then
   echo "You have Python3 image"
   PYTHON='PY3'
else
   echo "You have Python2 image"
   PYTHON='PY2'
fi
#########################

VERSION=$NEOBOOT

#######################################
if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install --force-overwrite --force-reinstall'
elif [ -f /etc/apt/apt.conf ]; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
fi

#########################
case $(uname -m) in
armv7l*) platform="armv7" ;;
mips*) platform="mipsel" ;;
aarch64*) platform="ARCH64" ;;
sh4*) platform="sh4" ;;
esac

#########################
install() {
    if ! grep -qs "Package: $1" $STATUS; then
        $OPKG >/dev/null 2>&1
        echo "   >>>>   Need to install $1   <<<<"
        echo
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGINSTAL "$1"
            sleep 1
            clear
        fi
    fi
}

#########################
if [ $PYTHON = "PY3" ]; then
    for i in kernel-module-nandsim mtd-utils-jffs2 lzo python-setuptools util-linux-sfdisk packagegroup-base-nfs ofgwrite bzip2 mtd-utils mtd-utils-ubifs; do
        install $i
    done
else
    for i in kernel-module-nandsim mtd-utils-jffs2 lzo python-setuptools util-linux-sfdisk packagegroup-base-nfs ofgwrite bzip2 mtd-utils mtd-utils-ubifs; do
        install $i
    done
fi

#########################
clear
sleep 5
opkg update
echo "   UPLOADED BY  >>>>   EMIL_NABIL " 
sleep 4
echo "***********************************************************************"
echo "***********************************************************************"

cd /tmp
set -e                                      
wget -O /var/volatile/tmp/neoboot-v9.84.tar.gz "https://github.com/emilnabil/neoboot/raw/refs/heads/main/neoboot-v9.84.tar.gz"
sleep 3
tar -xzf neoboot-v9.84.tar.gz  -C /
cd ..
set +e
rm -f /var/volatile/tmp/neoboot-v9.84.tar.gz

#########################
clear
cd $PLUGINPATH
chmod 755 ./bin/*
chmod 755 ./ex_init.py
chmod 755 ./files/*.sh
chmod -R +x ./ubi_reader_arm/*
chmod -R +x ./ubi_reader_mips/*

#########################
echo ""
echo "***********************************************************************"
echo $MY_EM                                                     
echo "**                       NeoBoot  : $VERSION                          *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ". >>>>         RESTARING     <<<<"
echo ""
if [ $OSTYPE = 'DreamOS' ]; then
    systemctl restart enigma2
else
    init 6
fi
exit 0



