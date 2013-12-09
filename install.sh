#!/bin/bash
# Basic installation script for Snoopy NG requirements
# glenn@sensepost.com // @glennzw
# Todo: Make this an egg.
set -e

apt-get install ntpdate --force-yes --yes
echo "[+] Setting time with ntp"
ntpdate ntp.ubuntu.com 
echo "[+] Setting timzeone..."
echo "Etc/UTC" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo "[+] Installing sakis3g..."
cp ./includes/sakis3g /usr/local/bin

echo "[+] Updating repository..."
apt-get update

# Packages
echo "[+] Installing required packages..."
apt-get install --force-yes --yes python-setuptools autossh python-psutil python2.7-dev libpcap0.8-dev python-sqlalchemy ppp tcpdump python-serial sqlite3 python-requests iw build-essential python-bluez python-flask python-gps python-dateutil 

# Python packages

easy_install pip
easy_install smspdu

pip uninstall requests -y
pip install -Iv https://pypi.python.org/packages/source/r/requests/requests-0.14.2.tar.gz   #Wigle API built on old version
pip install httplib2
pip install BeautifulSoup
pip install publicsuffix

# Download & Installs
echo "[+] Installing pyserial 2.6"
pip install https://pypi.python.org/packages/source/p/pyserial/pyserial-2.6.tar.gz

echo "[+] Downloading pylibpcap..."
pip install http://switch.dl.sourceforge.net/project/pylibpcap/pylibpcap/0.6.4/pylibpcap-0.6.4.tar.gz

echo "[+] Downloading dpkt..."
pip install http://dpkt.googlecode.com/files/dpkt-1.8.tar.gz

echo "[+] Installing patched version of scapy..."
pip install ./setup/scapy-latest-snoopy_patch.tar.gz

# Only run this on your client, not server:
read -r -p  "[ ] Do you want to download, compile, and install aircrack? [y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then

    echo "[+] Downloading aircrack-ng..."
    wget http://download.aircrack-ng.org/aircrack-ng-1.2-beta1.tar.gz
    tar xzf aircrack-ng-1.2-beta1.tar.gz
    cd aircrack-ng-1.2-beta1
    make
    echo "[-] Installing aircrack-ng"
    make install
    cd ..
    rm -rf aircrack-ng-1.2-beta1*
fi


ln -s `pwd`/transforms /etc/transforms
ln -s `pwd`/snoopy.py /usr/bin/snoopy
chmod +x /usr/bin/snoopy
