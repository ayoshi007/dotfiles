#!/bin/bash

MYUSER="$SUDO_USER"
MYHOME="/home/$MYUSER"
SUDOME="sudo -u $MYUSER"

echo "User ${MYUSER} running setup.sh as superuser"

# run script as superuser
deps="
bash
curl
git
stow
"
packages="
bash
bash-completion
bear
cmake
curl
fzf
golang
git
htop
jq
lua5.4
luajit
luarocks
nmap
python3
python3-pip
ripgrep
stow
tmux
tree
zsh
zsh-syntax-highlighting
"
stowlinks="
bash
neovim
vim 
tmux
git
"

echo "Installing dependencies"
apt update &&
    apt install -y ${deps}

echo "Install packages"
apt update &&
    apt install -y ${packages}

echo "Install neovim"
rm -rf /opt/nvim-linux64
$SUDOME curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz
sudo mv nvim-linux64 /opt
rm nvim-linux64.tar.gz

echo "Creating stow symlinks"
for link in ${stowlinks}; do
	echo "Creating stow symlink for ${link}..."
	stow "$link" -t $MYHOME
done

echo "Make zsh default shell"
chsh -s $(which zsh)

echo "Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# echo "Installing rustup"
# curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | $SUDOME sh -s -- --default-toolchain stable --profile default

echo "Getting plugins managers"
echo "Installing tmux-plugin-manager (tpm)... "
git clone --depth=1 https://github.com/tmux-plugins/tpm $MYHOME/.config/tmux/plugins/tpm
echo "done"

echo "Cleaning up with apt autoremove"
apt autoremove -y

function yes_or_none {
    read -p "$* [y/(n)]: " yn
    case $yn in
	[yY]*) return 0 ;;
    esac
    return 1
}

yes_or_none "Reboot?" && reboot
echo "Reboot machine to finish set up"

