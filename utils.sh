#! /bin/false

REPO_HOME=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

function distro_name {
    distro_id=$(cat /etc/os-release | grep "^ID=") 
    if [[ "${distro_id,,}" == "**debian**" ]]
    then
        return "debian"
    elif [[ "${distro_id,,}" == "**fedora**" ]]
    then
        return "fedora"
    fi

    distro_id_like=$(cat /etc/os-release | grep "^ID_LIKE=") 
    if [[ "${distro_id_like,,}" == "**debian**" ]]
    then
        return "debian"
    elif [[ "${distro_id_like,,}" == "**fedora**" ]]
    then
        return "fedora"
    else
        echo "Only supported distros are Debian, Fedora based distros"
        exit 1
    fi
}

MYUSER="$USER"
MYHOME="$HOME"
SUDOME="$( [ $UID == 0 ] && echo "" || echo "sudo -u $MYUSER" )"

DISTRO_LIKE=$(distro_name)
# package management related commands and variables
UPDATE="$( [[ $DISTRO_LIKE == "debian" ]] && "apt-get update" || [[ $DISTRO_LIKE == "fedora" ]] && "dnf upgrade" )"
INSTALL="$( [[ $DISTRO_LIKE == "debian" ]] && "apt-get install -y" || [[ $DISTRO_LIKE == "fedora" ]] && "dnf install -y" )"
REMOVE="$( [[ $DISTRO_LIKE == "debian" ]] && "apt-get remove -y" || [[ $DISTRO_LIKE == "fedora" ]] && "dnf remove -y" )"
AUTOREMOVE="$( [[ $DISTRO_LIKE == "debian" ]] && "apt-get autoremove -y" || [[ $DISTRO_LIKE == "fedora" ]] && "dnf autoremove -y" )"
PACKAGE_EXT="$( [[ $DISTRO_LIKE == "debian" ]] && "deb" || [[ $DISTRO_LIKE == "fedora" ]] && "rpm" )"

# distro specific files
DEPENDENCY_FILE="$REPO_HOME/distros/$DISTRO_LIKE/dependencies.txt"
PACKAGES_FILE="$REPO_HOME/distros/$DISTRO_LIKE/packages.txt"



