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

function populate_variables {
    distro_like=$1
    case "$distro_like" in
        debian)
            cat <<EOF
apt-get update -y
apt-get install -y
apt-get remove -y
apt-get autoremove -y
deb
$REPO_HOME/distros/$distro_like
$REPO_HOME/distros/$distro_like/dependencies.txt
$REPO_HOME/distros/$distro_like/packages.txt
$REPO_HOME/distros/$distro_like/install_other.sh
EOF
        ;;
        fedora)
            cat <<EOF
dnf install -y
dnf remove -y
dnf autoremove -y
rpm
$REPO_HOME/distros/$distro_like
$REPO_HOME/distros/$distro_like/dependencies.txt
$REPO_HOME/distros/$distro_like/packages.txt
$REPO_HOME/distros/$distro_like/install_other.sh
EOF
        ;;
        *)
            echo "Only supported distros are Debian, Fedora based distros"
            exit 1
            ;;
    esac
}

MYUSER="$USER"
MYHOME="$HOME"
SUDOME="$( [ "$UID" == 0 ] && echo "" || echo "sudo -u $MYUSER" )"

DISTRO_LIKE=$(distro_name)
# package management related commands and variables
readarray -t vars <<< $(populate_variables ${DISTRO_LIKE})
UPDATE="${vars[0]}"
INSTALL="${vars[1]}"
REMOVE="${vars[2]}"
AUTOREMOVE="${vars[3]}"
PACKAGE_EXT="${vars[4]}"
DISTRO_FOLDER="${vars[5]}"
DEPENDENCIES_FILE="${vars[6]}"
PACKAGES_FILE="${vars[7]}"
INSTALL_OTHER_SCRIPT="${vars[8]}"

