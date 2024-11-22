function yes_or_none {
    read -p "$* [y/(n)]: " yn
    case $yn in
	[yY]*) return 0 ;;
    esac
    return 1
}

MYUSER="$SUDO_USER"
MYHOME="/home/$MYUSER"
SUDOME="sudo -u $MYUSER"
