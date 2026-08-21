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
    distro_id=$(cat /etc/os-release | grep "^ID=" | tr '[:upper:]' '[:lower:]') 
    if [[ "${distro_id}" == *"debian"* ]]
    then
        echo "debian"
        return 0
    elif [[ "${distro_id}" == *"fedora"* ]]
    then
        echo "fedora"
        return 0
    fi

    distro_id_like=$(cat /etc/os-release | grep "^ID_LIKE=" | tr '[:upper:]' '[:lower:]') 
    if [[ "${distro_id_like}" == *"debian"* ]]
    then
        echo "debian"
        return 0
    elif [[ "${distro_id_like}" == *"fedora"* ]]
    then
        echo "fedora"
        return 0
    else
        echo "Only supported distros are Debian, Fedora based distros"
        exit 1
    fi
}

MYUSER="$USER"
MYHOME="$HOME"
SUDOME="$( [ "$UID" == 0 ] && echo "" || echo "sudo -u $MYUSER" )"

DISTRO_LIKE=$(distro_name)
# package management related commands and variables
UPDATE="$( [[ $DISTRO_LIKE == "debian" ]] && echo "apt-get update -y" || [[ $DISTRO_LIKE == "fedora" ]] && echo "dnf upgrade -y" )"
INSTALL="$( [[ $DISTRO_LIKE == "debian" ]] && echo "apt-get install -y" || [[ $DISTRO_LIKE == "fedora" ]] && echo "dnf install -y" )"
REMOVE="$( [[ $DISTRO_LIKE == "debian" ]] && echo "apt-get remove -y" || [[ $DISTRO_LIKE == "fedora" ]] && echo "dnf remove -y" )"
AUTOREMOVE="$( [[ $DISTRO_LIKE == "debian" ]] && echo "apt-get autoremove -y" || [[ $DISTRO_LIKE == "fedora" ]] && echo "dnf autoremove -y" )"
PACKAGE_EXT="$( [[ $DISTRO_LIKE == "debian" ]] && echo "deb" || [[ $DISTRO_LIKE == "fedora" ]] && echo "rpm" )"

# distro specific files
DISTRO_FOLDER="$REPO_HOME/distros/$DISTRO_LIKE"
DEPENDENCIES_FILE="$REPO_HOME/distros/$DISTRO_LIKE/dependencies.txt"
PACKAGES_FILE="$REPO_HOME/distros/$DISTRO_LIKE/packages.txt"
INSTALL_OTHER_SCRIPT="$REPO_HOME/distros/$DISTRO_LIKE/install_other.sh"

