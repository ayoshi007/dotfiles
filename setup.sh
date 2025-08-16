#!/bin/bash

. ./utils.sh
. ./install_other.sh

function usage() {
    cat <<EOF
Usage: ./setup.sh [-y] [-h]
    -y - skip yes or no prompts
    -h - print usage and exit
EOF
}

while getopts "yh" flag
do
    case $flag in
        y)
            _UTILS_SKIP_YESNO=1
        ;;
        h)
            usage
            exit
        ;;
    esac
done

echo "User ${MYUSER} running setup.sh"
echo "Home directory ${MYHOME}"
echo "Sudo me: ${SUDOME}"
yes_or_none "Proceed?" ${_UTILS_SKIP_YESNO} || exit 1

echo "Updating apt"
$SUDOME apt update

echo "Installing dependencies"
$SUDOME apt install -y $(cat dependencies.txt)

echo "Installing packages"
$SUDOME apt install -y $(cat packages.txt)

if yes_or_none "Stow adopt home config to ${MYHOME}?" ; then
    $SUDOME stow --adopt home -t "${MYHOME}"
    echo "Done"
    yes_or_none "Restore source controlled configs?" && git restore ./home && echo "Done"
fi

yes_or_none "Install other applications?" && install_others

echo "Cleaning up with apt autoremove"
$SUDOME apt autoremove -y

yes_or_none "Reboot?" && reboot
echo "Reboot machine to finish"
