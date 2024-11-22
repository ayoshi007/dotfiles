#!/bin/bash

. ./utils.sh

echo "User ${MYUSER} running setup.sh as superuser"
echo "Home directory ${MYHOME}"
echo "Sudo me: ${SUDOME}"
yes_or_none "Proceed?" || exit 1

echo "Updating APT"
apt update

echo "Installing dependencies"
apt install -y $(cat dependencies.txt)

echo "Installing packages"
apt install -y $(cat packages.txt)

if yes_or_none "Stow adopt home config to ${MYHOME}?" ; then
    stow --adopt home -t "${MYHOME}"
    echo "Done"
    yes_or_none "Restore source controlled configs?" && git restore . && echo "Done"
fi

yes_or_none "Install other applications?" && ./install_other.sh

echo "Cleaning up with apt autoremove"
apt autoremove -y

yes_or_none "Reboot?" && reboot
echo "Reboot machine to finish"
