function yes_or_none {
    if [[ -v _UTILS_SKIP_YESNO ]]
    then
        return 0
    fi
    read -p "$1 [y/(n)]: " yn
    case $yn in
	[yY]*) return 0 ;;
    esac
    return 1
}

MYUSER="$USER"
MYHOME="/home/$MYUSER"
SUDOME=$([ $MYUSER == "root" ] && echo "" || echo "sudo -u $MYUSER" )
