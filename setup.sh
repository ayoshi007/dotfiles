#!/bin/bash

# run script as superuser
apt install stow
files="bash neovim vim tmux git"

# back up and make stow symlinks for files
for file in ${files}; do
	echo "Creating stow symlink for ${file}..."
	stow "$file" -t ~
done


echo "Getting plugins managers"
# tmux plugin manager
echo "Installing tmux-plugin-manager (tpm)... "
#git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
echo "done"



