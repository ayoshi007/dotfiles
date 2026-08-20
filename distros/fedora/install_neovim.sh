#!/bin/bash

_tag="stable"
echo "Removing existing deb installation of neovim"
sudo dnf -y remove neovim
echo "Cloning neovim repository and checking out ${_tag}"
git clone https://github.com/neovim/neovim && cd neovim && git checkout ${_tag}
echo "Building neovim"
make CMAKE_BUILD_TYPE=Release
echo "Creating deb package and installing"
cd build
cpack -G RPM
sudo dnf install nvim-linux-x86_64.rpm
cd ../..
rm -rf neovim nvim-linux-x86_64.rpm
echo "Removing neovim from vim alternatives with update-alternatives"
sudo update-alternatives --remove vim /usr/bin/nvim
echo "Excluding neovim from dnf updates"
sudo echo "exclude=neovim" >> /etc/dnf/dnf.conf

