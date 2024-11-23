#!/bin/bash

. ./utils.sh

function install_neovim {
	echo "Removing existing deb installation of neovim"
	sudo apt -y remove neovim
	echo "Cloning neovim repository and checking out nightly"
	git clone https://github.com/neovim/neovim && cd neovim && git checkout nightly
	echo "Building neovim"
	make CMAKE_BUILD_TYPE=Release
	echo "Creating deb package and installing"
	cd build
	cpack -G DEB
	sudo dpkg -i --force-overwrite nvim-linux64.deb
	cd ../..
	rm -rf neovim nvim-linux64*
}

function install_ohmyzsh {
	echo "Making zsh the default shell"
	$SUDOME chsh -s $(which zsh)

	if [ -d "${MYHOME}/.oh-my-zsh" ]; then
		yes_or_none "Removing existing ~/.oh-my-zsh?" && rm -rf "${MYHOME}/.oh-my-zsh"
	fi

	echo "Installing oh-my-zsh"
	$SUDOME sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

function install_rustup {
	echo "Installing rustup"
	curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable --profile default
}


function install_tmux_plugin_manager {
	echo "Installing tmux-plugin-manager (tpm)"
	git clone --depth=1 https://github.com/tmux-plugins/tpm $MYHOME/.config/tmux/plugins/tpm
}

function install_sdkman {
	if [ -d "${MYHOME}/.sdkman" ]; then
		yes_or_none "Removing existing ~/.sdkman?" && rm -rf "${MYHOME}/.sdkman"
	fi

    $SUDOME curl -s "https://get.sdkman.io" | $SUDOME bash
    source "$MYHOME/.sdkman/bin/sdkman-init.sh"
    sdk version
}

yes_or_none "Install neovim?" && install_neovim
yes_or_none "Install ohmyzsh?" && install_ohmyzsh
yes_or_none "Install rustup?" && install_rustup
yes_or_none "Install tmux plugin manager?" && install_tmux_plugin_manager
yes_or_none "Install sdkman?" && install_sdkman
