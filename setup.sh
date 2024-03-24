#!/bin/bash

# run script as superuser
# apt -y install stow
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
files="
bash
neovim
vim 
tmux
git
"

echo "Installing dependencies"
apt update && apt install -y ${deps}

echo "Install packages"
apt update && DEBIAN_FRONTEND=noninteractivate apt install -y ${packages}

echo "Install neovim AppImage"
curl -LO https://github.com/neovim/neovim/releases/stable/download/nvim.appimage
chmod u+x nvim.appimage
mkdir -p /opt/nvim
mv nvim.appimage /opt/nvim/nvim


# back up and make stow symlinks for files
for file in ${files}; do
	echo "Creating stow symlink for ${file}..."
	# stow "$file" -t ~
done


echo "Getting plugins managers"
# tmux plugin manager
echo "Installing tmux-plugin-manager (tpm)... "
#git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
echo "done"



