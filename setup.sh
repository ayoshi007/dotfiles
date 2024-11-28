#!/bin/bash

. ./utils.sh

echo "User ${MYUSER} running setup.sh"
echo "Home directory ${MYHOME}"
echo "Sudo me: ${SUDOME}"
yes_or_none "Proceed?" || exit 1

echo "Updating apt"
sudo apt update

echo "Installing dependencies"
sudo apt install -y $(cat dependencies.txt)

echo "Installing packages"
sudo apt install -y $(cat packages.txt)

if yes_or_none "Stow adopt home config to ${MYHOME}?" ; then
    sudo stow --adopt home -t "${MYHOME}"
    echo "Done"
    yes_or_none "Restore source controlled configs?" && git restore ./home && echo "Done"
fi

yes_or_none "Install other applications?" && ./install_other.sh

echo "Cleaning up with apt autoremove"
sudo apt autoremove -y

yes_or_none "Reboot?" && reboot
echo "Reboot machine to finish"
