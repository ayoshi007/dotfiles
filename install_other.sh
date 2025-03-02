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
	sudo dpkg -i --force-overwrite nvim-linux-x86_64.deb
	cd ../..
	rm -rf neovim nvim-linux64*
}

function install_ohmyzsh {
	echo "Making zsh the default shell"
	chsh -s $(which zsh)

	if [ -d "${MYHOME}/.oh-my-zsh" ]; then
		yes_or_none "Removing existing ~/.oh-my-zsh?" && rm -rf "${MYHOME}/.oh-my-zsh"
	fi

	echo "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	if yes_or_none "Stow adopt home config to ${MYHOME}?" ; then
		sudo stow --adopt home -t "${MYHOME}"
		echo "Done"
		yes_or_none "Restore source controlled configs?" && git restore ./home && echo "Done"
	fi
}

function install_rustup {
	echo "Installing rustup"
	curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable --profile default
}


function install_tmux_plugin_manager {
	echo "Installing tmux-plugin-manager (tpm)"
	if [ -d "${MYHOME}/.config/tmux/plugins/tpm" ]; then
		yes_or_none "Removing existing ~/.config/tmux/plugins/tpm?" && rm -rf "${MYHOME}/.config/tmux/plugins/tpm"
	fi
	git clone --depth=1 https://github.com/tmux-plugins/tpm $MYHOME/.config/tmux/plugins/tpm
	echo "Done"
}

function install_sdkman {
	if [ -d "${MYHOME}/.sdkman" ]; then
		yes_or_none "Removing existing ~/.sdkman?" && rm -rf "${MYHOME}/.sdkman"
	fi

	curl -s "https://get.sdkman.io" | bash
	source "$MYHOME/.sdkman/bin/sdkman-init.sh"
	sdk version
}

function install_nvm {
	if [ -d "${MYHOME}/.nvm" ]; then
		yes_or_none "Removing existing ~/.nvm?" && rm -rf "${MYHOME}/.nvm"
	fi
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
	command -v nvm
}

function install_pyenv {
	if [ -d "${MYHOME}/.pyenv" ]; then
		yes_or_none "Removing existing ~/.pyenv?" && rm -rf "${MYHOME}/.pyenv"
	fi
	if yes_or_none "Install Python build dependencies?" ; then
		sudo apt install -y make build-essential libssl-dev \
			zlib1g-dev libbz2-dev libreadline-dev \
			libsqlite3-dev wget curl llvm \
			libncurses5-dev libncursesw5-dev xz-utils \
			tk-dev libffi-dev liblzma-dev python3-openssl
	fi
	curl https://pyenv.run | bash
}

yes_or_none "Install neovim?" && install_neovim
yes_or_none "Install ohmyzsh?" && install_ohmyzsh
yes_or_none "Install rustup?" && install_rustup
yes_or_none "Install tmux plugin manager?" && install_tmux_plugin_manager
yes_or_none "Install sdkman?" && install_sdkman
yes_or_none "Install nvm?" && install_nvm
yes_or_none "Install pyenv?" && install_pyenv
