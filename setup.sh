#!/bin/bash

MYUSER="moka"
MYHOME="/home/$MYUSER"
SUDOME="sudo -u $MYUSER"


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
rustup
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

echo "Install neovim AppImage"
$SUDOME curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage &&
    chmod u+x nvim.appimage && 
    mkdir -p /opt/nvim && 
    mv nvim.appimage /opt/nvim/nvim


echo "Creating stow symlinks"
for link in ${stowlinks}; do
	echo "Creating stow symlink for ${link}..."
	stow "$link" -t $MYHOME
done


echo "Getting plugins managers"
echo "Installing tmux-plugin-manager (tpm)... "
git clone --depth=1 https://github.com/tmux-plugins/tpm $MYHOME/.config/tmux/plugins/tpm
echo "done"

