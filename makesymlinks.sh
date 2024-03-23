#!/bin/bash

##### VARIABLES
DOTFILES_DIR=$(pwd)

function link_file {
    dest="${HOME}/${1}"
    date_str=$(date +%Y-%m-%d-%H%M)
    if [ -h ~/${1} ]; then
      # Existing symlink 
      echo "Removing existing symlink: ${dest}"
      rm ${dest} 

    elif [ -f "${dest}" ]; then
      # Existing file
      echo "Backing up existing file: ${dest}"
      mv ${dest}{,.${date_str}}

    elif [ -d "${dest}" ]; then
      # Existing dir
      echo "Backing up existing dir: ${dest}"
      mv ${dest}{,.${date_str}}
    fi

    echo "Creating new symlink: ${dest}"
    ln -s ${DOTFILES_DIR}/${1} ${dest}

    echo
}

FILES=".bashrc .vimrc .vim .tmux.conf"

for file in $FILES; do
    link_file $file
done

